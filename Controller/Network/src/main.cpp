/*
 Web Server

 A simple web server that shows the value of the analog input pins.
 using an Arduino WIZnet Ethernet shield.

 Circuit:
 * Ethernet shield attached to pins 10, 11, 12, 13
 * Analog inputs attached to pins A0 through A5 (optional)

 created 18 Dec 2009
 by David A. Mellis
 modified 9 Apr 2012
 by Tom Igoe
 modified 02 Sept 2015
 by Arturo Guadalupi
 
 */

#include <SPI.h>
#include <Ethernet.h>
#include <mainHeader.h>
// Can't use port 10, 11, 12 and 13
// Enter a MAC address and IP address for your controller below.
// The IP address will be dependent on your local network:
byte mac[] = {
  0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED
};
IPAddress ip(192, 168, 1, 18);

// Initialize the Ethernet server library
// with the IP address and port you want to use
// (port 80 is default for HTTP):
EthernetServer server(80);

void setup() {
  // You can use Ethernet.init(pin) to configure the CS pin
  //Ethernet.init(10);  // Most Arduino shields
  //Ethernet.init(5);   // MKR ETH Shield
  //Ethernet.init(0);   // Teensy 2.0
  //Ethernet.init(20);  // Teensy++ 2.0
  //Ethernet.init(15);  // ESP8266 with Adafruit FeatherWing Ethernet
  //Ethernet.init(33);  // ESP32 with Adafruit FeatherWing Ethernet

  // Open serial communications and wait for port to open:
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }
  Serial.println("Ethernet WebServer Example");

  // start the Ethernet connection and the server:
  Ethernet.begin(mac, ip);

  // Check for Ethernet hardware present
  if (Ethernet.hardwareStatus() == EthernetNoHardware) {
    Serial.println("Ethernet shield was not found.  Sorry, can't run without hardware. :(");
    while (true) {
      delay(1); // do nothing, no point running without Ethernet hardware
    }
  }
  if (Ethernet.linkStatus() == LinkOFF) {
    Serial.println("Ethernet cable is not connected.");
  }

  // start the server
  server.begin();
  Serial.print("server is at ");
  Serial.println(Ethernet.localIP());
}


void loop() {
  // listen for incoming clients
  EthernetClient client = server.available();
  if (client) {
    Serial.println("new client");
    // an HTTP request ends with a blank line
    bool currentLineIsBlank = true;
    while (client.connected()) {
      if (client.available()) {
        char c = client.read();
        Serial.write(c);
        // if you've gotten to the end of the line (received a newline
        // character) and the line is blank, the HTTP request has ended,
        // so you can send a reply
        if (c == '\n' && currentLineIsBlank) {
          
          digitalWrite(A5, LOW);
          digitalWrite(A4, LOW);
          digitalWrite(A2, LOW);
          // send a standard HTTP response header
          CreateHTMLHeader(client);
          

          /* Local Variables */
          float LM335_Temp = 0.0f;

          uint16_t temp = analogRead(A0);
          /* Convert the raw ADC value to Temperature in Kelvin */
          LM335_Temp = ((float)( temp * 5 ) / 1023) * 100;
		
          /* Convert the Temperature in Kelvin to Celsius */
          LM335_Temp = LM335_Temp - 273.15;
          
          // Decide LED and flavour text by checking calculated temperature in Celsius
          String colour;
          String status;

          if (LM335_Temp < 39) {
            pinMode(A5, OUTPUT);
            digitalWrite(A5, HIGH);
            colour = "yellow";
            status = "Absolute zero";
          } else if (LM335_Temp > 44) {
            pinMode(A4, OUTPUT);
            digitalWrite(A4, HIGH);
            colour = "red";
            status = "Schorching hot";
          } else {
            pinMode(A2, OUTPUT);
            digitalWrite(A2, HIGH);
            colour = "green";
            status = "Perfect";
          }

          CreateSVGAndStatus(client, colour, status);
          client.println("<h2>Temperature: " + String(LM335_Temp) + "</h2>");
          // output the value of each analog input pin
          
          client.println("</html>");
          break;
        }
        if (c == '\n') {
          // you're starting a new line
          currentLineIsBlank = true;
        } else if (c != '\r') {
          // you've gotten a character on the current line
          currentLineIsBlank = false;
        }
      }
    }
    // give the web browser time to receive the data
    delay(1);
    // close the connection:
    client.stop();
    Serial.println("client disconnected");
  }
}



void CreateSVGAndStatus(EthernetClient client, String colour, String status){
  client.println("<svg height=\"60\" width=\"200\">");
  client.println("<text x=\"0\" y=\"15\" fill=\"" + colour + "\" transform=\"rotate(30 20,40)\">I love SVG</text>");
  client.println("</svg>");
  client.println("<br/>");
  client.println("<h2>Status: " + status + "</h2>");
}

void CreateHTMLHeader(EthernetClient client){
  client.println("HTTP/1.1 200 OK");
  client.println("Content-Type: text/html");
  client.println("Connection: close");  // the connection will be closed after completion of the response
  client.println("Refresh: 5");  // refresh the page automatically every 5 sec
  client.println();
  client.println("<!DOCTYPE HTML>");
  client.println("<html>");
}
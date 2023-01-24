#include <SPI.h>
#include <Ethernet.h>

void CreateSVGAndStatus(EthernetClient client, String colour, String status);
void CreateHTMLHeader(EthernetClient client);
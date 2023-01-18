#include <wire.h>

int getTemp(int output){
    double Temp;
    Temp = log(((10240000/output) - 10000));
    Temp = 1 / (0.001129148 + (0.000234125 + (0.0000000876741 * Temp * Temp ))* Temp );
    Temp = Temp - 273.15;            // Convert Kelvin to Celsius
    return Temp;
}
// source: http://blog.gagalabs.com/post/86897688614/capacitive-distance-sensing-with-the-mpr121-and
// This gives an example of distance sensing.

#include "mpr121.h"
#include "i2c.h"

// only needed if you want to use difference with previous values
int lastMeasurement[12];


void setup()
{
  //configure serial out
  Serial.begin(57600);
  
  // initalize I2C bus. Wiring lib not used. 
  i2cInit();
  
  // initialize mpr121
  mpr121QuickConfig();

  for (int i=0; i < 12; i++) { 
    lastMeasurement[i] = 0;
  }
  
  Serial.println("Ready...");
}

void loop()
{

  for (int i=0; i < 12; i++) { 
    Serial.print(getSensorMeasurement(i)); //-lastMeasurement[i]);
    Serial.print(",");

    lastMeasurement[i] = getSensorMeasurement(i);
  }
  
  Serial.println();
  delay(25);
}

int getSensorMeasurement(byte sensorNumber)
{
  int value = mpr121Read2Bytes(0x04 + (sensorNumber << 1));  
  return value;
}

void mpr121QuickConfig(void)
{
  // reset (in case already running)
  mpr121Write(0x80, 0x63);

  // auto config off  
  mpr121Write(ATO_CFG0, 0x00);
  
  // big sensors, use max charge current
  // FFI = 00 (default)
  // CDC = 111111
  //mpr121Write(0x5C, 0x3F);
  mpr121Write(0x5C, 0xFF);

  // CDT=011 charge time, use the one that fits the size of your sensor best
  // SFI=00 (default)
  // ESI=100 (default)
  mpr121Write(0x5D, 0x24); // CDT=001
  //mpr121Write(0x5D, 0x24); // CDT=001
  //mpr121Write(0x5D, 0x44); // CDT=010
  //mpr121Write(0x5D, 0x64); // CDT=011
  //mpr121Write(0x5D, 0x84); // CDT=100
  
  // Electrode Configuration
  mpr121Write(ELE_CFG, 0x0C);	// Enables all 12 Electrodes
  //mpr121Write(ELE_CFG, 0x01);  // Enable first electrode only
  //mpr121Write(ELE_CFG, 0x0B);  // Enable first electrode only
}

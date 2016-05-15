// http://processing.org/reference/loadImage_.html
// http://processing.org/reference/tint_.html

// pictures from movie:
// https://www.flickr.com/photos/vicjuan/11199046046/in/photolist-i4C3dN-6N4gMR-c7PqqN-iX3cv1-8We6Sx-fSv6v2-guoeW8-8MD6Bt-baYkFc-oMRtxz-8EmfAp-bVMr3G-8ohHKf-8MoHmA-ptFn9F-8R9BmQ-aqbzP4-dn6EgZ-dDyzaw-dH4fHx-8mTDnf-4JJtSD-dV5JVy-hFmxpM-8Nybff-pjkXqV-awBwd1-9Mb4y6-bvgnsr-azZALt-91HYGp-gjV1L1-9CWGvp-huBkKZ-oXSFSY-bUntgG-iTzCEk-cRAcbf-c6APeb-hDxJMM-4WGCmU-ofWs1k-g9Qtao-53ihSg-5sSDf8-aYS85a-nv6jKH-nmAA7L-nB5G5U-iKpQHe
// Chao-Wei Juan - november 30, 2013

import processing.serial.*;
import cc.arduino.*;

Arduino arduino;

PImage day;
PImage night;

int ldrPin = 2; // LDR connected to analog pin A2.
int ldrValue; 

int ldrMinValue = 240;
int ldrMaxValue = 800;

float blendFactor;

void setup() {
  size(1280,720);
  
  // function to automatically connect to Arduino
  // located in ArduinoHelperFunctions.pde
  connectArduino();
  
  // other manual possibility:
  
    // Prints out the available serial ports.
    //printArray(Arduino.list());
    
    // Modify this line, by changing the "0" to the index of the serial
    // port corresponding to your Arduino board (as it appears in the list
    // printed by the line above).
    //arduino = new Arduino(this, Arduino.list()[0], 57600);
  
  // set inputs and outputs to the default of the KNT/ANT sensor shield
  setupArduinoDigitalPins();
  
  day   = loadImage("sunset-day.jpg");
  night = loadImage("sunset-night.jpg");
}

void draw() {
  
  // read sensors from Arduino
  readInputsAndProcess();
  
  // do something with the outputs
  writeOutputs();
  
  // display the images
  display();  
}

void readInputsAndProcess() {
  // read the analog pin with the LDR (set in the pinLDR variable). 
  // store it in the ldrValue variabele;
  ldrValue = arduino.analogRead(ldrPin);
  println("ldrValue: "+ldrValue);
  
  // for blending we need a value between 0 and 255. So we use map. 
  // this range can also be used to dim a led
  blendFactor = map(ldrValue, ldrMinValue, ldrMaxValue, 255, 0);
    
  println("blendFactor:"+blendFactor);
  
  // we can use constrain to prevent that numbers get higher then 255
  // or lower then 0 (because the ldrMin and ldrMax can depend on the situation). 
  blendFactor = constrain(blendFactor,0,255);
}

void display() {
  // reset tint fill
  noTint(); 
  
  // display day image
  image(day,0,0,width,height); 
  
  // apply transparency to night image (alpha 0 - 255)
  // here we use the variable
  
  tint(255,blendFactor); 
  
  // display night image
  image(night,0,0,width,height);  
}

void writeOutputs() {
  
    int ledOneValue = (int) blendFactor;
    int ledTwoValue = 255 - (int) blendFactor; // invert
  
    arduino.analogWrite(10, ledOneValue);
    arduino.analogWrite(11, ledTwoValue);
  
}

void setupArduinoDigitalPins() {
  // set inputs and outputs like the default sensor/actuator shield 
  // made during the Project Exhibition lessons
  // you can change this of course for your particular project
  
  arduino.pinMode( 2, Arduino.INPUT ); // button 
  arduino.pinMode( 3, Arduino.INPUT ); // button 
  arduino.pinMode( 4, Arduino.SERVO);  // servo
  arduino.pinMode( 7, Arduino.SERVO);  // servo
  arduino.pinMode( 8, Arduino.SERVO);  // servo
  arduino.pinMode( 5, Arduino.OUTPUT );  // output (PWM)
  arduino.pinMode( 6, Arduino.OUTPUT );  // output (PWM)
  arduino.pinMode( 9, Arduino.OUTPUT );  // output (PWM)
  arduino.pinMode( 10, Arduino.OUTPUT ); // output (PWM)
  arduino.pinMode( 11, Arduino.OUTPUT ); // output (PWM)
  arduino.pinMode( 12, Arduino.OUTPUT ); // output
  arduino.pinMode( 13, Arduino.OUTPUT ); // output
}
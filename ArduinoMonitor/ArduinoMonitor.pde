/*  
Documentation of the Arduino library:
http://playground.arduino.cc/Interfacing/Processing

Use the Arduino software, to upload the StandardFirmata example 
(located in Examples > Firmata > StandardFirmata) to your Arduino board.

With the ArduinoHelperFunctions you can detect the Arduino automatically. 

This sketch is also an example to automatically reconnect your Arduino, 
when disconnected. 
*/

import processing.serial.*;
import cc.arduino.*;

Arduino arduino;

ValueMonitor [] valueMonitorArray = new ValueMonitor[18];

void setup() {
  size( 800, 700);
  frameRate(25);
  
  if(connectArduino()) setupArduinoDigitalPins(); 
  
  for ( int i = 0; i < valueMonitorArray.length; i++ ) {
    if(i<6) {
      valueMonitorArray[i] = new ValueMonitor(62, 33 + (i * 54), 200, 46, "Arduino A" + nfc(i));
    }
    else {
      valueMonitorArray[i] = new ValueMonitor(463, 33 + ((i-6) * 54), 200, 46, "Arduino D" + nfc(i-4));
    }
  }
}

void draw() {
  
  displayArduinoMonitor();

}

void displayArduinoMonitor() {
    
    color off = color(  4,  79, 111 );
    color on  = color( 84, 145, 158 );
    
    tryReConnectIfDisconnected();
    
    background( off );
  
    if ( arduino != null ) {
      
        textAlign(LEFT, TOP);
        text("Arduino Connected.", 10, 10);

        int value;
      
        for(int i = 0; i< valueMonitorArray.length; i++) {
         
          if(i < 6) {
            
            value = arduino.analogRead(i);
            valueMonitorArray[i].addValue(value);
            float mappedValue = map(value, 0, 1023, 0, 40);
            
            fill( on );
            stroke( on );
            ellipse (34, 56 + (i * 54), mappedValue, mappedValue);
          }
          else {
            value = arduino.digitalRead(i-4);
            
            valueMonitorArray[i].addValue(value);
            
            stroke( on );
            if ( value == Arduino.HIGH )  fill(  on );
            else                          fill( off );
    
            rect( 413, 36 + ((i-6) * 54), 40, 40 );
            
          }
         
          valueMonitorArray[i].display();
        } 
    }
    else {
      textAlign(LEFT, TOP);
      text("Arduino disconnected.", 10, 10);
    }
}

void tryReConnectIfDisconnected(){
  
    // in case you remove the Arduino, it will be re-connected 
    try {
      if(connectArduino()) setupArduinoDigitalPins();  
    }
    catch( Exception exception ) {
       println( "Exception :'"  + exception + "'" );
    }
    catch( Error error ) {
       println( "Exception :'"  + error + "'" );
    }
}

void setupArduinoDigitalPins() {
    // since it's a monitor we assume all digital pins are inputs
    for ( int i = 2; i <= 13; i++ ) {
       arduino.pinMode( i, Arduino.INPUT );       
    }
}
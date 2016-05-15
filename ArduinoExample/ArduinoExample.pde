/*  
Documentation of the Arduino library:
http://playground.arduino.cc/Interfacing/Processing

Use the Arduino software, to upload the StandardFirmata example 
(located in Examples > Firmata > StandardFirmata) to your Arduino board.

With the ArduinoHelperFunctions you can detect the Arduino automatically. 

When you connect a servo connect an external power supply as well.
*/

import processing.serial.*;
import cc.arduino.*;

// Arduino object
Arduino arduino;

// Store on which pin you've connected your sensors
int potmeterPin = 0; // analog 0
int button1Pin  = 2; // digital 2

// Variables to store the incoming values
int button1Value;
int potmeterValue;

// Variables to store the outgoing values
int led13Value; // 0 or 1
int led11Value; // 0 - 255
int servo8Value; // 0 - 180

void setup() {
  
  size( 470, 280 );
  frameRate(25);
  
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
    
  // configure the digital input and output pins
  setupArduinoDigitalPins();
}

void draw() {
  
  tryReConnectIfDisconnected();
  
  if(arduino !=null) {
    // read Arduino inputs and store it in a variable
    button1Value  = arduino.digitalRead(2);
    potmeterValue = arduino.analogRead(0);
    
    println("button 1: "+ button1Value);
    println("potmeter: "+ potmeterValue);
      
    // process the inputs (map, smooth)
    // "connect" the led directly to the button
    led13Value = button1Value;
    
    // analogWrite (PWM) accepts values from 0 - 255. 
    // analogRead gives values from 0 - 1023. 
    // we need to map a range from 0 - 1023 to 0 - 255.
    led11Value = (int) map(potmeterValue, 0, 1023, 0, 255);
    
    // our servo needs values in the range of 0 - 180
    // we map the potmeterValue to that range
    servo8Value = (int) map(potmeterValue, 0, 1023, 0, 180);
    
    // display things
    // use led11Value also for the background
    background(0,led11Value,0);
    
    // use led13Value to display a ellipse
    if(led13Value == 1) ellipse(width/2, height/2, 50, 50);
      
    // write to Arduino outputs.
    arduino.servoWrite(8, servo8Value);
    arduino.analogWrite(11, led11Value);
    arduino.digitalWrite(13, led13Value);
  }
}

void tryReConnectIfDisconnected() {
  
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

// function to smooth a value
// for example a light or distance sensor
// not used in this example but handy for the future. 
// factor is a value between 0.0 and 1.0. Start with 0.5. Lower returns more of the oldValue. 
// Higher returns more of the newValue.
float applySmoothening(float oldValue, float newValue, float factor) {
  return factor * oldValue + ( 1 - factor ) * newValue;
}
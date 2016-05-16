/*  Processing code for Processing Arduino communication

    If you would like to use Arduino as a sensor and actuator board. I recommend the Arduino library that uses Firmata. 
    
    However if you would like to do some processing on the Arduino and use Arduino libraries you would like to send and 
    receive values as well. This example shows how to send values from Processing to Arduino and back. Use it to prototype your
    own application.
    
    It uses a 'call and response' principle. Processing sends data (outgoingValues) to Arduino and Arduino responds with certain values
    that you want to receive. The communication is initiated by Processing and depends on the framerate (60fps by default, now 25fps).
    
    processing_arduino_communication.pde is the Processing code.
    arduino_processing_communication.ino is the Arduino code.
    
    Copyleft: kasperkamperman.com - 9-06-2015
*/

// make sure you install the Serial library. 
import processing.serial.*;

// documentation of Serial libary: https://processing.org/reference/libraries/serial/index.html
// although we can work with bytes we use strings to keep everything human readable

// Serial port object
Serial serialPort;  

// Amount of values you expect to receive
int amountOfValues = 8;

// to store values received from the input.
// modify the length for the amount of values you expect to receive.
int [] incomingValues = new int[amountOfValues];

// modify the length if you want to send more outgoing values (or less)
// as example we send the mouseX coordinate mapped to 0 - 255
// in the Arduino example we use this value to control LEDs on pin 10 and 11. 
int [] outgoingValues = new int[2];

// use a ValueMonitor to graphically display incoming values
// of course this is optional
ValueMonitor [] valueMonitorArray = new ValueMonitor[amountOfValues];

void setup() {
  size(640, 480);  
  frameRate(25);

  // Print a list of the serial ports, for debugging purposes:
  printArray(Serial.list());

  // change the index number to the port where the Arduino is connected
  String portName = Serial.list()[0];
  serialPort = new Serial(this, portName, 57600);
  // flush buffer: throw away old values still in the buffer
  serialPort.clear();            
  
  // set buffer full flag on receipt of a newline (println from Arduino).
  // the serialEvent is only triggered when a newline is received.
  serialPort.bufferUntil(10); 
  
  // place ValueMonitor objects on the screen, for some graphical feedback
  for(int i = 0; i<valueMonitorArray.length; i++) {
      // parameters: x position, y position, width, height, id
      valueMonitorArray[i] = new ValueMonitor(8, 8 + (i * 58), 250, 50, nfc(i));
  }  
}

void draw() {
  background(128);
  
  // show incoming values on the ValueMonitors
  displayValueMonitors();
  
  // if you would like to do something with a value from the Arduino, just use the array
  // like:
  println(incomingValues[0]);
  
  // we use the mouseX, mouseY and map it to 0 - 255 to control a LED on pin 10 and pin 11
  outgoingValues[0] = int(map(mouseX, 0, width, 0, 255));
  outgoingValues[1] = int(map(mouseY, 0, height, 0, 255));
  
  // send output values to the Arduino
  // if you don't have output values just send a newline
  //String outgoingData = "\n";
  String outgoingData = join(nf(outgoingValues, 0), ",") + "\n"; 
  
  // send the data to the serial port
  serialPort.write(outgoingData);
}

// when there is data available the serialEvent is triggered.
void serialEvent(Serial port) {
  
  // read the string untill the newline character (println) Arduino
  String incomingData = port.readStringUntil(10);
  
  if(incomingData != null) {
  
    // Remove whitespace characters from the beginning and end of the string with trim()
    incomingData        = trim(incomingData);
    
    // Break the String into pieces using the comma character with split()
    // Use shorten() to remove the last element. Since this is empty (,) at the end
    String[] incomingString = split(incomingData, ',');
    
    // Show a warning if the length of the data is longer than our incomingValues array length
    if(incomingString.length != incomingValues.length) {
        println("WARNING: more or less incoming values. Change the incomingValues array size to: " + incomingString.length);
    }
    else {
      // convert the string to integers and store it in the incoming values array
      incomingValues = int(incomingString);
      
      // Show the values in the console for debugging
      //printArray(incomingValues);  
    }
  }
}

void displayValueMonitors() {
   // optional display of incoming values
  for(int i = 0; i<valueMonitorArray.length; i++) {
      // add the values to our monitor objects
      // make sure that the incomingValues has the same length or is bigger then the valueMonitorArray
      valueMonitorArray[i].addValue(incomingValues[i]);
      valueMonitorArray[i].display();    
  }
}

/*  If you would like to use Arduino as a sensor and actuator board. I recommend the Arduino library that uses Firmata. 
    
    However if you would like to do some processing on the Arduino and use Arduino libraries you would like to send and 
    receive values as well. This example shows how to send values from Processing to Arduino and back. Use it to prototype your
    own application.
    
    It uses a 'call and response' principle. Processing sends data (outgoingValues) to Arduino and Arduino responds with certain values
    that you want to receive. The communication is initiated by Processing and depends on the framerate (60fps by default, now 25fps).
    
    processing_arduino_communication.pde is the Processing code.
    arduino_processing_communication.ino is the Arduino code.
    
    Copyleft: kasperkamperman.com - 9-06-2015
*/

// we control two leds as an example on how to process incoming data
int led10Value = 0;
int led11Value = 0;

void setup() {
  // Initiate Serial Communication
  Serial.begin(57600); 
  // make time out lower for parseInt function
  Serial.setTimeout(10);
  
  // Set pin 2 and 3 as inputs
  pinMode(2, INPUT);
  pinMode(3, INPUT);
  
  // Set pin 10 and 11 as output
  pinMode(10, OUTPUT);
  pinMode(11, OUTPUT);
}
  
void loop() {
  
  // check if we have incoming data on our serialport
  while(Serial.available() > 0) {
    
    // check if we have an empty string
    // we use this as a trigger to send our sensor data to Processing
    // Serial.peek doesn't remove a character from the buffer
    if (Serial.peek() == '\n') {
      // empty the buffer
      while( Serial.read() != -1 ); 
     
      sendData();      
    }
    else {
      
      // We have data. Do something with it...
      
      // parserInt: http://www.arduino.cc/en/Serial/ParseInt
      // make sure that you read all the ints (separated with a comma) that you 
      // send. Otherwise the function blocks.. and you won't receive data in Processing.
      
      // modify this to store all your values!      
      led10Value = Serial.parseInt(); 
      led11Value = Serial.parseInt(); 
      
      // when we received the newline character
      // we process the message and send our sensor data
      if (Serial.read() == '\n') {
         analogWrite(10, led10Value);
         analogWrite(11, led11Value);    
       
         sendData();  
      }
    }    
  } 
}

void sendData() {
  
  int amountOfAnalogInputs = 6;
  
  for ( int i = 0; i < amountOfAnalogInputs; i++) {
    Serial.print( analogRead(i) );
    
    // if necessary only print a comma between values and not at
    // the end
    //if(i!=amountOfAnalogInputs-1) {
      Serial.print(',');
    //}
  }
  
  // print digitalInputs
  Serial.print(digitalRead(2));
  Serial.print(',');
  Serial.print(digitalRead(3));
  
  // always end with a newline/carriage return
  // our Processing code looks for this before processing the data.
  Serial.println(); 
}

import processing.serial.*;

Serial myPort;
int x = 0;

ValueMonitor [] valueMonitorArray = new ValueMonitor[12];

void setup() 
{
  size(1000, 800);
  printArray(Serial.list());  //list of available serial ports
  String portName = Serial.list()[7]; //replace 0 with whatever port you want to use.
  myPort = new Serial(this, portName, 57600);
  
  fill(0);
  stroke(0);
  
  for(int i = 0; i<valueMonitorArray.length; i++) {
      valueMonitorArray[i] = new ValueMonitor(8, 8 + (i * 58), 250, 50, nfc(i));
  }  
}


void draw() 
{ background(0);
  for(int i = 0; i<valueMonitorArray.length; i++) {
      valueMonitorArray[i].display();    
  }
}

void serialEvent(Serial port) 
{
  try {
  
     // read the string untill the newline character (println) Arduino
    String incomingString = port.readStringUntil(10);
    
    if(incomingString != null) {
      //println(incomingData);
      
      // Remove whitespace characters from the beginning and end of the string with trim()
      incomingString        = trim(incomingString);
      
      // Break the String into pieces using the comma character with split()
      // Use shorten() to remove the last element. Since this is empty (,) at the end
      String[] incomingData = split(incomingString, ',');
     
      //printArray(incomingData);
      
      if(incomingData.length>=valueMonitorArray.length) {
        for(int i = 0; i<valueMonitorArray.length; i++) {
          valueMonitorArray[i].addValue(int(incomingData[i]));  
        }
      }
    }
  }
  catch (Exception e) {
    //println(e);
    println("Monitors still initializing");
    // decide what to do here
  }  
  
}
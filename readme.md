#In the Processing-Arduino repo we placed several small projects with a specific function. ## ArduinoCapacitiveSensingWithMPR121 
This project makes it possible to use the 12 input values of the MKR121 touch sensor (connected to an Arduino) In processing by serial communication using CSV (1,2 …).  Only the 12 sensor values are send to processing. In processing a monitor with all values is shown. 
---## ArduinoSerialCommunication
 This project makes it possible to use the Arduino in processing by serial communication using CSV (1,2 …) and not firmata.  Only two digital input values are send to processing and processing sends two output values based on the mouse coordinates. In processing a monitor with the input values is shown.
 ---## ArduinonicationFirmataExample
This project is a simple Processing sketch that communicates with an Arduino that runs the standardFirmata on board.  The sketch uses two inputs and two outputs from the Arduino.  
---## ArduinonicationFirmataExample
This project is a simple Processing sketch that communicates with an Arduino that runs the standardFirmata on board.  The sketch uses all the I/O pins (except 0 and 1)  as an input. The sketch shows the values in different visuals.  
---## ArduinonicationFirmataSunsetExample
This project is a simple Processing sketch that communicates with an Arduino that runs the standardFirmata on board.  The sketch uses all the I/O pins (except 0 and 1)  and the pinMode can be set in the code. The sketch shows a skyline with a sunset controlled by an input. tint() is used to make it possible.  Also two leds are controlled.
---  ## Neopixel
This project makes it possible to control the Neopixel leds (FastLed library) connected to an Arduino from within processing. An analog input, a digital input, a servo output, a digital output and the neopixel strip is used.  
---
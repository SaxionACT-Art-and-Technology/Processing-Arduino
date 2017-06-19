#In the Processing-Arduino repo we placed several small projects with a specific function. ## ArduinoCapacitiveSensingWithMPR121 
This project makes it possible to use the 12 input values of the MKR121 touch sensor (connected to an Arduino) In Processing by serial communication using CSV (1,2 …).  Only the 12 sensor values are send to Processing. In Processing a monitor with all values is shown. 
---## ArduinoSerialCommunicationWithoutFirmata
 This project makes it possible to use the Arduino in Processing by serial communication using CSV (1,2 …) and not firmata.  Only two digital input values are send to Processing and Processing sends two output values based on the mouse coordinates. In Processing a monitor with the input values is shown.
 ---## ArduinoFirmataExample
This project is a simple Processing sketch that communicates with an Arduino that runs the standardFirmata on board.  The sketch uses two inputs and two outputs from the Arduino.  
---## ArduinoFirmataMonitor
This project is a simple Processing sketch that communicates with an Arduino that runs the StandardFirmata on board. The sketch uses all the I/O pins (except 0 and 1) as an input. The sketch shows the values in different visuals. So you can quicly check if your inputs work. 
---## ArduinoFirmataSunsetExample
This project is a simple Processing sketch that communicates with an Arduino that runs the standardFirmata on board.  The sketch uses all the I/O pins (except 0 and 1)  and the pinMode can be set in the code. The sketch shows a skyline with a sunset controlled by an input. tint() is used to make it possible.  Also two leds are controlled.
---  ## Neopixel / FastLED
This project makes it possible to control the Neopixel leds (FastLed library) connected to an Arduino from within Processing. A simple protocol is used to control and read inputs and outputs. Nonetheless, if you don't use led pixels or other "exotic" sensors, Firmata might be the best choice. 
An analog input, a digital input, a servo output, a digital output and the Neopixel strip is used.  
---
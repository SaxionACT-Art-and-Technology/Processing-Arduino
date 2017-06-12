// ------------------------------------------------------------------------------
// File:        NeopixelSerialDuplex.ino
//
// Version:     1.0
// Author:      Douwe A. van Twillert - Art & Technology, Saxion
// License:     Released under MIT license: http://www.opensource.org/licenses/mit-license.php
// Copyright:   Copyright (C) 2017
//
// Description: Defines an example program and protocol to connect the Arduino
//              to processing and send messages both ways.
//              Uses 8 neopixels on pin 7, a servo on pin 9 and the led on pin 13
//              The potmeter is connected to A0 and a button to digital pin 2
// ------------------------------------------------------------------------------

#include <Servo.h>
#include "HardwareSerial.h"

// ==========  CONSTANTS  ==========
const char NEWLINE = '\n';

const int FRAME_DELAY = 49;  // will most likely work out as a 20 times per second update rate
const int D2 = 2;
const int SERVO_PIN =  4;
const int   LED_PIN = 13;


// ==========  VARIABLES  ==========
Servo servos[1];
long nextTimeExecuteInMillis = 0;
boolean isConnected = false;


// ==========  FUNCTIONS  ==========
void setup() {
    delay( 2000 );             // a start delay to ensure flashing the arduino is easy
    Serial.begin( 9600 );      // start serial port at 9600 bps
    initNeopixelStrip();
    servos[0].attach( SERVO_PIN );     // this makes the 1st servo (at index 0) attach to pin 9
    pinMode( LED_PIN, OUTPUT );     // normal is output, but just to be sure
}


void loop() {
    long now = millis();
    if ( nextTimeExecuteInMillis <= now ) {
        readAndHandleData();
        showNeopixelStripIfChanged();
        readPinsAndSendDataToProcessing();
        nextTimeExecuteInMillis = now + FRAME_DELAY;
    }
}


void readPinsAndSendDataToProcessing() {
    // -------------------------------------------------
    // CHANGE THIS TO SEND MORE/OTHER DATA TO PROCESSING
    // -------------------------------------------------
    int potmeterValue =  analogRead( A0 );
    int   buttonValue = digitalRead( D2 );

    Serial.print( potmeterValue );
    Serial.print( "," );
    Serial.print( buttonValue );
    Serial.print( (char) NEWLINE );               // print newline to signal end of data
}






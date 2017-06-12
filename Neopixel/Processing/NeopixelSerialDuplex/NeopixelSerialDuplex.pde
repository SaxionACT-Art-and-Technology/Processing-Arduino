// ------------------------------------------------------------------------------
// File:        NeopixelSerialDuplex.pde
//
// Version:     1.0
// Author:      Douwe A. van Twillert - Art & Technology, Saxion
// License:     Released under MIT license: http://www.opensource.org/licenses/mit-license.php
// Copyright:   Copyright (C) 2017   
//
// Description: Defines an example program and protocol to connect to Arduino
//              and send messages both ways.
//              Uses 8 neopixels on pin 7, a servo on pin 4 and the led on pin 13
//              The potmeter is connected to A0 and a button to digital pin 2
//
// ------------------------------------------------------------------------------


// ==========  CONSTANTS  ==========
final int[][] RAINBOW_COLORS = {
    { 255,   0, 255 },   // violet
    {  80,   0, 255 },   // purple
    {   0,   0, 255 },   // blue
    {   0, 255, 255 },   // cyan
    {   0, 255,   0 },   // green
    { 255, 255,   0 },   // yellow
    { 255,  80,   0 },   // orange
    { 255,   0,   0 },   // red
};

final int LED_PIN = 13;

// ==========  VARIABLES  ==========

int      currentPotmeterValue = -1;
int     previousPotmeterValue = -1;
boolean  isButtonPressed = false;
boolean wasButtonPressed = true;


void setup() {
  setupSerial();
}


void draw() {
    //if ( frameCount % 3 == 0 ) {
        readDataFromArduino();
        
        if ( dataFromArduino != null && dataFromArduino.length > 1 ) {
            currentPotmeterValue   = parseInt( dataFromArduino[0].trim() );
            isButtonPressed = parseInt( dataFromArduino[1].trim() ) == 1 ? true : false;
            traceIfChanged( "potmeterValue = "   , currentPotmeterValue + "" );
            traceIfChanged( "isButtonPressed = " , isButtonPressed + ""      );
            if (    isButtonPressed != wasButtonPressed
                 || abs( currentPotmeterValue - previousPotmeterValue ) > 3 ) {
                if ( currentPotmeterValue > 1020 ) {
                    sendSetNeopixelArray( RAINBOW_COLORS );
                } else {
                    for ( int i = 0 ; i < RAINBOW_COLORS.length ; i++ ) {
                        int scaleValue = 1023 * i / RAINBOW_COLORS.length;
                        int brightnessDivider = isButtonPressed ? 2 : 4;
                
                        if ( currentPotmeterValue > scaleValue ) {
                            sendSetNeopixel( i, RAINBOW_COLORS[i][0] / brightnessDivider,
                                                RAINBOW_COLORS[i][1] / brightnessDivider,
                                                RAINBOW_COLORS[i][2] / brightnessDivider );
                        } else {
                            sendSetNeopixel( i, 0, 0, 0 );
                        }
                    }
                }
                int servoPosition = currentPotmeterValue * 180 / 1023;
                sendServoPosition( 0, servoPosition );
                previousPotmeterValue = currentPotmeterValue;
            }
            sendSetLed( LED_PIN, isButtonPressed );
            dataFromArduino = new String[0];  // remove data
        }
    //}
}
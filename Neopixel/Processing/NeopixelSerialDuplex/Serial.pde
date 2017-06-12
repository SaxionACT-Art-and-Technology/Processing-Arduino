// ------------------------------------------------------------------------------
// File:        Serial.pde
//
// Version:     1.0
// Author:      Douwe A. van Twillert - Art & Technology, Saxion
// License:     Released under MIT license: http://www.opensource.org/licenses/mit-license.php
// Copyright:   Copyright (C) 2017   
//
// Description: Initialises the serial interface and processes serial messages
//              from the Arduino.
//
// ------------------------------------------------------------------------------


import processing.serial.*;

// ==========  CONSTANTS  ==========
final char     NEWLINE = '\n';
final String[] EMPTY_STRING_ARRAY = {};


// ==========  VARIABLES  ==========
Serial serial;
String[] dataFromArduino = EMPTY_STRING_ARRAY;

final char NO_COMMAND          = ' ';
final char SET_SET_LED         = 'L';      // format: 'L'<pin_nr>=('0'|'1')
final char SET_SET_PWM         = 'P';      // format: 'P'<pin_nr>=<0-255>
final char SET_SERVO_POSITION  = 'S';      // format: 'S'<pin_nr>=<0-180>
final char SET_SINGLE_NEOPIXEL = 'N';      // format: 'N'<pin_nr>=<hex_color>
final char SET_ALL_NEOPIXELS   = 'A';      // format: 'A'<hex_color>{,<hex_color>}*
final char ILLEGAL_COMMAND     = 127;
final char RECOVERY_MODE       =   0;



boolean isConnected = false;

void setupSerial() {
    printArray( Serial.list() );
    serial = new Serial(this, Serial.list()[3], 9600 );
    serial.clear();
}



void readDataFromArduino() {
    if ( ! isConnected ) {
        connectToProcessing();
    }
    if ( serial.available() > 0 ) {
        readAndHandleData();
    }
}


void connectToProcessing() {
    if ( serial.available() > 0 ) {
        isConnected = true;   // data is available, continue with the normal program
    }
}

String receivedStringFromArduino = "";


void readAndHandleData() {
    while ( serial.available() > 0 ) { //as long as there is data coming from serial port, read it and store it 
        char receivedCharacterFromArduino = serial.readChar();
        
        if ( receivedCharacterFromArduino == NEWLINE ) {    
            receivedStringFromArduino = receivedStringFromArduino.trim();
            //println( "Data received = '" + receivedStringFromArduino + "'" );
            
            int maxLength = min( receivedStringFromArduino.length(), 5 );
            if (    receivedStringFromArduino.length() > 0
                 && receivedStringFromArduino.contains( "," )
                 && ! receivedStringFromArduino.substring( maxLength ).equals( "Error" ) ) {
                dataFromArduino = split( receivedStringFromArduino, ',' );
            }
            receivedStringFromArduino = "";
        } else {
            receivedStringFromArduino += receivedCharacterFromArduino;
        }
    }
}


void sendSetNeopixel( int pixelNr, int red, int green, int blue ) {
    sendSetNeopixel( pixelNr, color( red , green , blue , 0 ) );
}


void sendSetNeopixel( int pixelNr, color rgbColor ) {
    serial.write( "N" + pixelNr + "=" + hex( rgbColor , 6 ) + NEWLINE );
}


void sendSetNeopixelArray( int rgb[][] ) {
    serial.write( "A" );
    for ( int i = 0 ; i < rgb.length ; i++ ) {
        if ( i > 0 ) {
            serial.write( "," );
        }
        int colorValue = color( rgb[i][0] , rgb[i][1] , rgb[i][2] , 0 );
        serial.write( hex( colorValue , 6 ) );
    }
    serial.write( NEWLINE );
}


void sendSetNeopixelArray( color rgbColor[] ) {
    serial.write( "A" );
    for ( int i = 0 ; i < rgbColor.length ; i++ ) {
        if ( i > 0 ) {
            serial.write( "," );
        }
        serial.write( hex( rgbColor[i] , 6 ) );
    }
    serial.write( NEWLINE );
}


void sendSetLed( int pinNr, boolean isOn ) {
    serial.write( "L" + pinNr + "=" + ( isOn ? 1 : 0 ) + NEWLINE );
}


void sendPWM( int pinNr, int PWMvalue ) {
    serial.write( "P" + pinNr + "=" + PWMvalue + NEWLINE );
}


void sendServoPosition( int servoNr, int servoPosition ) {
    serial.write( "S" + servoNr + "=" + servoPosition + NEWLINE );
}
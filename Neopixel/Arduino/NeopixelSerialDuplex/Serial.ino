// ------------------------------------------------------------------------------
// File:        Serial.ino
//
// Version:     1.0
// Author:      Douwe A. van Twillert - Art & Technology, Saxion
// License:     Released under MIT license: http://www.opensource.org/licenses/mit-license.php
// Copyright:   Copyright (C) 2017
//
// Description: Defines a protocol to connect the Arduino to Processing and send 
//              messages both ways:
//                  SET_SET_LED          format: 'L'<pin_nr>=('0'|'1')
//                  SET_SET_PWM          format: 'N'<pin_nr>=[0-255]
//                  SET_SERVO_POSITION   format: 'S'<servo_nr>=[0-180]
//                  SET_SINGLE_NEOPIXEL  format: 'N'<pin_nr>=<hex_color>
//                  SET_ALL_NEOPIXELS    format: 'A'<hex_color>{,<hex_color>}*
// ------------------------------------------------------------------------------

// ==========  CONSTANTS  ==========
const int MINIMUM_WAIT_DELAY_FOR_SERIAL_DATA = 5;

typedef enum COMMANDS {
  NO_COMMAND          = ' ',
  SET_SET_LED         = 'L',      // format: 'L'<pin_nr>=('0'|'1')
  SET_SET_PWM         = 'P',      // format: 'N'<pin_nr>=[0-255]
  SET_SERVO_POSITION  = 'S',      // format: 'S'<servo_nr>=[0-180]
  SET_SINGLE_NEOPIXEL = 'N',      // format: 'N'<pin_nr>=<hex_color>
  SET_ALL_NEOPIXELS   = 'A',      // format: 'A'<hex_color>{,<hex_color>}*
  // ---------------------------------------
  // ADD YOUR OWN COMMANDS HERE IF NECESSARY
  // ---------------------------------------
  ILLEGAL_COMMAND     = 127,
  RECOVERY_MODE       =   0,
} Command;


// ==========  VARIABLES  ==========
boolean isRecovering = false;


// ==========  FUNCTIONS  ==========
void readAndHandleData() {
     while ( Serial.available() > 0 ) {
        isConnected = true;           // data is available, continue with the normal program
        if ( isRecovering ) {
            readAndIgnoreUntilNewline();
        } else {
            readData();
        }
    }
}


void readData() {
    int nextByte = Serial.read();
    int nr = 0;
    long value;
    switch( nextByte ) {
        case ILLEGAL_COMMAND:
        case NO_COMMAND:
            break;
        case SET_SET_LED:
            // format: 'N'<pin_nr>=['0'|'1']>
            nr = readNr( '=' );
            if ( nr != ILLEGAL_NR ) {
                value = readNr();
                digitalWrite( nr, value == 1 ? HIGH : LOW );
            }
            readAndIgnoreUntilNewline();
            
            break;
        case SET_SET_PWM:
            // format: 'N'<pin_nr>=<0-255>
            nr = readNr( '=' );
            if ( nr != ILLEGAL_NR ) {
                value = readNr();
                analogWrite( nr, value == 1 ? HIGH : LOW );
            }
            readAndIgnoreUntilNewline();
            break;
        case SET_SERVO_POSITION:
            // format: 'N'<pin_nr>=<0-255>
            nr = readNr( '=' );
            if ( nr != ILLEGAL_NR ) {
                value = readNr();
                servos[ nr ].write( value );
            }
            readAndIgnoreUntilNewline();
            break;
        case SET_SINGLE_NEOPIXEL:
            // format: 'N'<pin_nr>=<color>
            nr = readNr( '=' );
            value = readHexNr();
            readAndIgnoreUntilNewline();
            setNeopixel( nr, value );
            break;
        case SET_ALL_NEOPIXELS:
            // format: 'A'<hex_color>[,<hex_color]*
            nextByte = ',';
            while ( nextByte == ',' ) {
                value = readHexNr();
                nextByte = Serial.read();
                setNeopixel( nr++, value );
            }
            if ( nextByte != '\n' ) {
                recoverFromFormatError(  "Neopixel array error, expected , or newline:", nextByte );
            }
            break;
        // -------------------------------
        // ADD CASES FOR YOUR OWN COMMANDS
        // -------------------------------
        default:
            Serial.write( nextByte );
            recoverFromFormatError( "Illegal Command: ", nextByte );
    }
}


int readNr( int endOfNumberCharacter ) {
    int number = readNr();

    waitForSerialData();
    int nextByte = Serial.peek();
    
    if ( nextByte == endOfNumberCharacter ) {
        Serial.read();
     } else {
        if ( endOfNumberCharacter == '=' ) {
            recoverFromFormatError( "Not an assignment", nextByte );
        } else {
            recoverFromFormatError( "Not properly formatted, expected", endOfNumberCharacter );
        }
        number = -1;
    }
    return number;
}


long readNr() {
    waitForSerialData();

    long number = 0;
    int nextByte = Serial.peek();
    
    if ( ! isdigit( nextByte ) ) {
        recoverFromFormatError( "Not a number", nextByte );
        return ILLEGAL_NR;
    } else {
        while ( isdigit( nextByte ) ) {
            number = number * 10 + ( nextByte - '0' );
            Serial.read();
            waitForSerialData();
            nextByte = Serial.peek();
        }
    }

    return number;
}


long readHexNr() {
    waitForSerialData();

    long number = 0;
    int nextByte = Serial.peek();
    
    if ( ! isxdigit( nextByte )) {
        return ILLEGAL_NR;
    }
    while ( isxdigit( nextByte ) ) {
        number = number * 16 + getHexValue( nextByte );
        Serial.read();
        waitForSerialData();
        nextByte = Serial.peek();
    }

    return number;
}


int getHexValue( int byte ) {
    int ascii = byte + 1;

    if ( byte >= '0' && byte <= '9' ) {
        ascii = '0';
    } else     if ( byte >= 'A' && byte <= 'F' ) {
        ascii = 'A' - 10;
    } else     if ( byte >= 'a' && byte <= 'f' ) {
        ascii = 'a' - 10;
    }

    return byte - ascii;
}


void recoverFromFormatError( String error, int command ) {
    Serial.print( "Error: '" );
    Serial.print( error );
    Serial.print( "', token = '" );
    Serial.print( command );

    Serial.print( "' - trying to recover (skipping until newline)\n" );
    Serial.flush();

    readAndIgnoreUntilNewline();
}


void waitForSerialData() {
    while ( Serial.available() <= 0 )  {  // wait for data to be received
         delay( MINIMUM_WAIT_DELAY_FOR_SERIAL_DATA );
    }
}


void readAndIgnoreUntilNewline() {
    isRecovering = true;
    while ( isRecovering && Serial.available() > 0 )  {
        int byte = Serial.read();
        if ( byte == '\n' ) {
            isRecovering = false;
        }
    }
}


// ------------------------------------------------------------------------------
// File:        Neopixel.ino
//
// Version:     1.0
// Author:      Douwe A. van Twillert - Art & Technology, Saxion
// License:     Released under MIT license: http://www.opensource.org/licenses/mit-license.php
// Copyright:   Copyright (C) 2017
//
// Description: Defines a few functions to control the neopixels If you want to
//              control multiple strips, a single connection is easiest. For
//              multiple strips, the protocol must be adjusted.
// ------------------------------------------------------------------------------


#include <FastLED.h>


// ==========  CONSTANTS  ==========
const int ILLEGAL_NR = -1;

const int DATA_PIN   =  7;
const int CLOCK_PIN  = ILLEGAL_NR;  // not used for this led strip
const int NUM_LEDS   =  8;
const int BRIGHTNESS = 64;
#define COLOR_ORDER GRB


// ==========  VARIABLES  ==========
CRGB leds[NUM_LEDS];

boolean isStripChanged = false;


// ==========  FUNCTIONS  ==========
void initNeopixelStrip() {
    // Uncomment/edit one of the following lines for your leds arrangement.
    // FastLED.addLeds<TM1803,   DATA_PIN, RGB>( leds, NUM_LEDS );
    // FastLED.addLeds<TM1804,   DATA_PIN, RGB>( leds, NUM_LEDS );
    // FastLED.addLeds<TM1809,   DATA_PIN, RGB>( leds, NUM_LEDS );
    // FastLED.addLeds<WS2811,   DATA_PIN, RGB>( leds, NUM_LEDS );
    // FastLED.addLeds<WS2812,   DATA_PIN, RGB>( leds, NUM_LEDS );
    // FastLED.addLeds<WS2812B,  DATA_PIN, RGB>( leds, NUM_LEDS );

     FastLED.addLeds<NEOPIXEL, DATA_PIN>( leds, NUM_LEDS );
    
    // FastLED.addLeds<APA104,     DATA_PIN, RGB>( leds, NUM_LEDS );
    // FastLED.addLeds<UCS1903,    DATA_PIN, RGB>( leds, NUM_LEDS );
    // FastLED.addLeds<UCS1903B,   DATA_PIN, RGB>( leds, NUM_LEDS );
    // FastLED.addLeds<GW6205,     DATA_PIN, RGB>( leds, NUM_LEDS );
    // FastLED.addLeds<GW6205_400, DATA_PIN, RGB>( leds, NUM_LEDS );
  
    // FastLED.addLeds<WS2801,  RGB>( leds, NUM_LEDS );
    // FastLED.addLeds<SM16716, RGB>( leds, NUM_LEDS );
    // FastLED.addLeds<LPD8806, RGB>( leds, NUM_LEDS );
    // FastLED.addLeds<P9813,   RGB>( leds, NUM_LEDS );
    // FastLED.addLeds<APA102,  RGB>( leds, NUM_LEDS ); 
    // FastLED.addLeds<DOTSTAR, RGB>( leds, NUM_LEDS );

    // FastLED.addLeds<WS2801,  DATA_PIN, CLOCK_PIN, RGB>( leds, NUM_LEDS );
    // FastLED.addLeds<SM16716, DATA_PIN, CLOCK_PIN, RGB>( leds, NUM_LEDS );
    // FastLED.addLeds<LPD8806, DATA_PIN, CLOCK_PIN, RGB>( leds, NUM_LEDS );
    // FastLED.addLeds<P9813,   DATA_PIN, CLOCK_PIN, RGB>( leds, NUM_LEDS );
    // FastLED.addLeds<APA102,  DATA_PIN, CLOCK_PIN, RGB>( leds, NUM_LEDS );
    // FastLED.addLeds<DOTSTAR, DATA_PIN, CLOCK_PIN, RGB>( leds, NUM_LEDS );

    leds[0] = CRGB::Yellow ;
    FastLED.show(); // Initialize all pixels to 'off'
}


void setNeopixel( int ledNr, long color ) {
    if ( ledNr != ILLEGAL_NR && color != ILLEGAL_NR ) {
        leds[ ledNr ] = color;
        isStripChanged = true;
    }
}


void showNeopixelStripIfChanged() {
    if ( isStripChanged ) {
        FastLED.show();
        isStripChanged = false;
    }
}


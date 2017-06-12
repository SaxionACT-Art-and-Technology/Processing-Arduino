/*
Helper Functions so an Arduino is automatically detected. 
You don't have to use this.
*/

import java.util.regex.Pattern;
import java.util.regex.Matcher;

int nrOfSerialPorts = 0;

void initializeArduino( String[] arduinoPorts ) {
    arduino = new Arduino( this, arduinoPorts[0], 57600 );
}

boolean connectArduino() {
  
    boolean connected = false;
  
    String[] ports = Arduino.list();
    
    if ( nrOfSerialPorts != ports.length && arduino != null ) {
        arduino.dispose();
        arduino = null;
    }
    
    if ( arduino == null && ports.length > 0 && ( nrOfSerialPorts == 0 || nrOfSerialPorts == ports.length ) ) {
        
        println("Your Arduino is connected to the port(s) that display 'true'");
        println("");
        
        String[] arduinoPorts = getPossibleArduinoPorts( ports );
        
        if ( arduinoPorts.length > 0 ) {
            initializeArduino( arduinoPorts );
            nrOfSerialPorts = ports.length;
            connected = true;
        } else {
            println("no matches found");
        }
    }
    
    return connected;
}


String[] getPossibleArduinoPorts( String[] ports )
{
    String[] matches = {};
    int nrOfMatches = 0;
    Pattern pattern = null;
    Pattern    modemPattern = Pattern.compile( ".*usbmodem[\056A-Za-z0-9]+"           );
    Pattern  cumodemPattern = Pattern.compile( ".*cu\056usbmodem[\056A-Za-z0-9]+"     );
    Pattern   serialPattern = Pattern.compile( ".*usbserial[\056A-Za-z0-9]+"       );
    Pattern cuserialPattern = Pattern.compile( ".*cu\056usbserial[\056A-Za-z0-9]+" );
    Pattern  comPortPattern = Pattern.compile( "COM[0-9]+"                      );
   
           if ( ( nrOfMatches = getNrOfMatches( ports,  cumodemPattern ) ) > 0 ) {
        pattern = cumodemPattern;
    } else if ( ( nrOfMatches = getNrOfMatches( ports, cuserialPattern ) ) > 0 ) {
        pattern = cuserialPattern;
    } else if ( ( nrOfMatches = getNrOfMatches( ports,    modemPattern ) ) > 0 ) {
        pattern = modemPattern;
    } else if ( ( nrOfMatches = getNrOfMatches( ports,   serialPattern ) ) > 0 ) {
        pattern = serialPattern;
    } else if ( ( nrOfMatches = getNrOfMatches( ports,  comPortPattern ) ) > 0 ) {
        pattern = comPortPattern;
    }
    
    if ( nrOfMatches > 0 ) {
        for ( int i = 0 ; i < ports.length ; i++ ) {
             Matcher matcher = pattern.matcher(ports[i]);
             boolean b = matcher.matches();
             println( "["+i+"]\t" + matcher.matches() + "\t" + ports[i] );
        }
        matches = getMatches( ports, pattern, nrOfMatches );
    }
    
    return matches;
}


int getNrOfMatches( String[] ports, Pattern pattern )
{
    int nrOfMatches = 0;
    for ( int i = 0 ; i < ports.length ; i++ ) {
         Matcher matcher = pattern.matcher( ports[i] );
         if ( matcher.matches() ) {
             nrOfMatches++;
         }
    }
    
    return nrOfMatches;
}


String[] getMatches( String[] ports, Pattern pattern, int nr ) {
    int nrOfMatches = 0;
    String[] matches = new String[nr];
    for ( int i = 0 ; i < ports.length ; i++ ) {
         Matcher matcher = pattern.matcher( ports[i] );
         if ( matcher.matches() ) {
             matches[nrOfMatches++] = ports[i];
         }
    }
    
    return matches;
}
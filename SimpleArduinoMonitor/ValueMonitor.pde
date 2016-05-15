/*  Value monitor object.
    Handy if you want to monitor a large amount of numeric values and progress over time.
    Inspired and partly based on examples from the pulsesensor website: 
    http://pulsesensor.myshopify.com/pages/code-and-guide
    
    Copyleft: kasperkamperman.com - 09-06-2015    
*/

public class ValueMonitor {
  
  // buffer to store history of values  
  private int    valueCircularBufferSize = 100;  
  private int [] valueCircularBuffer;  
  private int    valueCircularBufferIndex; 
  
  // position
  private int x;
  private int y;
  private int w;
  private int h;
  
  // variables to scale the monitor automatically
  private float sensorAvgMinValue = 0.0;      
  private float sensorAvgMaxValue = 1.0;     
  
  // to display usefull values
  private String monitor;
  
  // name of this monitor
  private String name;
  
  public ValueMonitor(int tempX, int tempY, int tempW, int tempH, String tempName) {
    
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
    name = tempName;
    
    //valueCircularBufferSize  = 100;
    valueCircularBuffer      = new int[valueCircularBufferSize];
    valueCircularBufferIndex = 0;
    
    for (int i = 0; i < valueCircularBufferSize; ++i) {
      valueCircularBuffer[i] = 0;
    }
  }
  
  public void addValue(int value) {
    
    // add the value to the buffer
    valueCircularBuffer[valueCircularBufferIndex] = value;
    
    // change the index of the buffer
    if(valueCircularBufferIndex<valueCircularBufferSize-1) valueCircularBufferIndex++;
    else                                                   valueCircularBufferIndex=0;   
    
    // change the display based on incoming values    
    if(value < sensorAvgMinValue) sensorAvgMinValue = value;
    if(value > sensorAvgMaxValue) sensorAvgMaxValue = value;
    
    //println(sensorAvgMaxValue);
    
    // we can also automatically scale the min-max values
    // we use smoothing to don't react directly on changes
    
    // if(value > sensorAvgMinValue) sensorAvgMinValue = (value * 0.005) + (sensorAvgMinValue * 0.995);
    // else                          sensorAvgMinValue = (value * 0.05)  + (sensorAvgMinValue * 0.95);

    // if(value > sensorAvgMaxValue) sensorAvgMaxValue = (value * 0.05)  + (sensorAvgMaxValue * 0.95);
    // else                          sensorAvgMaxValue = (value * 0.005) + (sensorAvgMaxValue * 0.995);
    
  }
  
  public void display() {
    
    // draw eggshell background
    fill(255, 253, 248);
    rect(x, y, w, h);
    
    // add position in width and height.
    // for mapping (after drawing the background)
    int mapW = x+w;
    int mapH = y+h;
    
    int padding = 10;
    //int marginMinMax = 8; // margin for higher/lower sensor values then avg max-min
    
    //noFill();
    strokeWeight(1);
    stroke(40); 
    
    // beginShape is a fast way to draw lines!   
    beginShape();      
    
      float sx;
      float sy;
      
      for (int i=0; i<valueCircularBufferSize-1; i++)
      {               
        sx = map(i, 0.0, valueCircularBufferSize, x+padding, mapW-padding);
        // use sensorAvgMinValue and sensorAvgMaxValue to scale
        //sy = map(constrain(getValueFromCircularBuffer(i), sensorAvgMinValue-marginMinMax, sensorAvgMaxValue+marginMinMax), sensorAvgMinValue-marginMinMax, sensorAvgMaxValue+marginMinMax, mapH-padding, y+padding);     
        sy = map(constrain(getValueFromCircularBuffer(i), sensorAvgMinValue, sensorAvgMaxValue), sensorAvgMinValue, sensorAvgMaxValue, mapH-padding, y+padding);     
        //sy = map(constrain(, sensorAvgMinValue, sensorAvgMaxValue), sensorAvgMinValue, sensorAvgMaxValue, mapH-padding, y+padding);     
        
        
        //sy = map(getValueFromCircularBuffer(i), 0-marginMinMax, 1+marginMinMax, mapH-padding, y+padding); 
        //sy = map(getValueFromCircularBuffer(i), 0, 1, mapH-padding, y+padding); 
        
        vertex(sx, sy);
      }
    
    endShape();  
    
    //noStroke(); 
    //fill();
    
    //monitor = "min: " + nfs(sensorAvgMinValue, 3, 2) + "\nmax: " + nfs(sensorAvgMaxValue, 3, 2) + "\n" + nfs(getValueFromCircularBuffer(valueCircularBufferSize-1), 3, 2);
    monitor = name + "\nrange: " + sensorAvgMinValue + " - " + sensorAvgMaxValue + "\nvalue: " + getValueFromCircularBuffer(valueCircularBufferSize-1);
    
    textAlign(LEFT, TOP);
    text(monitor, x + w + padding, y);
    
  }
  
  // used to display the wave
  private float getValueFromCircularBuffer(int index)
  { int idx = (valueCircularBufferIndex + index) % valueCircularBufferSize;
    return valueCircularBuffer[idx];
  }
  
}
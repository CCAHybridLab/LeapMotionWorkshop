import de.voidplus.leapmotion.*;
import processing.serial.*;
import cc.arduino.*;

Arduino arduino;
LeapMotion leap;
//println(Arduino.list()); //this is where you would find out what port arduino os connected to 

int Bbrightness;
int Rbrightness;
int Gbrightness;

float brightness;
float rToGcolor;

float  cbrightness;//contrained brightness
float  crToGcolor;

color bgOrigin;

float ex;//x value of circle
float ez;//z value of circle


//use PWM digital pins (the ones with squiggle)
int rPin = 11;
int gPin = 9;
int bPin = 10;

void setup() {

  arduino = new Arduino(this, Arduino.list()[2], 57600);
  leap = new LeapMotion(this);

  size(1000, 800);//size of canvas
  background(255);//backround starts as white


  arduino.pinMode(rPin, Arduino.OUTPUT);//turns on pins via arduino pinMode(pin,OUTPUT);
  arduino.pinMode(gPin, Arduino.OUTPUT);
  arduino.pinMode(bPin, Arduino.OUTPUT);
}


void draw() {
  //gets the index finger x y and z
  for (Hand hand : leap.getHands ()) {
    Finger  fingerIndex        = hand.getIndexFinger();

    //println(fingerIndex.getPosition());//(X,UP AND DOWN, FORWARD AND BACK)

//maps and contrains y value or height of finger to use for brightness of the color on the screen and LED
    brightness = map(fingerIndex.getPosition().y, 400, 60, 100, 0); //map(VALUE, min, max, mapmin, mapmax) finger height mapped to 0-100
    cbrightness = constrain(brightness, 0, 100);//contrain function to keep brightness from going outside range

//maps and contrains the x finger value to use to change the color
    rToGcolor = map(fingerIndex.getPosition().x, 300, 700, 0, 300  ); //map(VALUE, min, max, mapmin, mapmax)
    crToGcolor = constrain(rToGcolor, 0, 300); //HGB values go to 360 but we stop at 300 to prevent it from being red on both sides

//Change color mode from RGB(Red,Green,Blue) to HSB(Hue Saturation,Brightness) https://processing.org/reference/colorMode_.html
    colorMode(HSB, 360, 100, 100, 100);//mode, color range total, max red, max g, max blue
   //Hue us from the X finger value, saturation is 100, brightness is from the Y finger value map
    bgOrigin = color(int(crToGcolor), 100, int(cbrightness));
    //changes color mode back to RGB
   colorMode(RGB, 255);
    //uses values from the HSB as an RGB
    Rbrightness = int(red(bgOrigin));
    Gbrightness = int(green(bgOrigin));
    Bbrightness = int(blue(bgOrigin));
    
 // maps the x and z to of the leap motion to the size of the canvas 
    ex = map(fingerIndex.getPosition().x, 200, 900, 0, width);
    ez = map(fingerIndex.getPosition().z, 0, 100, 0, height);

//Draws ellipse (x,z,sizewide,sizetall); size is determined by y distance from leap motion
    ellipse(ex, (height-ez), fingerIndex.getPosition().y, fingerIndex.getPosition().y);
    
//colors ellipse with the values mapped
    fill(Rbrightness, Gbrightness, Bbrightness);

//writes LED's with the values mapped
    arduino.analogWrite(rPin, Rbrightness);
    arduino.analogWrite(gPin, Gbrightness);
    arduino.analogWrite(bPin, Bbrightness);


//DEBUGGING AREA print to console
    //println("Rbrightness" + Rbrightness);
    //println("cbrightness" + cbrightness);
    println("fingerIndex.getPosition().x" + fingerIndex.getPosition().x);
    println("fingerIndex.getPosition().z" + fingerIndex.getPosition().z);
    //println ("ex" +ex);
    //println ("ez" + ez);
    //println("Rbrightness" + Gbrightness);
    //println("Rbrightness" + Bbrightness);
  }
}

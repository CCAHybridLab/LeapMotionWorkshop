import de.voidplus.leapmotion.*;
import processing.serial.*;
import cc.arduino.*;

Arduino arduino;
//println(Arduino.list());
int Bbrightness;
int Rbrightness;
int Gbrightness;
float brightness;
float rToGcolor;
int pin;
float  cbrightness;
float  crToGcolor;
color bgOrigni;
float ex;
float ez;
LeapMotion leap;

void setup() {
  arduino = new Arduino(this, Arduino.list()[2], 57600);
  size(1000, 800);
  background(255);
  // ...
  arduino.pinMode(11, Arduino.OUTPUT);
  arduino.pinMode(10, Arduino.OUTPUT);
  arduino.pinMode(9, Arduino.OUTPUT);

  leap = new LeapMotion(this);
}

void leapOnInit() {
  // println("Leap Motion Init");
}
void leapOnConnect() {
  // println("Leap Motion Connect");
}
void leapOnFrame() {
  // println("Leap Motion Frame");
}
void leapOnDisconnect() {
  // println("Leap Motion Disconnect");
}
void leapOnExit() {
  // println("Leap Motion Exit");
}

void draw() {
  for (Hand hand : leap.getHands ()) {
    Finger  fingerIndex        = hand.getIndexFinger();
    // or                        hand.getFinger("index");
    // or                        hand.getFinger(1);
    //println(fingerIndex.getPosition());//(X,UP AND DOWN, FORWARD AND BACK)
    
    brightness = map(fingerIndex.getPosition().y,400,60,100,0); //map(VALUE, min, max, mapmin, mapmax)
    cbrightness = constrain(brightness,0,100);
    rToGcolor = map(fingerIndex.getPosition().x,300,700,0,300  ); //map(VALUE, min, max, mapmin, mapmax)
    crToGcolor = constrain(rToGcolor,0,300);
    //Rbrightness = int(map(fingerIndex.getPosition().z,0,100,0,255)); //map(VALUE, min, max, mapmin, mapmax)
    //Gbrightness = int(map(fingerIndex.getPosition().z,0,100,0,255)); //map(VALUE, min, max, mapmin, mapmax)
    //Bbrightness = int(map(fingerIndex.getPosition().z,0,100,0,255)); //map(VALUE, min, max, mapmin, mapmax)
  colorMode(HSB, 360, 100, 100);
  bgOrigni = color(int(crToGcolor), 100, int(cbrightness));
  colorMode(RGB, 255);
  Rbrightness = int(red(bgOrigni));
  Gbrightness = int(green(bgOrigni));
  Bbrightness = int(blue(bgOrigni));
  ex = map(fingerIndex.getPosition().x, 200,900, 0, width);
  ez = map(fingerIndex.getPosition().z, 0,100, 0, height);
 
  ellipse(ex, (height-ez), fingerIndex.getPosition().y,fingerIndex.getPosition().y);
    fill(Rbrightness,Gbrightness,Bbrightness);



    arduino.analogWrite(11,Rbrightness);
     arduino.analogWrite(9,Gbrightness);
      arduino.analogWrite(10,Bbrightness);
    
    //println("Rbrightness" + Rbrightness);
    //println("cbrightness" + cbrightness);
    println("fingerIndex.getPosition().x" + fingerIndex.getPosition().x);
     println("fingerIndex.getPosition().z" + fingerIndex.getPosition().z);
    println ("ex" +ex);
    println ("ez" + ez);
     //println("Rbrightness" + Gbrightness);
      //println("Rbrightness" + Bbrightness);
  }
  
}
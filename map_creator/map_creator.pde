int kernelRad = 10;
int imgBlur = 0;
String wightsMode = "exp"; // linear div2 1/d exp ones

////////////////////////
import controlP5.*;
import java.util.Arrays;
////////////////////////


ControlP5 cp5;
boolean is_showBG = false;

imgObj img;


////////////////////////


void setup() {
  
  size(1200, 800);
  surface.setResizable(true);
  
  colorMode(RGB, 1);
  noStroke();
  
  img = new imgObj(width/2, height/2, CENTER, "img.jpg");

  cp5 = new ControlP5(this);
  addButtons();
  
  Kernel k = new Kernel(3);
  k.setGradientWeights(wightsMode);
  //k.testIndexOverlay(5);
  k.printWeights();
  //print(k.weights[1]);

  contourMap(img, kernelRad, wightsMode, imgBlur);
  
  //noLoop();
}

void draw() {
  background(1);
  img.render();
  rendInfo();
  
}



void mouseDragged() {
  if (mouseButton == RIGHT) {
    img.pan();
  } else if (mouseButton == LEFT) {
    
  }
}
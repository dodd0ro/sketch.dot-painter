import controlP5.*;
import java.util.Arrays;

imgObj img;
agContainer agcont;

ControlP5 cp5;
boolean is_showBG = false;

boolean recordVideo = false;
boolean doKick = false;
int imgCount = 10;
int imgN = -1;


void setup() {
 mapColor(0.5, 1, 1, color(0), color(1));
  
  size(1200, 800);
  surface.setResizable(true);
  colorMode(RGB, 1);

  //img = new imgObj(width/2, height/2, CENTER, (imgCount%6)+".jpg");
  nextPic_bang();
  agcont = new agContainer();
  
  cp5 = new ControlP5(this);
  addButtons();
}

void draw() {
  background(1);
  if (is_showBG) {img.render();}
  agcont.tick();
  //agcont.cellsDebug();
  rendInfo();
  
  if (recordVideo) {saveFrame("video/cd_####.png");}
}


void mouseDragged() {
  if (mouseButton == RIGHT) {
    img.pan();
  } else if (mouseButton == LEFT) {
    for (int times = 0; times<1; times++){agcont.newAgent(mouseX, mouseY);}
  }
}


void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  gap += e*0.25;
  println(gap, e);
}





  
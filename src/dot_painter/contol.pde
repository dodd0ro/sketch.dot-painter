
//////////////////////////////////////////////////////
void addButtons(){
  cp5.addToggle("is_showBG")
    .setLabel("Background")
    .setPosition(10, 10)
    .setColorLabel(color(0.1,0.6,1))
    .setSize(20, 20);
    
    
  cp5.addToggle("noLoop_toggle")
    .setLabel("Loop")
    .setPosition(10, 60)
    .setSize(20, 20)
    .setColorLabel(color(0.1,0.6,1))
    .setValue(true);
    
    cp5.addToggle("agentDebug")
    .setLabel("Ag debug")
    .setPosition(10, 110)
    .setSize(20, 20)
    .setColorLabel(color(0.1,0.6,1))
    .setValue(false);
    
    cp5.addBang("createGrid_bang")
     .setPosition(10, 160)
     .setSize(20, 20)
     .setTriggerEvent(Bang.RELEASE)
     .setColorLabel(color(0.1,0.6,1))
     .setLabel("Create grid")
     ;
     
   cp5.addBang("restart_bang")
     .setPosition(10, 210)
     .setSize(20, 20)
     .setTriggerEvent(Bang.RELEASE)
     .setColorLabel(color(0.1,0.6,1))
     .setLabel("Restart")
     ;
     
   cp5.addBang("nextPic_bang")
     .setPosition(10, 260)
     .setSize(20, 20)
     .setTriggerEvent(Bang.RELEASE)
     .setColorLabel(color(0.1,0.6,1))
     .setLabel("Next pic")
     ;
     
   cp5.addBang("savePic_bang")
     .setPosition(10, 310)
     .setSize(20, 20)
     .setTriggerEvent(Bang.RELEASE)
     .setColorLabel(color(0.1,0.6,1))
     .setLabel("Save pic")
     ;
  
   cp5.addToggle("recordVideo")
     .setPosition(10, 360)
     .setSize(20, 20)
     .setColorLabel(color(0.1,0.6,1))
     .setLabel("Record")
     .setValue(false);
     ;
  
}


//////////////////////////////////////////////////////
public void createGrid_bang() {
  //int gridStep = int((minSize+maxSize)*0.5);
  int gridStep = int((minSize+maxSize)*0.5);
  for (int row = gridStep; row < height; row+=gridStep) {
    for (int col = gridStep; col < width; col+=gridStep) {
      //if (brightness(img.getPix(new PVector(col,row),"src")) < 0.9) {
        agcont.newAgent(col, row);
      //}
    }
  }
}


//////////////////////////////////////////////////////
public void restart_bang() {
  agcont = new agContainer();
}


//////////////////////////////////////////////////////
public void nextPic_bang() {
  boolean isImg = false;
  while (!isImg){
    imgN = (imgN+1)%imgCount;
    isImg = new File(dataPath(""), imgN+".jpg").exists();
    if (!isImg) {
      println("no "+imgN+".jpg");
      
    } else {
      img = new imgObj(width/2, height/2, CENTER, imgN+".jpg");
      doKick = true;
    }
  }
  
}


//////////////////////////////////////////////////////
public void savePic_bang() {
  save("testpics/test"+timestamp()+".png");
}


//////////////////////////////////////////////////////
void noLoop_toggle(boolean theFlag) {
  if (theFlag){loop();}
  else{noLoop();}
}


//////////////////////////////////////////////////////
//void recordVideo_toggle(boolean theFlag) {
//  if (theFlag){loop();}
//  else{noLoop();}
//}

//////////////////////////////////////////////////////
void rendInfo(){
  textSize(12);
  textAlign(RIGHT);
  text(agcont.agCount + " points", width-20, 30);
  text(round(frameRate) + " FPS", width-20, 60);
  text(regSize + " regSize", width-20, 90); 
}
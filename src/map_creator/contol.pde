void addButtons(){
    
    
   cp5.addBang("savePic_bang")
     .setPosition(10, 10)
     .setSize(20, 20)
     .setTriggerEvent(Bang.RELEASE)
     .setColorLabel(color(0.1,0.6,1))
     .setLabel("Save pic")
     ;
  
}


public void savePic_bang() {
  img.src.save("outputImage.jpg");
  
  save(
    "testpics/test" +
    "_r" +
    "_m" + wightsMode +
    "_b" +imgBlur +
    timestamp()+".png"
  );
}

void rendInfo(){
  textSize(12);
  textAlign(RIGHT);
  text("kernelRad: "+ kernelRad , width-20, 30);
  text("wightsMode: " + wightsMode, width-20, 60);
  text("imgBlur: " +imgBlur, width-20, 90); 
}
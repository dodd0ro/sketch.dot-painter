
//////////////////////////////////////////////////////
class imgObj {
  
  String fileName;
  
  PImage src, _src;
  PImage densMap;
  PImage[] brMap, gradMap; 
  
  int w, h;
  int length;
  
  float x, y;
  int align;
  
  int kStep = 2;
  
  
  imgObj(float x_, float y_, int align_, String fileName_) {
    fileName = fileName_;
    
    src = loadImage(fileName);
    _src = src.copy();
    
    checkGradMap();
    checkBrMap();
    
    x = x_; y = y_;
    align = align_;
    
    w = src.width;
    h = src.height;
    this.length = w*h;
  }
  
  
  ///////////////////////////

  void checkGradMap(){
    
    int mapsCount = round((maxSize/2-minSize/2)/kStep)+1;
    gradMap = new PImage[mapsCount];

    
    for (int ik = 0; ik < mapsCount; ik++) {
      int k = round((minSize/2)+ik*kStep+1);
      String nameMap = constrFileName(fileName, "gradMap"+k);
      if (isFileInData(nameMap)){
        gradMap[ik] = loadImage(nameMap);
      } else {
        println("no "+nameMap);
        gradMap[ik] = makeGradMap(src, k, "linear", 1); // PImage img, int rad, String wightsMode (linear div2 1/d exp ones), int blurRad)
        gradMap[ik].save("data/"+nameMap);
      }
    }
  }
  
  void checkDensMap(){
    int k = int(minSize);
    String nameMap = constrFileName(fileName, "densMap"+k);
    if (isFileInData(nameMap)){
      densMap = loadImage(nameMap);
    } else {
      println("no "+nameMap);
      densMap = makeDevMap(src, k, "exp", 1); // PImage img, int rad, String wightsMode (linear div2 1/d exp ones), int blurRad)
      densMap.save("data/"+nameMap);
    }
  }
  
  void checkBrMap(){
    int mapsCount = round((maxSize/2-minSize/2)/kStep)+1;
    brMap = new PImage[mapsCount];
    
    for (int ik = 0; ik < mapsCount; ik++) {
      int k = round((minSize/2)+ik*kStep+1);
      String nameMap = constrFileName(fileName, "brMap"+k);
      if (isFileInData(nameMap)){
        brMap[ik] = loadImage(nameMap);
      } else {
        println("no "+nameMap);
        brMap[ik] = makebrMap(src, k); // PImage img, int rad, String wightsMode (linear div2 1/d exp ones), int blurRad)
        brMap[ik].save("data/"+nameMap);
      }
      
    }
  }
  
  
  
  ///////////////////////////
  void render() {
   imageMode(align);
   image(src, x, y);
  }
  
  
  ///////////////////////////
  void pan() {
    x += (mouseX - pmouseX);
    y += (mouseY - pmouseY);
  }
  
  
  /////////////////////////// bad perfomance!!!
  color getPix(PVector pos, String map, float agSize) { 
    //int k = round((minSize/2)+ik*kStep);
    int k = round((agSize/2 - minSize/2)/kStep);
    //println(agSize/2, minSize/2, maxSize/2, k);
    if (k < 0) {k = 0;}
    
    float rx = 0;
    float ry = 0;
    
    switch (align) {
      case CENTER:
        rx = pos.x - x  + src.width/2;
        ry =  pos.y - y + src.height/2;
        break;
        
      case CORNER:
        rx = pos.x - x;
        ry = pos.y - y;
        break;
      }
    
    int k0 = floor(k);
    int k1 = ceil(k);
    
    color res = color(1,0,0);
    if (0>rx || rx > w || 0 > ry || ry > h){res = color (0.5,0.5,0.5);}
    else if (map == "src"){res = src.get(round(rx),round(ry));}
    else if (map == "gradMap") { 
      color res0 = gradMap[k0].get(round(rx),round(ry));
      color res1 = gradMap[k1].get(round(rx),round(ry));
      res = mapColor(k, k0, k1, res0, res1);
    }
    else if (map == "densMap") { res = densMap.get(round(rx),round(ry));}
    else if (map == "brMap") { 
      color res0 = brMap[k0].get(round(rx),round(ry));
      color res1 = brMap[k1].get(round(rx),round(ry));
      res = mapColor(k, k0, k1, res0, res1);
    }
    return res;
    }


  ///////////////////////////
  color getPosPix(PVector pos) {
    int rows = round(pos.y);
    int col = round(pos.x);
    if (col<=0 || col>=src.width){return color(0,0,1);}
    if (rows<=0 || rows>=src.height){return color(0,0,1);}
    int i = round(rows * src.width + col);  
    return src.pixels[i];
  }
  
  
  ///////////////////////////
  PVector getPixPos(int i) {
    float rows = i / src.width;
    float cols = i % src.width;
    return new PVector(cols, rows);
  }

  
}
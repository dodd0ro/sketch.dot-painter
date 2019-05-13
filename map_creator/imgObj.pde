class imgObj {
    
  PImage src;
  float x, y;
  int align;
  
  imgObj(float x_, float y_, int align_, String path_) {
    src = loadImage(path_);
    x = x_; y = y_;
    align = align_;
  }
  
  void render() {
   imageMode(align);
   image(src, x, y);
  }
  
  void pan() {
    x += (mouseX - pmouseX);
    y += (mouseY - pmouseY);
  }
  
  
  color get(int wx, int wy) {
    
    float rx = 0;
    float ry = 0;
    
    switch (align) {
      case CENTER:
        rx = wx - wy + src.width/2;
        ry = wx - wy + src.height/2;
        break;
        
      case CORNER:
        rx = wx - wy;
        ry = wx - wy;
        break;
      }
    return img.get(round(rx),round(ry));
    }
  
  color getPosPix(PVector pos) {
    int rows = round(pos.y);
    int col = round(pos.x);
    if (col<=0 || col>=src.width){return color(0,0,1);}
    if (rows<=0 || rows>=src.height){return color(0,0,1);}
    int i = round(rows * src.width + col);  
    return src.pixels[i];
  }
  
  PVector getPixPos(int i) {
    float rows = i / src.width;
    float cols = i % src.width;
    return new PVector(cols, rows);
  }

  
  imgObj copy() { //BAD!!!!!!
    imgObj c = new imgObj(x,y,align, "img.jpg");
    c.src = src.copy();
    return c;
  }
  
}
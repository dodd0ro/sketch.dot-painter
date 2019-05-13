////////////////////////////////////////////////
class Kernel {
  int rad;
  int width_;
  int length;
  float[] weights;
  int[] vectorsX;
  int[] vectorsY;
  
  int iCenter;

  Kernel(int rad_) {
    rad = rad_;
    width_ = rad_*2 + 1;
    length = width_*width_;
    
    weights = new float[length];
    vectorsX = new int[length];
    vectorsY = new int[length];
  }
  
  
  ////////////////////////
  void setGradientWeights(String mode) {
    for (int i0=0; i0 < length/2+1; i0++) {
        int i1 = invIndexThroughCenter(i0, length);
        
        float w = getGradientWeight(i0, mode);
        weights[i0] = w;
        weights[i1] = w;
        
        int x0 = (i0 % width_);
        int x1 = (i1 % width_);
        int y0 = (i0 / width_);
        int y1 = (i1 / width_);
        
        vectorsX[i0] = x0 - rad;
        vectorsX[i1] = x1 - rad;
        vectorsY[i0] = y0 - rad;
        vectorsY[i1] = y1 - rad;
    }
  }
 
  
  ////////////////////////
  float getGradientWeight(int iPix, String mode) {
    int[] pos = indexCoord(iPix, width_);
    int x = pos[0]; int y = pos[1];
    
    float w = -1000;
    float d = dist(x, y, rad, rad);
    
    
    switch (mode) {
      
      case "linear":
        w  = (rad+1)- d;
        //w = (rad+1 - d)/rad;
        if (w<0) {w=0;}
        break;
      
      case "div2": 
        w = (rad+1 - d)/2;
        if (Float.isInfinite(w)){w=0;}
        break;
      
      case "1/d": 
        w = 1/d;
        if (Float.isInfinite(w)){w=0;}
        break;
        
      case "exp": 
        w = exp(1-d);
        if (Float.isInfinite(w)){w=0;}
        break;
        
      case "ones": 
        w = 1;
        break;
        
      case "test":
        if (d>1){w = 0;}
        else {w = 1;}
        break;
    }
    return w;
    
  }
  
  ////////////////////////
  void testIndexOverlay(int offset) {
    int _rad = 1;
    int _w = _rad*2+1;
    int L = _w*_w;
    for (int iPix=0; iPix < L; iPix++) {
        int iPixBG = getIndexOverlay(iPix, offset, _w, width_, length);
        if (iPixBG >= 0) { weights[iPixBG] += 1; }
    }
  }
  

  ////////////////////////
  void printWeights() {
    println("Weights: ");
    for (int iRow = 0; iRow < width_; iRow++) {
      String[] row = new String[width_];
      for (int iCol = 0; iCol < width_; iCol++) {
        row[iCol] = String.format("%.2f", weights[iRow*width_ + iCol]);
      }
      System.out.println(Arrays.toString(row));
    }
    
    println("vectorsX: ");
    for (int iRow = 0; iRow < width_; iRow++) {
      String[] row = new String[width_];
      for (int iCol = 0; iCol < width_; iCol++) {
        row[iCol] = Integer.toString(vectorsX[iRow*width_ + iCol]);
      }
      System.out.println(Arrays.toString(row));
    }
    
    println("vectorsY: ");
    for (int iRow = 0; iRow < width_; iRow++) {
      String[] row = new String[width_];
      for (int iCol = 0; iCol < width_; iCol++) {
        row[iCol] = Integer.toString(vectorsY[iRow*width_ + iCol]);
      }
      System.out.println(Arrays.toString(row));
    }

  }

}
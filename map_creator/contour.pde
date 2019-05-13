

void contourMap(imgObj img, int rad, String wightsMode, int blurRad){

  int w = img.src.width;
  int h = img.src.height;
  int pixLength = w * h;
  int lengthCent = pixLength/100;  // for print
  
  imgObj imgOrig = img.copy();
  imgOrig.src.filter(BLUR, blurRad);
  
  img.src.loadPixels();
  imgOrig.src.loadPixels();
  
  Kernel kernel = new Kernel(rad);
  kernel.setGradientWeights(wightsMode);
  
  
  
  
  for (int iRow = 0; iRow < h; iRow++) {
    for (int iCol = 0; iCol < w; iCol++) {
      int iPix = iRow * w + iCol;
      
      float sumX = 0;
      float sumY = 0;
      
      float absSumX = 0;
      float absSumY = 0;
            
      for (int iK0 = 0; iK0 < kernel.length/2; iK0++) {
        int iK1 = invIndexThroughCenter(iK0, kernel.length);

        int xVect0 = kernel.vectorsX[iK0];
        int yVect0 = kernel.vectorsY[iK0];
        
        int xVect1 = kernel.vectorsX[iK1];
        int yVect1 = kernel.vectorsY[iK1];
        
        int XPix0 = iCol - xVect0;
        int YPix0 = iRow - yVect0;

        int XPix1 = iCol - xVect1;
        int YPix1 = iRow - yVect1;
        
        float b0, b1, w0, w1;
        b0 = b1 = w0 = w1 = 0;
        
        if (0<=XPix0 && XPix0<w && 0<=YPix0 && YPix0<h) {
          int iPix0 = YPix0 * w + XPix0;
          b0 = brightness(imgOrig.src.pixels[iPix0]);
          w0 = kernel.weights[iK0];
        }
        
        if (0<=XPix1 && XPix1<w && 0<=YPix1 && YPix1<h) { 
          int iPix1 = YPix1 * w + XPix1;
          b1 = brightness(imgOrig.src.pixels[iPix1]);
          w1 = kernel.weights[iK1];
        }

        float resVectX0 = xVect0*b0*w0;
        float resVectY0 = yVect0*b0*w0;
        
        float resVectX1 = xVect1*b1*w1;
        float resVectY1 = yVect1*b1*w1;
        
        sumX += resVectX0 + resVectX1;
        sumY += resVectY0 + resVectY1;
        
        absSumX += abs(resVectX0) + abs(resVectX1);
        absSumY += abs(resVectY0) + abs(resVectY1);
        
      }
      
      float r = sumX / absSumX;
      float g = sumY / absSumY;
      r = (r*0.5)+0.5;
      g = (g*0.5)+0.5;
      
      img.src.pixels[iPix] = color(r,g,0);
      
      if (iPix % lengthCent == 0){print(int(1.0*iPix/pixLength*100) +"%...");}
    }
  }
  println("100% done");
  
  img.src.updatePixels();
  imgOrig.src.updatePixels();
  
}
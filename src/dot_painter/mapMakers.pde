
////////////////////////////////////////////////
PImage makeDevMap(PImage img, int rad, String wightsMode, int blurRad) {
  float testMax = 0;
  float testMin = 0;
  
  int w = img.width;
  int h = img.height;
  
  PImage imgOrig = img.copy();
  PImage imgMap = createImage(w, h, RGB);
  
  imgOrig.filter(BLUR, blurRad);
  
  imgOrig.loadPixels();
  imgMap.loadPixels();

  Kernel kernel = new Kernel(rad);
  kernel.setWeightsRadial(wightsMode);
  
  for (int iRow = 0; iRow < h; iRow++) {
    for (int iCol = 0; iCol < w; iCol++) {
      int iPix = coordIndex(iRow, iCol, w);
      
      ArrayList<Float> bArray = new ArrayList<Float>();
      float bSum = 0;
      float wSum = 0;
      
      for (int iK = 0; iK < kernel.length; iK++) {
        int XPix = iCol - kernel.vectorsX[iK];
        int YPix = iRow - kernel.vectorsY[iK];

        if (0<=XPix && XPix<w && 0<=YPix && YPix<h) {
          int iPix0 = coordIndex(YPix, XPix, w);
          float b = brightness(imgOrig.pixels[iPix0]);
          float weight = kernel.weights[iK];
          float bw = b*weight;
          bArray.add(b);
          bSum += bw;
          wSum += weight;
        }
 
      }
      
      float bAverage = (bSum/wSum);
      float quadSum = 0;
      
      for (float b: bArray) {
        quadSum += pow(b-bAverage, 2);
      }
      
      float stdev = sqrt(quadSum/(wSum) );
      

      float b = (abs(brightness(imgOrig.pixels[iPix])-bAverage))/stdev;
      
      //println(wSum);
      //println(stdev);
      if (b > testMax) {testMax = b;}
      if (b < testMin) {testMin = b;}
      b = map(b, 0, 1, 0, 1);
      //stdev = conic(stdev, conicK);
      //if (stdev > 0.2) {stdev = 0.0;}
      imgMap.pixels[iPix] = color(b);
      
      if (iPix % ((w*h)/100) == 0){print(int(1.0*iPix/(w*h)*100) +"%...");}
    }
  }
  println();
  println("testMax = "+ testMax);
  println("testMin = "+ testMin);
  imgOrig.updatePixels();
  imgMap.updatePixels();
  
  return imgMap;
  
}



////////////////////////////////////////////////
//void stdevMap(imgObj img, int rad, String wightsMode, int blurRad) {
  
//  float testMax = 0;
//  float testMin = 0;
  
//  img._src.filter(BLUR, blurRad);
  
//  img.src.loadPixels();
//  img._src.loadPixels();
  
//  Kernel kernel = new Kernel(rad);
//  kernel.setWeightsRadial(wightsMode);
  
//  for (int iRow = 0; iRow < img.h; iRow++) {
//    for (int iCol = 0; iCol < img.w; iCol++) {
//      int iPix = coordIndex(iRow, iCol, img.w);
      
//      ArrayList<Float> bArray = new ArrayList<Float>();
//      float bSum = 0;
//      float wSum = 0;
      
//      for (int iK = 0; iK < kernel.length; iK++) {
//        int XPix = iCol - kernel.vectorsX[iK];
//        int YPix = iRow - kernel.vectorsY[iK];

//        if (0<=XPix && XPix<img.w && 0<=YPix && YPix<img.h) {
//          int iPix0 = coordIndex(YPix, XPix, img.w);
//          float b = brightness(img._src.pixels[iPix0]);
//          float w = kernel.weights[iK];
//          float bw = b*w;
//          bArray.add(b);
//          bSum += bw;
//          wSum += w;
//        }
 
//      }
      
//      float bAverage = (bSum/wSum);
//      float quadSum = 0;
      
//      for (float b: bArray) {
//        quadSum += pow(b-bAverage, 2);
//      }
      
//      float stdev = sqrt(quadSum/(wSum) );
//      //println(wSum);
//      //println(stdev);
//      if (stdev > testMax) {testMax = stdev;}
//      if (stdev < testMin) {testMin = stdev;}
//      stdev = map(stdev, 0, stdevMax, 0, 1);
//      stdev = conic(stdev, conicK);
//      //if (stdev > 0.2) {stdev = 0.0;}
//      img.src.pixels[iPix] = color(stdev);
      
//      if (iPix % (img.length/100) == 0){print(int(1.0*iPix/img.length*100) +"%...");}
//    }
//  }
//  println();
//  println("testMax = "+ testMax);
//  println("testMin = "+ testMin);
//  img.src.updatePixels();
//  img._src.updatePixels();

//}


////////////////////////////////////////////////
PImage makeGradMap(PImage img, int rad, String wightsMode, int blurRad){
  int w = img.width;
  int h = img.height;
  
  PImage imgOrig = img.copy();
  PImage imgMap = createImage(w, h, RGB);
  
  imgOrig.filter(BLUR, blurRad);
  
  imgOrig.loadPixels();
  imgMap.loadPixels();
  
  Kernel kernel = new Kernel(rad);
  kernel.setWeightsRadial(wightsMode);
  
  for (int iRow = 0; iRow < h; iRow++) {
    for (int iCol = 0; iCol < w; iCol++) {
      int iPix = coordIndex(iRow, iCol, w);
      
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
        b0 = b1 = w0 = w1 = 1; // hehe
        
        if (0<=XPix0 && XPix0<w && 0<=YPix0 && YPix0<h) {
          int iPix0 = coordIndex(YPix0, XPix0, w);
          b0 = brightness(imgOrig.pixels[iPix0]);
          w0 = kernel.weights[iK0];
        }
        
        if (0<=XPix1 && XPix1< w && 0<=YPix1 && YPix1<h) { 
          int iPix1 = coordIndex(YPix1, XPix1, w);
          b1 = brightness(imgOrig.pixels[iPix1]);
          w1 = kernel.weights[iK1];
        }

        float resVectX0 = xVect0*b0*w0;
        float resVectY0 = yVect0*b0*w0;
        
        float resVectX1 = xVect1*b1*w1;
        float resVectY1 = yVect1*b1*w1;
        
        sumX += resVectX0 + resVectX1;
        sumY += resVectY0 + resVectY1;
        
        absSumX += w0+w1;
        absSumY += w0+w1;
      }
      
      float r = sumX / absSumX;
      float g = sumY / absSumY;
      r = (r*0.5)+0.5;
      g = (g*0.5)+0.5;
      
      imgMap.pixels[iPix] = color(r,g,0);
      
      if (iPix % ((w*h)/100) == 0){print(int(1.0*iPix/(w*h)*100) +"%...");}
    }
  }
  println("100% done");
  
  imgOrig.updatePixels();
  imgMap.updatePixels();
  
  return imgMap;
  
}

PImage makebrMap(PImage img, int blurRad){
  PImage imgOrig = img.copy();
  imgOrig.filter(BLUR, blurRad);
  return imgOrig;
}


//////////////////////////////////////////////////////
PVector getAngPoint(PVector centPos, float rad, float ang){
  return new PVector(
    centPos.x + cos(ang) * rad,
    centPos.y + sin(ang) * rad
  );     
}

//////////////////////////////////////////////////////
float gaus(float x, float h, float c, float w) { //height, center, width
  return h * exp( -pow(x-c, 2) / (2*pow(w,2)) );
}


//////////////////////////////////////////////////////
float conic(float x, float k) { //k -1 to 1
  return x/ (1 - k + k*x);
}

//////////////////////////////////////////////////////
String timestamp() {
 String d = String.valueOf(day());    // Values from 1 - 31
 String m = String.valueOf(month());  // Values from 1 - 12
 String y = String.valueOf(year());   // 2003, 2004, 2005, etc. 
 String s = String.valueOf(second());  // Values from 0 - 59
 String mi = String.valueOf(minute());  // Values from 0 - 59
 String h = String.valueOf(hour());    // Values from 0 - 23
 String ms = String.valueOf(millis());
 return d+m+y+"-"+h+"-"+mi+"-"+s+"-"+ms;
}
  
//////////////////////////////////////////////////////
void printInt2d(int[][] a) {
  println(" ");
  for (int i = 0; i < a.length; i++) {
    String[] row = new String[a[i].length];
    for (int j = 0; j < a[i].length; j++) {
      row[j] = Integer.toString(a[i][j]);
    }
    System.out.println(Arrays.toString(row));
  }
    
}

//////////////////////////////////////////////////////
String constrFileName (String pathOrig, String mapPrefix) {
  return pathOrig.split("\\.(?=[^\\.]+$)")[0]+"_"+mapPrefix+".jpg";
}

//////////////////////////////////////////////////////
boolean isFileInData(String fileName) {
  return new File(dataPath(""), fileName).exists();
}

//////////////////////////////////////////////////////
color mapColor(float t, float t0, float t1, color c0, color c1) {
    float br0 = brightness(c0);
    float br1 = brightness(c1);
    float br = br0;
    
    float tw1 = t-t0;
    float tw0 = t1-t;
    float twSum = tw0+tw1;
    if (twSum != 0){ 
      br = (br0*tw0 + br1*tw1)/(twSum);
      
    }
    return color(br);
  }
  
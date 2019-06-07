
PVector getAngPoint(PVector centPos, float rad, float ang){
  return new PVector(
    centPos.x + cos(ang) * rad,
    centPos.y + sin(ang) * rad
  );     
}

float gaus(float x, float h, float c, float w) { //height, center, width
  return h * exp( -pow(x-c, 2) / (2*pow(w,2)) );
}

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
  
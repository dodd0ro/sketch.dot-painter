
////////////////////////
int moveIndex(int i, int xOff, int yOff, int _width) {
  return i + (yOff * _width) + xOff;
}


////////////////////////
int invIndexThroughCenter(int i, int _length) { //point simmetry
  return _length-1 - i;
}


////////////////////////
int getIndexOverlay(int i, int offset, int width0, int width1, int length1) {
  // i - index to overlay, width0 of this matrix, width1 of background matrix
  //offset between matrixes (top left corner)
  int rows = i/width0;
  int iSkippedPerRow = width1 - width0;
  
  int iBG =  offset + i + rows * iSkippedPerRow;
  
  int reletiveBGRow = (iBG/width1) - (offset/width1);
  if (reletiveBGRow != rows || iBG >= length1){iBG = -1;}
  
  return iBG;
}


////////////////////////
int[] indexCoord (int i, int _width) {
  int rows = i / _width;
  int cols = i % _width;
  return new int[]{rows, cols};
}

////////////////////////
int coordIndex (int row, int col, int _width) {
  return row * _width + col;
}
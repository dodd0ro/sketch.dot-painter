
  
//////////////////////////////////////////////////////

class Agent {
  
  PVector pos;
  
  float maxSize_ = maxSize;
  float minSize_ = minSize;
  
  
  PVector contVect = new PVector(0,0);
  PVector colVector = new PVector(0,0);
  float colDist = minSize_;
  float drawSize;
  
  PVector movement = new PVector(0,0);
  
  
  int id, regRow, regCol;
  
  Agent (int x, int y) {
    pos = new PVector(x, y);
  }
  
  
//////////////////////////////////////////////////////
  Agent updColDistMap(){ 
    
    float bd = brightness(img.getPix(pos, "densMap", colDist));
    //float bc = brightness(img.getPix(pos, "src"));
    //float b = (bd+bc)/2;
    float b = gaus(bd,1,0.5,0.2);
    //float b = bd;
    colDist += (b-colDist) * fatSpeed;
    return this;
  }
  
  Agent updColDist(){ 
    float br = 1-brightness(img.getPix(pos, "brMap", colDist));
    float s = map(br, 0, 1, minSize_, maxSize_);
    colDist += map(s-colDist, 0, maxSize_, 0, fatSpeed);
    return this;
  }
  
  
  ///////////////////////////
  Agent updDrawSize(){ 
    drawSize = map(colDist, minSize_, maxSize_, gap, maxSize_) -gap;
    return this;
  }
  
  ///////////////////////////
  void updHeightSize() {
    float k = 2;
    float hk = map(pos.y, 0, height, k, 1/k);
    minSize_= minSize*hk;
    maxSize_ = maxSize*hk;
  }
  
  
  ///////////////////////////
  Agent updContour(){
    
    color mapPix = img.getPix(pos, "gradMap", colDist);
    float xVect = map(red(mapPix), 0, 1, -1, 1);
    float yVect = map(green(mapPix), 0, 1, -1, 1);
    contVect.add(xVect, yVect);
    
    if (agentDebug) { //debug
      float mult = 20;
      pushMatrix(); translate(pos.x,pos.y);
      strokeWeight(0.5);  stroke(1,0,0);
      line(0,0, contVect.x * mult, contVect.y * mult);
      popMatrix();
    }
    return this;
  }
    
  
  ///////////////////////////
  Agent updCollision(Agent other) {  //for loop
    
    float radThis = colDist/2;
    float radOther = other.colDist/2;
    float distance = (pos.dist(other.pos) - radThis - radOther) /2;
    
    float maxMagnDist = maxSize_*2;
    float magnForce = 0.0005; //0.00075
    
    if (distance<0) { 
      if (radOther<0.001){radOther=0.001*(abs(radOther)/radOther);}
      PVector antiCol_other = PVector
        .sub(pos, other.pos)
        .setMag(constrain(map(distance, -radOther, 0, distance, 0), distance, 0 )); //???
      other.colVector.add(antiCol_other);
      
      if (abs(radThis)<0.001){radThis=0.001*(abs(radThis)/radThis);}
      PVector antiCol_this = PVector
        .sub(other.pos, pos)
        .setMag(constrain(map(distance, -radThis, 0, distance, 0), distance, 0));
      colVector.add(antiCol_this);
      
    }
    else if (distance<= maxMagnDist) {
      
      PVector antiCol_other = PVector
          .sub(pos, other.pos)
          .setMag(map(distance, 0, maxMagnDist, 0, magnForce));
        other.colVector.add(antiCol_other);
        
      PVector antiCol_this = PVector
        .sub(other.pos, pos)
        .setMag(map(distance, 0, maxMagnDist, 0,  magnForce));
      colVector.add(antiCol_this);
    }
    
    return this;
  }
  
  
  ///////////////////////////
  void move() {
    //println("col "+colVector.mag());
    //println("con "+contVect.mag());
    
    float contWeight = 0.5;
    float colWeight = 2;
    PVector vectSum = new PVector();
    vectSum.add(contVect.mult(contWeight));
    vectSum.add(colVector.mult(colWeight));
    
    vectSum.mult(1.0/(contWeight+colWeight));
    //println(vectSum.mag());
    //println(movement.mag());
    //println(colDist);
    //println();

    
    movement.add(vectSum);
    
    //float m = constrain(map(movement.mag(), 0,maxSize_, 0, movSpeed),-maxSize_, maxSize_);
    //movement.setMag( constrain(movement.mag(),0, minSize_));
    pos.add(movement);
  }
  
  
  ///////////////////////////
  void resetVectors() {
    colVector.mult(0);
    contVect.mult(0);
    
    movement.mult(0.8);
  }
  

    
  ///////////////////////////
  void render(){
    pushMatrix();
    fill(0, 1); noStroke();
   
    ellipse(pos.x, pos.y, drawSize, drawSize);
    popMatrix();
  } 
  
  ///////////////////////////
  void kick() {
   if(doKick) {
     float force = 3*maxSize_;
     pos.add(random(-force, force), random(-force, force));
   }
  }
  
  ///////////////////////////
  void tick() {
    updContour();
    //updHeightSize();
    updColDist();
    updDrawSize();
    kick();
    move();
    render();
    resetVectors();
  }
    
}
  
  
int passFrame = 1;

float gap = 4;

float maxSize = 15;
float minSize = maxSize/2;

float maxSizeDraw = maxSize-gap;
float minSizeDraw = gap;
//float maxSizeDraw = maxSize;
//float minSizeDraw = minSize;


float fatSpeed = maxSize/30; // скорость увеличения радуса 0-1
float movSpeed = maxSize/4;

float contDist = minSize*2;

boolean agentDebug = false;


int regSize = 100;//ceil(maxSize/4);
float serchRad = maxSize/2;

//////////////////////////////////////////////////////
class  agContainer {
  ArrayList<Agent> container = new ArrayList<Agent>();
  ArrayList[][] regs;
  int rows, cols;
  int agCount = 0;
  
  agContainer() {
    cols = ceil(width/regSize);
    rows = ceil(height/regSize);
    regs = new ArrayList[rows][cols];
  }
  
  
  ///////////////////////////
  void newAgent(int x, int y) {
    agCount++;
    
    int row = getRowByY(y);
    int col = getColByX(x);

    Agent newAg = new Agent(x, y);
    newAg.id = agCount;
    addToReg(row, col, newAg);
    
    container.add(newAg);
  }
  
  
  ///////////////////////////
  void updReg(Agent ag) {
    int row = getRowByY(ag.pos.y);  
    int col = getColByX(ag.pos.x); 

    if (!(row == ag.regRow && col == ag.regCol)){
      
      ArrayList<Agent> cell = regs[ag.regRow][ag.regCol];
      cell.remove(cell.indexOf(ag));
      addToReg(row, col, ag);
    } 
  }
  
  void addToReg(int row, int col, Agent ag){
    if (0 < row && row < rows && 0 < col && col < cols) { // 
      ArrayList<Agent> cell = regs[row][col];
      if (cell == null){regs[row][col] = new ArrayList<Agent>(); cell = regs[row][col];}
      cell.add(ag);
        
      ag.regRow = row; ag.regCol = col;
    }
    
  }

  ///////////////////////////
  ArrayList<Agent> getReg(int row, int col) {
    ArrayList<Agent> cell = regs[row][col];
    if (cell == null){regs[row][col] = new ArrayList<Agent>(); cell = regs[row][col];}   
    return cell;
  }
  
  ///////////////////////////
  int getRowByY(float y) {
    return int(y/regSize);
  }
  
  int getColByX(float x) {
    return int(x/regSize);
  }
  
  
  /////////////////////////// add exceptions
  int[][] getNeighbourCells(Agent ag) {

    int row0 = getRowByY(ag.pos.y - serchRad);
    int row1 = getRowByY(ag.pos.y + serchRad);
    int col0 = getColByX(ag.pos.x - serchRad);
    int col1 = getColByX(ag.pos.x + serchRad);
    
    //println(ag.pos.y, ag.pos.x, dlt);
    //println(row0, row, row1);
    //println(col0, col, col1);
    //println(rows, cols);
    //println(" ");
    
    return new int[][]{{row0, row1},{col0, col1}};
  }
  
  
  ///////////////////////////
  
  void tick(){
    
    for (int iAg = 0; iAg < container.size(); iAg++) {
      
      Agent agent = container.get(iAg);
      
      for (int iOther = iAg+1; iOther < container.size(); iOther++) { // check!
              
        agent.updCollision(container.get(iOther));  
      }
      
      agent.tick();
          
    }
    doKick = false;
         

  } 

  
  
  void tick2(){
    
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
       
        ArrayList<Agent> regAgs = getReg(row, col);
        for (int iAg = 0; iAg < regAgs.size(); iAg++) {
          
          Agent agent = regAgs.get(iAg);
          
          
          int[][]NbrCells = getNeighbourCells(agent);
          
          //println(rows, cols);
          //println(getRowByY(agent.pos.y), getColByX(agent.pos.y));
          //printInt2d(NbrCells);
          
          //noFill(); ellipseMode(CENTER); stroke(0);
          //ellipse(agent.pos.x,agent.pos.y,serchRad,serchRad);
          
          for (int rowN = NbrCells[0][0]; rowN <= NbrCells[0][1]; rowN++) { // check!
            if (0 > rowN || rowN >= rows){continue;}
            //println();
            //println(rowN+"r ");
            for (int colN = NbrCells[1][0]; colN <= NbrCells[1][1]; colN++) { // check!
              if (0 > colN || colN >= cols){continue;}
              
              //print(colN);
              // check if passed!
              ArrayList<Agent> cell = regs[rowN][colN];
              for (Agent agNbr : cell) {
                if (agNbr.id<= agent.id) {continue;}
                //if (agNbr == agent) {continue;}
                agent.updCollision(agNbr);  
              }
          
            }
          }
          //println();
          agent.tick();
        } 
      }
    }
    
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        ArrayList<Agent> regAgs = getReg(row, col);
        for (int iAg = 0; iAg < regAgs.size(); iAg++) {
          updReg(regAgs.get(iAg));
        }
      }
    }
    
  }
  
  void cellsDebug(){
   for (int row = 0; row<rows; row++){
     for (int col = 0; col<cols; col++){
       noFill(); stroke(0.5); 
       rect(col*regSize,row*regSize,regSize,regSize);
       
       textSize(10); textAlign(LEFT);
       String coord = row + ", " + col;
       text(coord, col*regSize+1, row*regSize+10);
     }
   }
  }
  
}


//////////////////////////////////////////////////////
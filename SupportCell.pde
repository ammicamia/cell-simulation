class SupportCell extends Cell { 
  private final int MAX_POPULATION = 40;
  private int _reproductionOffset;
  private int _reproductionCycle;
  private int _population;
  
  public SupportCell(int x, int y) {
    super(x, y);
    _sprite = loadImage("support_cell.png");
    _spriteDmg = loadImage("support_cell_damage.png");
    _detectionRadius = 200;
    _health = 12;
    _easing = 0.055;
    _reproductionOffset = (int)random(0, 150); //Randomize the offset
    _reproductionCycle = 150; //5 seconds
  }
  
  public void update(ArrayList<Cell> cellList) {
    _population = 0;
    for(Cell c: cellList) {
      if(c instanceof SupportCell) {
        _population++;
      }
    }
    moveCell(cellList);
    support();
  }
  
  //Overrides the move cell method to include avoiding enemies 
  public void moveCell(ArrayList<Cell> cellList) {
    findTarget(cellList);
    
    if(_target != null) {
      targetMovement();
    }
    else {
      idleMovement();
    }
    avoidEnemies(cellList);
    crowdingMovement(cellList);
  }
  
  //Avoids enemies
  private void avoidEnemies(ArrayList<Cell> cellList) {
    for(Cell c: cellList) {
      //Checks if there's an enemy cell nearby
      if(c != this && c instanceof EnemyCell) {
        //Calculates the distance between this cell and the enemy cell
        float distance = dist(_centre.x, _centre.y, c._centre.x, c._centre.y);
        //If the enemy cell is within 75 pixels
        if(distance < 75 && distance > 0) {
          //Normalizes the vector so the speed is consistent and doesn't jitter
          float dx = (_centre.x - c._centre.x) / distance;
          float dy = (_centre.y - c._centre.y) / distance;
          
          _centre.x += dx * 0.50;
          _centre.y += dy * 0.50;
        }
      }
    }
  }
  
  //Finds the nearest protector cell within its detection radius
  public void findTarget(ArrayList<Cell> cellList) {
    float nearestTarget = Float.MAX_VALUE;
    Cell protectorCell = null;
    
    for(Cell c: cellList) {
      if(c != this && c instanceof ProtectorCell) {
        ProtectorCell protector = (ProtectorCell) c;
        
        //Counts the pending supporters for the current protector cell
        int pendingSupporters = 0;
        for(Cell other: cellList) {
          if(other instanceof SupportCell && other != this) {
            SupportCell support = (SupportCell) other;
            if(support._target == protector) pendingSupporters++;
          }
        }
        
        //Checks if there's space in the current protector's support list
        int availability = 3 - protector.getSupportCount() - pendingSupporters;
        if(availability > 0) {
          //Calculates the distance between this cell and the protector cell
          float distance = dist(_centre.x, _centre.y, protector._centre.x, protector._centre.y);
          
          //If it's within the detection radius and is closer than the previous protector cells
            if(distance <= _detectionRadius && distance < nearestTarget) {
              //Sets the nearest target distance to the current distance
              nearestTarget = distance;
              //Sets the nearest cell to the current cell
              protectorCell = protector;
            }
          }
        }
      }
    _target = protectorCell;
  }
  
  //Reproduces when specific conditions are met
  public Cell reproduce() {
    //If it's too cold or there's too many support cells (to prevent lag
    if(_reproductionCycle < 0 || _population > MAX_POPULATION) {
      return null;
    }
    
    //Spawns a new cell every few seconds with an offset to prevent cells from reproducing at the same time
    if((frameCount + _reproductionOffset) % _reproductionCycle == 0) {
      return new SupportCell((int)random(width), (int)random(height));
    }
   
    return null;
  }
  
  //Changes speed and reproduction rate based on temperature
  public void checkTemp(int temperature) {
    //No reproduction and very slow speed in the cold
    if(temperature <= 25) {
      _reproductionCycle = -1;
      _easing = 0.010;
    }
    //Faster reproduction but slower speed in the heat
    else if(temperature >= 75) {
      _reproductionCycle = 90;
      _easing = 0.040;
    }
    //Normal reproduction and speed
    else {
      _reproductionCycle = 150;
      _easing = 0.055;
    }
  }
  
  //Adds support cell to list of the protector's supports
  public void support() {
    if(_target instanceof ProtectorCell) {
      ProtectorCell protector = (ProtectorCell) _target;
      if(isCollided(_target)) {
        protector.addSupport(this);
      }
    }
  }
}

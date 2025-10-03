class ProtectorCell extends Cell {
  private ArrayList<SupportCell> _supportList;
  private PImage _spriteImmune;
  private int _attack;
  private int _kills;
  private int _killCap;
  private int _lastMeal;
  private int _hungerLimit = 20000;
  private boolean _immune = false;
  private int _immuneStart = 0;
  private int _immuneDuration = 3000;
  
  public ProtectorCell(int x, int y) {
    super(x, y);
    _sprite = loadImage("protector_cell.png");
    _spriteDmg = loadImage("protector_cell_damage.png");
    _spriteImmune = loadImage("protector_cell_immune.png");
    _supportList = new ArrayList<SupportCell>();
    _detectionRadius = 700;
    _easing = 0.045;
    _health = 20;
    _attack = 2;
    _kills = 0;
    _killCap = 1;
    _lastMeal = millis(); //Start the last meal timer
  }
  
  //Overrides the draw cell method to include the immune state
  public void drawCell() {
    if(_immune) {
      image(_spriteImmune, _centre.x, _centre.y);
    }
    else {
      super.drawCell();
    }
  }
  
  public void update(ArrayList<Cell> cellList) {
    moveCell(cellList);
    attack(cellList);
    
    //Reset the immunity status if 3 seconds have already passed
    if(_immune && millis() - _immuneStart > _immuneDuration) {
      _immune = false;
      _easing = 0.045;
    }
    checkHunger();
    resetSupportStatus();
  }
  
  //Finds the nearest enemy cell within its detection radius
  public void findTarget(ArrayList<Cell> cellList) {
    float nearestTarget = Float.MAX_VALUE;
    Cell enemyCell = null;
    
    for(Cell c: cellList) {
      if(c != this && c instanceof EnemyCell) {
        //Calculates the distance between this cell and the other cell
        float distance = dist(_centre.x, _centre.y, c._centre.x, c._centre.y);
      
        //If it's within the detection radius and is closer than previous cells
        if(distance <= _detectionRadius && distance < nearestTarget) {
          //Sets the nearest target distance to the current distance
          nearestTarget = distance;
          //Sets the nearest cell to the current cell
          enemyCell = c;
        }     
      }
    }
    _target = enemyCell;
  }
  
  //Attacks by checking if this cell collides with any enemy cells
  public void attack(ArrayList<Cell> cellList) {
    for(Cell c: cellList) {
      if(c != this && c instanceof EnemyCell) {
        //Checks if a collision occurs
        if(isCollided(c)) {
          EnemyCell enemy = (EnemyCell) c;
          
          //Increases attack if it's supported
          if(_supportList.size() == 3) {
            _attack = 4;
          }
          else {
            _attack = 2;
          }
        
          enemy.damage(_attack);
          //Checks if the cell is dead
          if(!_immune && enemy.isDead()) {
            //Increases the kill count
            _kills++;
            //Resets the timer
            _lastMeal = millis();
          }
        }
      }
    }
  }
  
  //Reproduces when the kill cap is reached
  public Cell reproduce() {
    if(_kills >= _killCap) {
      _kills = 0;
      return new ProtectorCell((int)random(width), (int)random(height));
    }
    return null;
  }
  
  //Changes the detection radius based on temperature
  public void checkTemp(int temperature) {
    //Lowers detection radius in the heat
    if(temperature >= 75) {
      _detectionRadius = 300;
    }
    //Normal detection radius
    else {
      _detectionRadius = 700;
    }
  }
  
  //Checks hunger
  public void checkHunger() {
    //If the cell hasn't killed within a certain amount of time (hunger limit)
    if(millis() - _lastMeal > _hungerLimit) {
      _dead = true;
    }
  }
  
  //Sets the kill cap
  public void setKillCap(int reprodRate) {
    _killCap = reprodRate;
  }
  
  //Triggers immunity
  public void triggerImmunity() {
    _immune = true;
    _easing = 0.050;
    _immuneStart = millis(); //Starts the timer
  }
  
  //Gets the immunity status
  public boolean isImmune() {
    return _immune;
  }
  
  //Adds a support to the list
  public void addSupport(SupportCell s) {
    //Checks if the list doesn't contain the support cell and the support list is less than 3
    if(!_supportList.contains(s) && _supportList.size() < 3) {
      _supportList.add(s);
    }
  }
  
  //Resets the support status
  private void resetSupportStatus() {
    _supportList.clear();
  }
  
  //Gets the number of current supports
  public int getSupportCount() {
    return _supportList.size();
  }
}

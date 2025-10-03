class EnemyCell extends Cell {
  private int _maxHealth;
  private int _attack;
  private int _kills;
  private int _killCap;
  private int _lastMeal;
  private int _hungerLimit = 15000;
  
  public EnemyCell(int x, int y) {
    super(x, y);
    _sprite = loadImage("enemy_cell.png");
    _spriteDmg = loadImage("enemy_cell_damage.png");
    _detectionRadius = 500;
    _easing = 0.045;
    _maxHealth = 15;
    _health = _maxHealth;
    _attack = 3;
    _kills = 0;
    _killCap = 3;
    _lastMeal = millis(); //Start the last meal timer
  }
  
  public void update(ArrayList<Cell> cellList) {
    moveCell(cellList);
    attack(cellList);
    checkHunger();
  }
  
  //Finds the nearest support or protector cell within its detection radius
  public void findTarget(ArrayList<Cell> cellList) {
    float nearestTarget = Float.MAX_VALUE;
    Cell targetCell = null;
    
    for(Cell c: cellList) {
      if(c != this && !(c instanceof EnemyCell)) {
        //Calculates the distance between this cell and the other cell
        float distance = dist(_centre.x, _centre.y, c._centre.x, c._centre.y);
      
        //If it's within the detection radius and is closer than previous cells
        if(distance <= _detectionRadius && distance < nearestTarget) {
          //Checks if it's a support cell
          if(c instanceof SupportCell) {
            //Sets the nearest target distance to the current distance
            nearestTarget = distance;
            //Sets the nearest cell to the current cell
            targetCell = c;
            break; //Breaks the loop
          }
          //Checks if its a protector cell
          else if(c instanceof ProtectorCell) {
            ProtectorCell p = (ProtectorCell) c;
            if(p.getSupportCount() < 3){
              nearestTarget = distance;
              targetCell = c;
            }
          }
        }
      }
    }
    _target = targetCell;
  }
  
  //Attacks by checking if this cell collides with any support or protector cell
  public void attack(ArrayList<Cell> cellList) {  
    for(Cell c: cellList) {
      if(c != this && !(c instanceof EnemyCell)) {
        //Checks if a collision occurs
        if(isCollided(c)) {
          if(c instanceof SupportCell) {
            SupportCell support = (SupportCell) c;
            //Applies damage
            support.damage(_attack);
            //Checks if the cell is dead
            if(support.isDead()) {
              //Increases the kill count
              _kills++;
              //Resets the timer
              _lastMeal = millis();
            }
          }
          else if(c instanceof ProtectorCell) {
            ProtectorCell protector = (ProtectorCell) c;
            if(!protector.isImmune()) {
              protector.damage(_attack);
              if(protector.isDead()) {
                _kills += 2;
                _lastMeal = millis();
              }
            }
          }
        }
      }
    }
  }
  
  //Reproduces when the kill cap is reached
  public Cell reproduce() {
    if(_kills >= _killCap) {
      _kills = 0;
      return new EnemyCell((int)random(width), (int)random(height));
    }
    return null;
  }
  
  //Changes max health and speed based on temperature
  public void checkTemp(int temperature) {
    //Lower health and slower speed in the cold
    if(temperature <= 25) {
      _maxHealth = 10;
      _health = min(_health, _maxHealth);
      _easing = 0.035;
    }
    //Normal health and speed
    else {
      _maxHealth = 15;
      _easing = 0.045;
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
}

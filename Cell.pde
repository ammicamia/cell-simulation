abstract class Cell {
  protected final int SIZE = 25;
  protected PVector _centre;
  protected float _vx;
  protected float _vy;
  protected PImage _sprite;
  protected PImage _spriteDmg;
  protected float _detectionRadius;
  protected float _easing;
  protected Cell _target;
  protected boolean _collision;
  protected int _health;
  protected boolean _dead;
  
  public Cell(int x, int y) {
    _centre = new PVector(x, y);
    _vx = random(-1.5, 1.5); //Initialize with a random direction to move towards
    _vy = random(-1.5, 1.5);
    _target = null;
    _collision = false;
    _dead = false;
  }
  
  //Draws the cell
  public void drawCell() {
    //Checks if the cell collided with another cell
    if(_collision) {
      image(_spriteDmg, _centre.x, _centre.y);
    }
    else {
      image(_sprite, _centre.x, _centre.y);
    }

    //Reset the collision after drawing
    _collision = false;
  }
  
  //Handles cell movement
  public void moveCell(ArrayList<Cell> cellList) {
    //Finds a target
    findTarget(cellList);
    
    //If there's a target, moves towards it
    if(_target != null) {
      targetMovement();
    }
    //Else, it moves idly
    else {
      idleMovement();
    }
    
    //Handles crowding
    crowdingMovement(cellList);
  }
  
  //Moves towards a target
  protected void targetMovement() {
    //Calculates the distance between the x and y of the target cell and this cell
    float dx = _target._centre.x - _centre.x;
    float dy = _target._centre.y - _centre.y;
    
    float distance = dist(_centre.x, _centre.y, _target._centre.x, _target._centre.y);
    //If the distance is within the detection radius
    if(distance <= _detectionRadius) {
      //Moves towards the target with the set speed
      _centre.x += (dx * _easing);
      _centre.y += (dy * _easing);
    }    
  }
  
  //Moves the cell in random directions
  protected void idleMovement() {
    //Adds random velocity to the x and y of the cell
    _centre.x += _vx;
    _centre.y += _vy;
    
    //Bounce off walls
    if(_centre.x > width - (SIZE / 2)) {
      _centre.x = width - (SIZE / 2);
      _vx *= -1;
    }
    else if(_centre.x < (SIZE / 2)) {
      _centre.x = SIZE / 2;
      _vx *= -1;
    }
    else if(_centre.y > height - (SIZE / 2)) {
      _centre.y = height - (SIZE / 2);
      _vy *= -1;
    }
    else if(_centre.y < (SIZE / 2)) {
      _centre.y = SIZE / 2;
      _vy *= -1;
    }
    
    //Changes direction every 3 seconds
    if(frameCount % 90 == 0) {
      _vx = random(-1.5, 1.5);
      _vy = random(-1.5, 1.5);
    }
  }
  
  //Handles crowding so they don't stack on top of each other
  protected void crowdingMovement(ArrayList<Cell> cellList) { 
    for(Cell c: cellList) {
      if(c == this) continue;

      //Calculates the distance between this cell and the other cell
      float distance = dist(_centre.x, _centre.y, c._centre.x, c._centre.y);
      
      //If their distance is closer than their size
      if(distance > 0 && distance < SIZE) {
        float push = (SIZE - distance) * 0.3;
        
        //Calculates the normalized direction to push this cell from the other c ell
        float nx = (_centre.x - c._centre.x) / distance;
        float ny = (_centre.y - c._centre.y) / distance;
        
        _centre.x += nx * push;
        _centre.y += ny * push;
      }
    }
  }
  
  //Checks if a collision happens
  public boolean isCollided(Cell c) {
    return dist(_centre.x, _centre.y, c._centre.x, c._centre.y) < SIZE;
  }
  
  //Decreases health based on attack
  public void damage(int attack) {
    _health -= attack;
    _collision = true;
    
    //Checks if the cell is dead
    if (_health <= 0) {
      _dead = true;
    }
  }
  
  //Gets the status of the cell, dead or not
  public boolean isDead() {
    return _dead;
  }
 
  public abstract void findTarget(ArrayList<Cell> cellList);
  public abstract void update(ArrayList<Cell> cellList);
  public abstract Cell reproduce();
  public abstract void checkTemp(int temperature);
}

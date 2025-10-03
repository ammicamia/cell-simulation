import controlP5.*;
ControlP5 cp5;
Slider tempSlider;
Slider enemyReprodSlider;
Slider protectorReprodSlider;

PFont font;
PImage background;
PImage immunityButton;
PImage resetButton;
ArrayList<Button> buttonList = new ArrayList<Button>();
ArrayList<Cell> cellList = new ArrayList<Cell>();
int temperature;
int enemyReprodRate;
int protectorReprodRate;
int enemyPopulation;
int protectorPopulation;
int supportPopulation;

void setup() {
  size(1280, 720);
  frameRate(30);
  font = createFont("PIXEARG_.TTF", 10);
  background = loadImage("background.png");
  
  cp5 = new ControlP5(this);
  
  //Sliders
  tempSlider = cp5.addSlider("Temperature").setPosition(1220, 240).setSize(30, 300).setRange(0, 100).setValue(50).setColorCaptionLabel(0).setColorValueLabel(0).setColorForeground(#818181).setColorBackground(0).setColorActive(#E8E8E8);
  enemyReprodSlider = cp5.addSlider("Enemy Reprod. Rate").setPosition(850, 600).setSize(300, 30).setRange(1, 5).setValue(3).setColorCaptionLabel(0).setColorValueLabel(0).setColorForeground(#818181).setColorBackground(0).setColorActive(#E8E8E8);
  protectorReprodSlider = cp5.addSlider("Protector Reprod. Rate").setPosition(850, 670).setSize(300, 30).setRange(1, 5).setValue(1).setColorCaptionLabel(0).setColorValueLabel(0).setColorForeground(#818181).setColorBackground(0).setColorActive(#E8E8E8);
  tempSlider.getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE);
  enemyReprodSlider.getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE);
  protectorReprodSlider.getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE);
  
  //Buttons
  buttonList.add(new Button(1220, 600, "immunity.png", "Trigger Immunity"));
  buttonList.add(new Button(1220, 670, "reset.png", "Reset Simulation"));
  
  //Initialize the simulation with a set number of cells
  for(int i = 0; i < 30; i++) {
    if(i < 9) {
      cellList.add(new EnemyCell((int)random(width), (int)random(height)));
    }
    else if(i < 23) {
      cellList.add(new SupportCell((int)random(width), (int)random(height)));
    }
    else {
      cellList.add(new ProtectorCell((int)random(width), (int)random(height)));
    }
  }
}

void draw() {
  textFont(font);
  background(background);
  
  enemyPopulation = 0;
  protectorPopulation = 0;
  supportPopulation = 0;
  
  temperature = (int)tempSlider.getValue();
  enemyReprodRate = (int)enemyReprodSlider.getValue();
  protectorReprodRate = (int)protectorReprodSlider.getValue();
  
  ArrayList<Cell> newCells = new ArrayList<Cell>();
  
  for(int i = cellList.size() - 1; i >= 0; i--) {
    Cell c = cellList.get(i);
    
    //Counts the populations of each cell and sets the kill caps for enemy and protector cells
    if(c instanceof EnemyCell) {
      enemyPopulation++;
      ((EnemyCell) c).setKillCap(enemyReprodRate);
    }
    else if(c instanceof ProtectorCell) {
      protectorPopulation++;
      ((ProtectorCell) c).setKillCap(protectorReprodRate);
    }
    else if(c instanceof SupportCell) {
      supportPopulation++;
    }
    
    c.drawCell();
    c.checkTemp(temperature);
    c.update(cellList);
    
    Cell child = c.reproduce();
    if(child != null) {
      newCells.add(child);
    }
    
    if(c.isDead()) {
      cellList.remove(i);
    }
  }
  
  //Adds newly spawned cells to the current list
  cellList.addAll(newCells);
  
  //Spawns support cells naturally if they've all died
  if(supportPopulation < 3 && frameCount % 300 == 0) {
    cellList.add(new SupportCell((int)random(width), (int)random(height)));
  } 
  
  temperatureOverlay();
  
  for(Button b: buttonList) {
    b.drawButton();
  }
  
  //Population counters
  fill(0);
  text("Population:", 60, 25);
  text("Enemies: " + enemyPopulation, 60, 50);
  text("Protectors: " + protectorPopulation, 60, 75);
  text("Supports: " + supportPopulation, 60, 100);
}

//Draws an overlay based on the temperature
void temperatureOverlay() {
  if(temperature <= 25) {
    fill(#0035ED, 50);
  }
  else if(temperature >= 75) {
    fill(#C60000, 50);
  }
  else {
    return;
  }
  
  //Draws a rectangle with the specified colour and 50% opacity
  noStroke();
  rect(0, 0, width, height);
}

//Triggers immunity for protector cells
void triggerImmunity() {
  for(Cell c: cellList) {
    if(c instanceof ProtectorCell) {
      ((ProtectorCell) c).triggerImmunity();
    }
  }
}

//Resets the simulation
void resetSimulation() {
  //Clears the list of cells
   cellList.clear();
    
  //Reinitializing the list
  for(int i = 0; i < 30; i++) {
    if(i < 9) {
      cellList.add(new EnemyCell((int)random(width), (int)random(height)));
    }
    else if(i < 23) {
      cellList.add(new SupportCell((int)random(width), (int)random(height)));
    }
    else {
      cellList.add(new ProtectorCell((int)random(width), (int)random(height)));
    }
  }
}

void mousePressed() {
  for(Button b: buttonList) {
    //Checks which button was clicked
    if(b.isClicked(mouseX, mouseY)) {
      if(b.getLabel().equals("Trigger Immunity")) {
        triggerImmunity();
      }
      else if(b.getLabel().equals("Reset Simulation")) {
        resetSimulation();
      }
    }
  }
}

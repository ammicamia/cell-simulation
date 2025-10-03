public class Button {
  private PVector _centre;
  private PImage _img;
  private String _label;
  
  public Button(int x, int y, String imgPath, String label) {
    _centre = new PVector(x, y);
    _img = loadImage(imgPath);
    _label = label;
  }
  
  //Gets the button label
  public String getLabel() {
    return _label;
  }
  
  //Draws the button and its label
  public void drawButton() {
    imageMode(CENTER);
    image(_img, _centre.x, _centre.y);
    
    fill(0);
    textAlign(CENTER);
    text(_label, _centre.x, _centre.y + 40);
  }
  
  //Checks if the button has been clicked
  public boolean isClicked(int x, int y) {
    if((x >= _centre.x - _img.width / 2) && (x <= (_centre.x + _img.width / 2)) && (y >= _centre.y - _img.height / 2) && (y <= (_centre.y + _img.height / 2))) {
      return true;
    } else {
      return false;
    }
  }
}

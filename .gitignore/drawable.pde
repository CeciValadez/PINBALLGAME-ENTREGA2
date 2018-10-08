class Drawable
{
  // The fill color of the object
  color fillColor = color(255);

  // The stroke color of the object
  color strokeColor = color(0); 

  // Changes the color appropriately (doesn't work on PShapes) 
  void render()
  {
    stroke(strokeColor);
    fill(fillColor);
  }
}

/**
*Class for a single hexagon cell that can either be ice or not ice and stores the previous state.
*Contains an array to store the 6 neighbouring hexs.
*/
class Hex{
  float x;
  float y;
  float radius;
  int row;
  int col;
  final float ANGLE = TWO_PI/6; //internal angle of a hexagon
  boolean ice; //current state
  boolean previous; //previous state
  color c = color(50,48,224);
  Hex[] neighbours;
  
  /**
  *Constructor class that takes in the x and y coordinates, the radius and the row and column numbers.
  *Sets initial value of ice to false and creates new array for storing the neighbours.
  *@param x_in the x coordinate of the centre of the hexagon
  *@param y_in the y coordinate of the centre of the hexagon
  *@param radius_in the radius of the hexagon
  *@param row_in the row number of the hexagon
  *@param col_in the column number of the hexagon
  */
  public Hex(float x_in, float y_in, float radius_in, int row_in, int col_in){
    this.x = x_in;
    this.y = y_in;
    this.radius = radius_in;
    this.row = row_in;
    this.col = col_in;
    this.ice = false;
    this.previous = false;
    this.neighbours = new Hex[6];
  }
  
  /**
  *Displays the hexagon centered at the x and y coordinates using the interior angle of a hexagon as two_pie/6
  *Fills the hex in if it is ice, otherwise it has no fill.
  */
  public void display(){
    if (ice){
      fill(c);
    }else{
      noFill();
    }
    beginShape(); //code adapted from: https://processing.org/examples/regularpolygon.html
    for (float i = PI/6; i < TWO_PI; i += ANGLE){
      float sx = x + cos(i) * radius;
      float sy = y + sin(i) * radius;
      vertex(sx, sy);  
    }
    endShape(CLOSE);
  }
  
  /**
  *Sets the hex at the given index to the passed in hex.
  *@param index index of the neighbour to set
  *@param h the hex object of the neighbour to store
  */
  public void setNeighbours(int index, Hex h){
    this.neighbours[index] = h;    
  }
  
  /**
  *@return the array of neighbouring hexs
  */
  public Hex[] getNeighbours(){
    return this.neighbours;
  }
  
  /**
  *@return the x coordinate
  */
  public float getX(){
    return this.x;  
  }
  
  /**
  *@return the y coordinate
  */
  public float getY(){
    return this.y;  
  }
  
  /**
  *@return the radius
  */
  public float getRadius(){
    return this.radius;  
  }
  
  /**
  *@return the row number
  */
  public int getRow(){
    return this.row;  
  }
  
  /**
  *@return the column number
  */
  public int getCol(){
    return this.col;  
  }
  
  /**
  *@return the previous state of the hex
  */
  public boolean wasIce(){
    return this.previous;  
  }
  
  /**
  *Sets the state of the hex to the given boolean and updates the previous value
  *@param b the new state of the hex, true means ice, false means not ice
  */
  public void setIce(boolean b){
    this.previous = this.ice;
    this.ice = b;  
  }
  
  /**
  *Fully updates the hex so that the previous state is no longer remembered.
  */
  public void update(){
    this.previous = this.ice;
  }
}

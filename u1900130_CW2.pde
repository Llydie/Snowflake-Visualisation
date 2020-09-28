import controlP5.*; //library sourced from http://www.sojamo.de/libraries/controlP5/

Hex[][] grid; //Cellular Automata grid
int radius = 8; //radius of the hex cells
int rows; 
int cols; 
int count;
int state;
PFont font;
ControlP5 cp5;
DropdownList ddl;

/**
*Setup function which sets up the grid and all controlP5 elements and initialises the variables.
*/
void setup(){
  size(1280,720);
  font = createFont("Arial",20);
  textFont(font);
  ControlFont cFont = new ControlFont(font,20);
  count = 0;
  state = 0;
  rows = width/(int)(radius*1.95);
  cols = height/(int)(radius*1.95);
  grid = new Hex[rows][cols];
  float x = 50 + sqrt(3)*radius; //initial centre x coordinate
  float y = 100 + radius; //initial centre y coordinate
  stroke(0);
  for (int i=0; i<cols; i++){ //code adapted from http://louisc.co.uk/?p=2554
    for (int j=0; j<rows; j++){
      grid[j][i] = new Hex(x,y,radius,j,i);
      grid[j][i].setIce(false);
      x = x + radius*sqrt(3);
    }
    y = y + (radius*3)/2;
    if ((i+1)%2 == 0){
      x = 50 + sqrt(3)*radius;  
    }else{
      x = 50 + radius*sqrt(3)/2;
    }
  } 
  cp5 = new ControlP5(this);
  cp5.setFont(cFont); //set to the font created above which is easier to read
  cp5.addButton("Run")
    .setPosition(50,25)
    .setSize(125,60);
  cp5.addButton("Step")
    .setPosition(200,25)
    .setSize(125,60);
  cp5.addButton("Reset")
    .setPosition(350,25)
    .setSize(125,60);
  cp5.addButton("Branch")
    .setPosition(500,25)
    .setSize(125,60);
  cp5.addButton("Facet")
    .setPosition(650,25)
    .setSize(125,60);
  cp5.addButton("Grow")
    .setPosition(800,25)
    .setSize(125,60);
  ddl = cp5.addDropdownList("List")
    .setPosition(950,25)
    .setSize(285,100)
    .setBarHeight(30)
    .setItemHeight(25)
    .setOpen(false);
  
  //style the drop down list to make it format correctly and add the items
  ddl.getCaptionLabel().set("Preset options");
  ddl.getCaptionLabel().getStyle().marginTop = 7;
  ddl.getCaptionLabel().getStyle().marginLeft = 3;
  ddl.getValueLabel().getStyle().marginTop = 7;
  ddl.addItem("Plate Snowflake", 0);
  ddl.addItem("Needle", 1);
  ddl.addItem("Stellar Dendrite", 2);
  
  //set the frame rate and starting cell configurations 
  simpleConfig();
  frameRate(5);
}

/**
*Main draw function that displays the grid each time and then checks which state the program is in before executing the required function
*/
void draw(){
  background(200,200,200); //first draw the general sketch set up
  fill(255);
  rect(48,97,1188,586);
  stroke(200,200,200);
  for(int i=0; i<cols; i++ ){
    for(int j=0; j<rows; j++){
       grid[j][i].display(); //draw the grid in the current state
    }
  }
  
  switch (state){
    case(0): return; //waiting for input
    case(1): run(); break; //calls the run function until the state is changed
    case(2): plate(); break; //calls the plate function until the state is changed
    case(3): needle(); break; //calls the needle function until the state is changed
    case(4): dendrite(); //calls the dendrite function until the state is changed
  }
}

/**
*Main run function for picking and executing one of the rules
*Uses a random number between 0 and 1 to choose which rule will be executed to create random snowflakes each time
*/
void run(){
  findNeighbours(); //find the neighbours for each cell
  float rand = random(0,1);
  int rule;
  if (rand > 0.22){ //about 78% probability of being chosen
    rule = 0;
  }else if (rand < 0.08){ //about 7% probability of being chosen
    rule = 1;
  }else{ //about 15% probability of being chosen
    rule = 2;
  } 
  for(int i=0; i<cols; i++ ){
    for(int j=0; j<rows; j++){
       switch (rule){ //execute the chosen rule
         case (0): branch(grid[j][i],i,j); break;
         case (1): grow(grid[j][i],i,j); break;
         case(2): facet(grid[j][i],i,j);
       }
    }
  } 
  for(int i=0; i<cols; i++ ){
    for(int j=0; j<rows; j++){
       grid[j][i].update(); //after all cells have been set, update the grid
    }
  }
  if (state == 1){   //only increase the count if in state 1
    count++;
    if (count == 25){
      state=0; //revert to state 0 when run 25 times
    }
  }
}

/**
*Event listener for mouse clicks which toggles the state of the chosen cell 
*/
void mouseClicked(){
  if (state ==0){ //only allow cell toggle when waiting for input
    for(int i=0; i<cols; i++ ){
      for(int j=0; j<rows; j++){
         if (dist(grid[j][i].getX(), grid[j][i].getY(), mouseX, mouseY) < radius){ //if the click is within the radius of the cell change state of that hex 
           if (grid[j][i].wasIce()){  
             grid[j][i].setIce(false);
             grid[j][i].update();
             grid[j][i].display();
           }else{
             grid[j][i].setIce(true);
             grid[j][i].update();
             grid[j][i].display();
           }
         }
      }
    }
  }
}

/**
*Event listener for key presses which saves an image of just the grid with the snowflake on (not the whole sketch)
*/
void keyPressed(){
  if (key == 's'){ //code adapted from https://processing.org/discourse/beta/num_1228439740.html
    PImage img = get(50,100,1185,580);
    img.save("Snowflake.jpg"); 
  }
}

/**
*Event listener for the buttons and drop-down list
*Checks which button or option was selected and executes the relevant code
*@param theEvent controller of the triggered event
*/
public void controlEvent(ControlEvent theEvent) { //code adapted from http://www.sojamo.de/libraries/controlP5/examples/controllers/ControlP5button/ControlP5button.pde
  String selected = (String) ddl.getItem((int)theEvent.getValue()).get("name"); //gets the name of the option selected in the drop-down list
  if (theEvent.getController().getName().equals("Run")){
    //runs the CA with the max number of steps
    count=0;
    state = 1;  
  }else if (theEvent.getController().getName().equals("Step")){
    //Runs the CA once so only one of the rules is selected
    run();
    //state = 0;  //call CA rule once
  }else if (theEvent.getController().getName().equals("Reset")){
    //reset all variables and revert the grid to the starting configuration
    state = 0;
    count = 0;
    ddl.getCaptionLabel().set("Preset options");
    simpleConfig();
  }else if(theEvent.getController().getName().equals("Branch")){
    //calls the branch rule once and updates the grid
    findNeighbours();
    for(int i=0; i<cols; i++ ){
      for(int j=0; j<rows; j++){
         grid[j][i].display();
         branch(grid[j][i],i,j);
      }
    } 
    for(int i=0; i<cols; i++ ){
      for(int j=0; j<rows; j++){
         grid[j][i].update();
      }
    }  
  }else if(theEvent.getController().getName().equals("Facet")){
    //calls the facet rule once and updates the grid
    findNeighbours();
    for(int i=0; i<cols; i++ ){
      for(int j=0; j<rows; j++){
         grid[j][i].display();
         facet(grid[j][i],i,j);
      }
    } 
    for(int i=0; i<cols; i++ ){
      for(int j=0; j<rows; j++){
         grid[j][i].update();
      }
    }   
  }else if(theEvent.getController().getName().equals("Grow")){
    //calls the grow rule once and updates the grid
    findNeighbours();
    for(int i=0; i<cols; i++ ){
      for(int j=0; j<rows; j++){
         grid[j][i].display();
         grow(grid[j][i],i,j);
      }
    } 
    for(int i=0; i<cols; i++ ){
      for(int j=0; j<rows; j++){
         grid[j][i].update();
      }
    }   
  }else if (selected.equals("Plate Snowflake")){
    //changes the program to state 2
    simpleConfig();
    count = 0;
    state = 2;
  }else if (selected.equals("Needle")){
    count = 0;
    for(int i=0; i<cols; i++ ){ //clear the grid to allow for a different starting set up
      for(int j=0; j<rows; j++){
        grid[j][i].setIce(false);
        grid[j][i].update();
      }
    }
    Hex mid = grid[rows/2][cols/2];
    mid.setIce(true); //set the middle hex to ice
    mid.update();
    mid.display();
    Hex diag = grid[mid.getRow()][mid.getCol()+1];
    diag.setIce(true); //set the middle diagonal hex to ice
    diag.update();
    diag.display();
    state = 3; //change to state 3
  }else if (selected.equals("Stellar Dendrite")){
    //changes program to state 4
    simpleConfig();
    count = 0;
    state = 4;
  }
}

/**
*Clears the grid and then creates a simple hexagon in the centre of the grid
*/
void simpleConfig(){
  for(int i=0; i<cols; i++ ){
    for(int j=0; j<rows; j++){
      grid[j][i].setIce(false);
      grid[j][i].update();
    }
  }
  Hex mid = grid[rows/2][cols/2]; //find middle hex
  mid.setIce(true);
  mid.update();
  findNeighbours();
  for(int i=0; i<cols; i++ ){
    for(int j=0; j<rows; j++){
      grow(grid[j][i],i,j); //grow to create a proper hexagon
    }
  } 
  for(int i=0; i<cols; i++ ){
    for(int j=0; j<rows; j++){
      grid[j][i].update();
      grid[j][i].display(); //display on screen
    }
  }
}

/**
*Grow rule which turns any cell neighbouring an ice cell to ice 
*@param h the hex to execute growth on
*@param i the column number of the hex
*@param j the row number of the hex
*/
void grow(Hex h, int i, int j){
  Hex[] neighbours = h.getNeighbours(); //get array of neighbours
  boolean grow = false;
  for (int n=0; n<neighbours.length; n++){
    if (neighbours[n] != null){
      if (neighbours[n].wasIce()){
        grow = true; //if there is a neighbouring ice cell, this cell will grow
      }
    }
  }
  if (grow){
    grid[j][i].setIce(true);
  }
}

/**
*Facet rule which turns any cell neighbouring 3 or 4 ice cells into ice 
*@param h the hex to execute faceting on
*@param i the column number of the hex
*@param j the row number of the hex
*/
void facet(Hex h, int i, int j){
  Hex[] neighbours = h.getNeighbours();
  int countFac = 0;
  for (int n=0; n<neighbours.length; n++){
    if (neighbours[n] != null){
      if (neighbours[n].wasIce()){
        countFac++; //count number of neighbouring ice cells
      }
    }
  }
  if (countFac >= 3 && countFac < 5){
    grid[j][i].setIce(true);
  }
}

/**
*Branch rule which turns any cell with a line of two or more ice cells leading up to it into ice, but there cannot be more than 1 path leading to it 
*@param h the hex to execute faceting on
*@param i the column number of the hex
*@param j the row number of the hex
*/
void branch(Hex h, int i, int j){
  Hex[] neighbours = h.getNeighbours();
  boolean grow = false;
  int countBranch = 0;
  for (int n=0; n<neighbours.length; n++){
    if (neighbours[n] == null || neighbours[n].wasIce() == false){
      continue;
    }
    Hex[] adjacent = neighbours[n].getNeighbours(); //find the neighbours of the adjacent hex
    if (adjacent[n] != null && neighbours[n].wasIce() && adjacent[n].wasIce()){ // test for line of 2
       grow = true;  
       countBranch++;
     }
    }
  if (grow && countBranch ==1){
    grid[j][i].setIce(true);
  }
}

/**
*Creates the array of neighbours for each hex by taking into account odd and even rows and edge cases.
*Edge hexs will have null neighbours
*/
void findNeighbours(){
  for(int i=0; i<cols; i++ ){
    for(int j=0; j<rows; j++){
      if (j-1 >0){ //must check not at edge of grid
        grid[j][i].setNeighbours(2,grid[j-1][i]);
      }
      if (j+1 <rows){
        grid[j][i].setNeighbours(3,grid[j+1][i]);
      }
      if (i%2 == 0){ //check if even row
        if (i-1 > 0){
          grid[j][i].setNeighbours(0,grid[j][i-1]);
        }
        if (i-1 > 0 && j+1 < rows){
          grid[j][i].setNeighbours(1,grid[j+1][i-1]);
        }
      }else{
        if (i-1 > 0 && j-1 > 0){
          grid[j][i].setNeighbours(0,grid[j-1][i-1]);
        }
        if (i-1 > 0){
          grid[j][i].setNeighbours(1,grid[j][i-1]);
        }
      }
      if (i%2 == 0){
        if (i+1 < cols && j+1 < rows){
          grid[j][i].setNeighbours(5,grid[j+1][i+1]);
        }
        if (i+1 < cols){
          grid[j][i].setNeighbours(4,grid[j][i+1]);
        }
      }else{
        if (i+1 < cols){
          grid[j][i].setNeighbours(5,grid[j][i+1]);
        }
        if (i+1 < cols && j-1 > 0){
          grid[j][i].setNeighbours(4,grid[j-1][i+1]);
        }
      }
    }
  }
}

/**
*Creates a plate snowflake by calling the grow rule 20 times
*A plate snowflake is a perfect hexagon ice crystal, often grown very slowly
*/
void plate(){
  findNeighbours();
  for(int i=0; i<cols; i++ ){
    for(int j=0; j<rows; j++){
       grid[j][i].display();
       grow(grid[j][i],i,j);
    }
  } 
  for(int i=0; i<cols; i++ ){
    for(int j=0; j<rows; j++){
       grid[j][i].update();
    }
  }  
  count++;
  if (count == 20){
    state=0;
  }
}

/**
*Creates a needle type snowflake by using the branch and grow rules depending on the value of count
*Takes 16 steps to grow the snowflake
*/
void needle(){
  findNeighbours();
  if (count < 15){
    for(int i=0; i<cols; i++ ){
      for(int j=0; j<rows; j++){
         grid[j][i].display();
         branch(grid[j][i],i,j);
      }
    } 
    for(int i=0; i<cols; i++ ){
      for(int j=0; j<rows; j++){
         grid[j][i].update();
      }
    }
  }else{
    for(int i=0; i<cols; i++ ){
      for(int j=0; j<rows; j++){
         grid[j][i].display();
         grow(grid[j][i],i,j);
      }
    } 
    for(int i=0; i<cols; i++ ){
      for(int j=0; j<rows; j++){
         grid[j][i].update();
      }
    }  
  }
  count++;
  if (count == 16){
    state=0;
  } 
}

/**
*Creates a basic form of stellar dendrite snowflakes, just one example of a whole class of snowflake type
*Uses the count number to decide when to grow, branch or facet and starts by finding the neighbours of each cell
*Takes 16 steps to grow the snowflake pattern
*/
void dendrite(){
  findNeighbours();
  if (count < 10 || (count > 10 && count < 13) || (count > 13)){
    for(int i=0; i<cols; i++ ){
      for(int j=0; j<rows; j++){
         grid[j][i].display();
         branch(grid[j][i],i,j);
      }
    } 
    for(int i=0; i<cols; i++ ){
      for(int j=0; j<rows; j++){
         grid[j][i].update();
      }
    }
  }else if (count == 10){
    for(int i=0; i<cols; i++ ){
      for(int j=0; j<rows; j++){
         grid[j][i].display();
         grow(grid[j][i],i,j);
      }
    } 
    for(int i=0; i<cols; i++ ){
      for(int j=0; j<rows; j++){
         grid[j][i].update();
      }
    }  
  }else if (count == 13){
     for(int i=0; i<cols; i++ ){
      for(int j=0; j<rows; j++){
         grid[j][i].display();
         facet(grid[j][i],i,j);
      }
    } 
    for(int i=0; i<cols; i++ ){
      for(int j=0; j<rows; j++){
         grid[j][i].update();
      }
    }  
  }
  count++;
  if (count == 16){
    state=0;
  } 
}

/* Processing desk assignment:
 " The Beautiful Desk "
 
 Interactivity: UP arrow turns on desk lamp, DOWN arrown turns off desk lamp.
 Camera movement is by default correlated to mouse position on screen.
 Several options for different camera manipulations exist in the code.
 
 This sketch explores the possibilities of interactive lighting and camera movements.
 A class Desk is created and textured using a PShape group.
 Local lighting is applied, which can be controlled by the mouse.
 4 Methods of changing the viewing angle are avaliable, each needs improvement.
 
 Suggestions for further implementation:
 - Space background option with array of stars and nebulas made with 
 perlin noise and force/flow fields. (try https://youtu.be/sor1nwNIP9A 
 or https://youtu.be/BjoM9oKOAKY and https://youtu.be/17WoOqgXsRM)
 - "Particle rain" falling on desk with physics (try https://youtu.be/wB1pcXtEwIs)
 - Wall option with global lighting scheme
 - Objects on desk with additional light and shadows
 - Use of lighting remote ( previous assignment, also try https://youtu.be/kRdw-Cm8BZ4)
 */

Desk desk;
PImage img;
int size = 300;
PMatrix topMatrix;
PMatrix lampMatrix;
boolean lampStatus = false;

void setup() {
  size(600, 600, P3D);
  frameRate(25);
  img = loadImage("wood-911002_1920.jpg");
  desk = new Desk(200, 20, 80, img); // arugements are size of desk and texture
}

void draw() {
  background(95); 
  smooth();
  ambientLight(50, 50, 50);
  directionalLight(10, 10, 210, -1, 1, -1);


  /* ----- Choose viewing method and uncomment selected:
   (Methods all need improving). ----- */

  // ----- Method 1) rotate desk around x axis
  //drawDesk();

  // ----- Method 2) rotate camera on mouse over
  //desk.disp(width/2, height/2, -40); // arguements are position of desk
  //camera(mouseX, mouseY, (mouseY/2) / tan(PI*30.0 / 180.0), 
  //  width/2.0, height/2.0, 0, 
  //  0, 1, 0);

  // ----- Method 3) rotate camera on mouse dragged (lines 239 - 245)

  // ----- Method 4) rotate light on mouse over
  //camera(width/3, height/3, (height/2) / tan(PI*45.0 / 180.0), 
  //  width/2.0, height/2.0, 0, 
  //  0, 1, 0);

  // Draw guides (optional)
  stroke(200, 225, 245, 200);
  strokeWeight(2);
  line(-width, height/2, -40, width*2, height/2, -40); // horizontal
  line(width/2, -height, -40, width/2, height*2, -40); // vertical

  // Draw desk
  desk.disp(width/2, height/2, -40); // arguements are position of desk

  // Change camera matrix on mouse over 
  camera(mouseX, mouseY, (mouseY/2) / tan(PI*30.0 / 180.0), 
    width/2.0, height/2.0, 0, 
    0, 1, 0);
}


/* ---------- Classes ---------- */

class Desk {
  PShape top, leg1, leg2, leg3, leg4;

  float xSize;
  float ySize;
  float zSize;
  PImage img;

  Desk(float x_, float y_, float z_, PImage img_) {
    xSize = x_;
    ySize = y_;
    zSize = z_;
    img = img_;
  }

  void disp(float xPos, float yPos, float zPos) {

    float legX = xSize*0.06;
    float legY = ySize*6;
    float legZ = xSize*0.06;

    noStroke();
    fill(255, 255, 255);
    top = createShape(BOX, xSize, ySize, zSize);
    leg1 = createShape(BOX, legX, legY, legZ);
    leg2 = createShape(BOX, legX, legY, legZ);
    leg3 = createShape(BOX, legX, legY, legZ);
    leg4 = createShape(BOX, legX, legY, legZ);

    top.setTexture(img);
    leg1.setTexture(img);
    leg2.setTexture(img);
    leg3.setTexture(img);
    leg4.setTexture(img);

    pushMatrix();
    float edge = legX;

    translate(xPos, yPos, zPos); // set matrix for top (will draw later for accurate lighting)
    topMatrix = getMatrix();

    translate(-((xSize/2)-(legX/2)-edge), (legY/2), ((zSize/2)-(legZ/2)-edge));
    shape(leg1); // draw front left leg

    translate(0, 0, (-(zSize-legZ-edge)));
    shape(leg2); // draw back left leg


    translate((xSize-legX-(2*edge)), 0, 0);
    shape(leg3); // draw back right leg

    translate(0, 0, (zSize-legZ-(edge)));
    shape(leg4); // draw front right leg
    popMatrix();

    //Draw table top and things on it
    lampOn(lampStatus);
    pushMatrix();
    setMatrix(topMatrix);
    shape(top); // draw desk top
    popMatrix();

    Papers(xPos, yPos -10, zPos, 5);
    Lamp(xPos + 60, yPos - 10, zPos - 20);
    Books(xPos-50, yPos-13, zPos, color(255, 0, 0), 130);
    Books(xPos-50, yPos-18, zPos, color(0, 255, 0), 150);
    drawPlane(xPos, yPos+170, zPos-40);
  }
}

void drawPlane(float x, float y, float z) {
  pushMatrix();
  translate(x, y, z);
  fill(31, 109, 49);
  beginShape();
  vertex( -size, -50, -size);
  vertex( size, -50, -size);
  vertex( size, -50, size);
  vertex( -size, -50, size);
  endShape();
  popMatrix();
}

void Books(float x, float y, float z, color col, float rot) {
  pushMatrix();
  /*translate(xPos-60,yPos-20,zPos+200);
   rotateX(80);
   rotateZ(100);
   fill(col);
   box(40,50,5);*/
  translate(x, y, z);
  rotateY(rot);
  fill(col);
  box(60, 5, 32);
  popMatrix();
}

void Papers(float x, float y, float z, int ammount) {
  //print("drawing papers on desk");
  for (int i = 0; i <= ammount; i++) {
    pushMatrix();
    fill(255, 255, 255);
    translate(x, y - i, z);
    rotateY(map(i, 0, ammount, 0, TWO_PI / 24));
    box(21, 1, 29);
    popMatrix();
  }
}

void Lamp(float x, float y, float z) {
  int basesize = 9;
  int supportline = 31;

  pushMatrix();

  translate(x, y, z);
  fill(79, 245, 251);
  sphere(basesize);

  translate(0, -basesize - supportline/2, 0);
  fill(103, 97, 87);
  box(1, supportline, 1);

  translate(0, -supportline/2, 0);
  fill(79, 245, 251);
  sphere(2);

  rotateY(- TWO_PI / 7);
  fill(103, 97, 87);
  translate(0, 0, supportline/2);
  box(1, 1, supportline);


  translate(0, 0, supportline/2);
  fill(79, 245, 251);
  box(4, 2, 10);
  lampMatrix = getMatrix();
  popMatrix();
}

void lampOn(boolean lampStatus_) {
  if (lampStatus_ == true) {
    pushMatrix();
    setMatrix(lampMatrix);
    translate(0, 3, 0);
    pointLight(225, 225, 225, 0, -1, 0);
    popMatrix();
  } else {
  }
}

void keyPressed() {
  if (keyCode == UP)
    lampStatus = true;
  if (keyCode == DOWN)
    lampStatus = false;
  else {
  }
}

//void mouseDragged() {

//  camera(width/2.0, mouseY, (height/2.0) / tan(PI*30.0 / 180.0), 
//    width/2.0, height/2.0, 0, 
//    0, 1, 0);
//  desk.disp(width/2, height/2, -40); // arguements are position of desk
//}



void drawDesk() {
  // (for method 1 display)
  pushMatrix();
  float a = mouseY;
  if (mousePressed == true) {
    rotateX(map(a, 0, height, -PI, PI));
    desk.disp(width/2, height/2, -40); // negative z value is 1/2 zSize 
    // to center on x axiz
    println(a);
  } else 
  desk.disp(width/2, height/2, -40); // arguements are position of desk
  popMatrix();
}
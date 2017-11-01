Desk desk;
PImage img;

void setup() {
  size(400, 400, P3D);
  frameRate(10);

  img = loadImage("wood-911002_1920.jpg");
  desk = new Desk(200, 20, 80, img);
}
void draw() {
  background(105);

  // guides
  stroke(200, 225, 245, 200);
  strokeWeight(2);
  line(-40, height/2, -40, width+40, height/2, -40);
  line(width/2, -40, -40, width/2, height+40, -40);

  directionalLight(200, 200, 200, -1, 1, -1);
  ambientLight(100, 100, 100);

  pushMatrix();
  float a = mouseY;
  if (mousePressed == true) {
    rotateX(map(a, 0, height, -PI, PI));
    //translate(0,(map(a,0,height, height/-2,height/2)), 0);
    desk.disp(width/2, height/2, -40); // negative z value is 1/2 zSize to center on x axiz
    println(a);
  } else /*if (mousePressed == false)*/ {
    //noLoop();
    // rotateX(radians(a));
    // ! Trying to get desk to stay in the position that mouse is released. 
    //! Try mouseReleased()?
    desk.disp(width/2, height/2, -40);
  }
  popMatrix();
}



class Desk {
  PShape top, leg1, leg2, leg3, leg4;

  float xSize;
  float ySize;
  float zSize;

  Desk(float x_, float y_, float z_, PImage img) {
    xSize = x_;
    ySize = y_;
    zSize = z_;
  }

  void disp(float xPos, float yPos, float zPos) {

    float legX = xSize*0.06;
    float legY = ySize*6;
    float legZ = xSize*0.06;

    noStroke();
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

    translate(xPos, yPos, zPos);
    shape(top); // draw desk top

    translate(-((xSize/2)-(legX/2)-edge), (legY/2), ((zSize/2)-(legZ/2)-edge));
    shape(leg1); // draw front left leg

    translate(0, 0, (-(zSize-legZ-edge)));
    shape(leg2); // draw back left leg


    translate((xSize-legX-(2*edge)), 0, 0);
    shape(leg3); // draw back right leg

    translate(0, 0, (zSize-legZ-(edge)));
    shape(leg4); // draw front right leg
    popMatrix();
  }
}
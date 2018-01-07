
import peasy.*;

// Camera
PeasyCam cam;
PVector v1, v2, v12, alpha;
PVector cosalpha;

void setup() {
  size(700, 500, P3D);
  smooth();
  cam = new PeasyCam(this, 0, 0, 0, 350);
  randomSeed(5);
  v1 = new PVector(random(-100, 100), random(-100, 100), random(-100, 100));
  v2 = new PVector(random(-100, 100), random(-100, 100), random(-100, 100));
}
void draw() {
  background(120, 160, 200);
  strokeWeight(2);
  stroke(225);
  fill(225);

  drawAxes();

  println("v1: ", v1);
  println("v2: ", v2);

  pushMatrix();
  translate(v1.x, v1.y, v1.z);
  text("v1", 0, 0, 0);
  sphere(1);
  popMatrix();
  pushMatrix();
  translate(v2.x, v2.y, v2.z);
  text("v2", 0, 0, 0);
  sphere(1);
  popMatrix();

  float dist = v2.dist(v1); // dist !!! same as norm and mag
  println("dist: ", dist);
  stroke(255, 0, 0); // red
  line(v2.x, v2.y, v2.z, v2.x, v2.y+dist, v2.z);
  
    v12 = PVector.sub(v1,v2); // sub
  println("v12: ", v12);
  stroke(0, 0, 255); // blue
  line(v1.x, v1.y, v1.z, v12.x, v12.y, v12.z);
  
    // norm calc !! SAME AS MAG
  float norm = sqrt(v12.dot(v12));
  println("norm: ", norm);
  stroke(255, 255, 0); // yellow
  line(v2.x, v2.y, v2.z, v2.x, v2.y+norm, v2.z);
  
    float mag = v12.mag(); // mag
  println("mag: ", mag);
  stroke(0, 255, 0); // green
  line(v1.x, v1.y, v1.z, v1.x, v1.y+mag, v1.z);
  
  
    pushMatrix();
  translate(v1.x, v1.y, v1.z);
  // rotate around the x and z axis (y is the "height" or hypotenuse)
  // rotation around z
  alpha = v12.normalize();
  // rotation is in the wrong direction, try rotation around X now
  float rX = cos(v12.z/dist);
  float rY = atan2(alpha.x, alpha.z);
  float rZ = cos(-v12.x/dist);
  println("rX: ", rX);
  println("rY: ", rY);
  println("rZ: ", rZ);

  rotateZ(rZ);
  stroke(255, 0, 255, 50); // purple ligth
  line(0, 0, 0, 0, dist, 0);
  rotateX(rX);
  stroke(255, 0, 255, 150); // purple
  line(0, dist, 0, 0, 0, 0);
  rotateY(rY);
  stroke(255, 0, 255, 200); // purple
  line(0, dist, 0, 0, 0, 0);
  popMatrix();
}

void drawAxes() {
  pushStyle();
  stroke(255, 0, 0);
  line(-300, 0, 0, 300, 0, 0);
  text("+x", 300, 0, 0);
  text("-x", -330, 0, 0);
  stroke(0, 255, 0);
  line(0, -300, 0, 0, 300, 0);
  text("+y", 0, 330, 0);
  text("-y", 0, -300, 0);
  stroke(0, 0, 255);
  line(0, 0, -300, 0, 0, 300);
  text("+z", 0, 0, 330);
  text("-z", 0, 0, -300);
  popStyle();
}
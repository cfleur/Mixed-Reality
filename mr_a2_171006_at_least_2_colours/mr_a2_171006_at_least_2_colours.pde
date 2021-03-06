import processing.opengl.*;
float xstart, xnoise, ystart, ynoise;
void setup() {
  size(600, 600, OPENGL);
  sphereDetail(8); //Controls the detail used to render a sphere by adjusting the number of vertices of the sphere mesh.
  noStroke();
  xstart = random(10); 
  ystart = random(10);
}

void draw () {

  drawTetraeder(200);
  drawWater();
  drawGrass();
}

void drawWater() {

  pushMatrix();
  rotateX(radians(10));
  xstart += 0.01; 
  ystart += 0.01;
  xnoise = xstart; 
  ynoise = ystart;
  for (int y=0; y<=height; y+=5) {
    ynoise += 0.1; 
    xnoise = xstart;
    for (int x=0; x<=width; x+=5) {
      xnoise += 0.1; 
      // drawGrassPoint(x, y, noise(xnoise, ynoise));
      drawPoint(x, y, noise(xnoise, ynoise));
    }
  }
  popMatrix();
}
void drawGrass() {

  xstart += 0.01; 
  ystart += 0.01;
  xnoise = xstart; 
  ynoise = ystart;
  for (int y=0; y<=height; y+=5) {
    ynoise += 0.1; 
    xnoise = xstart;
    for (int x=-(2* width); x<=(2* width); x+=5) {
      //for (int x=0; x<=width; x+=5) {

      xnoise += 0.1; 
      drawGrassPoint(x, y, noise(xnoise, ynoise));
      //       drawPoint(x, y, noise(xnoise, ynoise));
    }
  }
}

//for 3d point, not working
/*void drawGrassPoint(float x, float y, float z, float noiseFactor) { 
 pushMatrix();
 translate(x, height - y, z);
 float sphereSize = 0;
 float green = 150 + (noiseFactor * 120);
 float blue = 150 + (noiseFactor * 0.5);
 float alph = 150 + (noiseFactor * 120);
 fill(0, green, blue, alph);
 sphere(sphereSize);
 //box(sphereSize);
 popMatrix();
 }*/

void drawGrassPoint(float x, float y, float noiseFactor) { 
  pushMatrix();
  translate(x, height - y - 3, 10-y);
  float sphereSize = noiseFactor * 120;
  float green = 150 + (noiseFactor * 120);
  float blue = 150 + (noiseFactor * 0.5);
  float alph = 150 + (noiseFactor * 120);
  fill(0, green, blue, alph);
  //sphere(sphereSize);
  box(sphereSize);
  popMatrix();
}

void drawPoint(float x, float y, float noiseFactor) { 
  pushMatrix();

  translate(x, height-y+5, 40-y);
  float sphereSize = noiseFactor * 13;

  //blue ocean
  float blue = 150 + (noiseFactor * 120);
  float alph = 150 + (noiseFactor * 120);
  fill(0, 0, blue, alph);
  sphere(sphereSize);

  //green grass
  /*float light = 95 + (noiseFactor * 120);
   float alph2 = 150 + (noiseFactor * 120);
   colorMode(HSB);
   fill(85, 163, light, alph2);
   sphere(sphereSize*4);*/

  popMatrix();
}



void drawTetraeder(int edge) {

  pushMatrix();
  translate(width/2, height/2, 0);
  //rotateY(frameCount * 0.001); //dynamische Rotation
  rotateX(radians(45.00));
  rotateY(radians(180));
  rotateZ(radians(45.00));

  fill(100);
  beginShape(TRIANGLE_STRIP);
  vertex(0, 0, edge);
  //vertex(edge/2, edge/2, edge);
  vertex(edge, edge, edge);
  //vertex(edge/2, 0, edge/2);
  //vertex(edge, edge/2, edge/2);
  vertex(edge, 0, 0);
  endShape();

  //drawGrassPoint(300, 300, 300, noise(xnoise, ynoise));


  fill(90);
  beginShape(TRIANGLE_STRIP);
  vertex(edge, 0, 0);
  vertex(0, edge, 0);
  vertex(edge, edge, edge);
  endShape();

  fill(110);
  beginShape(TRIANGLE_STRIP);
  vertex(0, 0, edge);
  vertex(0, edge, 0);
  vertex(edge, edge, edge);
  endShape();

  fill(105);
  beginShape(TRIANGLE_STRIP);
  vertex(edge, 0, 0);
  vertex(0, 0, edge);
  vertex(0, edge, 0);
  endShape();


  popMatrix();
}
import processing.opengl.*;
float xstart, xnoise, ystart, ynoise;
int cols, rows;
int scale = 10;
int w = 5000;
int h = 4000;
int waterHeight = 80;
int vegetationLine = 150;


float[][] raster;

void setup() {
  size(1200, 1200, P3D);

  cols = w/scale;
  rows = h/scale;
  raster = new float[cols][rows];

  xstart = random(10); 
  ystart = random(10);

  float offsetY = 0;
  for (int y = 0; y < rows; y++) {
    float offsetX = 0;
    for (int x = 0; x < cols; x++) {
      raster[x][y] = map(noise(offsetX, offsetY), 0, 1, -80, 300);
      offsetX += 0.05;
    }
    offsetY += 0.05;
  }
  drawLandscape();
}

void draw() {
  //drawLandscape();
}

void drawLandscape() {
  background(0);
  stroke(209, 209, 209);
  //fill(0);
  fill(193, 217, 255,100);


  xstart += 0.01; 
  ystart += 0.01;
  xnoise = xstart; 
  ynoise = ystart;


  translate(width/2, height/2);
  rotateX(PI/3);
  translate(-w/2, -h/2);
  //PImage img = loadImage("ice-texture.jpg");
  for (int y = 0; y < rows - 1; y ++) {

    beginShape(TRIANGLE_STRIP);
    // texture(img);
    for (int x=0; x< cols; x++) {

      //vertex(x*scale, y*scale, map(noise(offsetX, offsetY), 0, 1, -50, 50));
      //vertex(x*scale, (y+1)*scale, map(noise(offsetX, offsetY), 0, 1, -50, 50));
      vertex(x*scale, y*scale, raster[x][y], 0, 0);
      vertex(x*scale, (y+1)*scale, raster[x][y+1], 100, 100);
    }
    endShape();
  }
  for (int y = 0; y < rows - 1; y ++) {
    ynoise += 0.1; 
    xnoise = xstart;
    for (int x=0; x< cols; x++) {
      xnoise += 0.1; 
      pushMatrix();
      drawWaterOrVeg(x, y, noise(xnoise, ynoise));
      popMatrix();
    }
  }
}

void drawWaterOrVeg(int x, int y, float noiseFactor) {

  float currentHeight = raster[x][y];
  if (currentHeight <= waterHeight) {
    drawWaterPoint(x*scale, y*scale, currentHeight, noiseFactor);
  } else if (currentHeight > waterHeight && currentHeight <= vegetationLine) {
    drawGrassPoint(x*scale, y*scale, currentHeight, noiseFactor);
  }
}

void drawGrassPoint(int x, int y, float z, float noiseFactor) { 
  pushMatrix();
  strokeWeight(0);

  translate(x, y, z);
  float boxSize = noiseFactor * 35;
  float green = 150 + (noiseFactor * 120);
  float blue = 150 + (noiseFactor * 0.5);
  float alph = 150 + (noiseFactor * 120);
  /*  float sphereSize = noiseFactor * 35;
   float blue = 150 + (noiseFactor * 120);
   float alph = 150 + (noiseFactor * 120);
   */
  fill(0, green, blue, alph);
  box(boxSize);
  popMatrix();
}

void drawWaterPoint(int x, int y, float z, float noiseFactor) { 
  pushMatrix();

  strokeWeight(0);

  translate(x, y, z);
  /*float boxSize = noiseFactor * 15;
   float green = 150 + (noiseFactor * 120);
   float blue = 150 + (noiseFactor * 0.5);
   float alph = 150 + (noiseFactor * 120);*/
  float sphereSize = noiseFactor * 45;
  float blue = 150 + (noiseFactor * 120);
  float alph = 150 + (noiseFactor * 120);
  fill(0, 0, blue, alph);
  sphere(sphereSize);
  popMatrix();
}
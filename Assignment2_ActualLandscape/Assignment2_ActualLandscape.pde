import processing.opengl.*;
float xstart, xnoise, ystart, ynoise;
int cols, rows;
int scale = 20;
int w = 2000;
int h = 1600;

float[][] raster;

void setup() {
  size(600, 600, P3D);

  cols = w/scale;
  rows = h/scale;
  raster = new float[cols][rows];
  
  //water
  xstart = random(10); 
  ystart = random(10);
  
  float offsetY = 0;
  for (int y = 0; y < rows; y++) {
    float offsetX = 0;
    for (int x = 0; x < cols; x++) {
      raster[x][y] = map(noise(offsetX, offsetY), 0, 1, -80, 300);
      offsetX += 0.2;
    }
    offsetY += 0.2;
  }
  drawLandscape();
}

void draw() {
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      if(raster[x][y] < -10) {
        drawWater();
      }
    }
  }
}

void drawLandscape() {
  background(0);
  stroke(193, 217, 255);
  noFill();

  translate(width/2, height/2);
  rotateX(PI/3);
  translate(-w/2, -h/2);
  PImage img = loadImage("ice-texture.jpg");
  for (int y = 0; y < rows - 1; y ++) {
    beginShape(TRIANGLE_STRIP);
    texture(img);
    for (int x=0; x< cols; x++) {
      //vertex(x*scale, y*scale, map(noise(offsetX, offsetY), 0, 1, -50, 50));
      //vertex(x*scale, (y+1)*scale, map(noise(offsetX, offsetY), 0, 1, -50, 50));
      vertex(x*scale, y*scale, raster[x][y], 0, 0);
      vertex(x*scale, (y+1)*scale, raster[x][y+1], 100, 100);
    }
    endShape();
  }
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
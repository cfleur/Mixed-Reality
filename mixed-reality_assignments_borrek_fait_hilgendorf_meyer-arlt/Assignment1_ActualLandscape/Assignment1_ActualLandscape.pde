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
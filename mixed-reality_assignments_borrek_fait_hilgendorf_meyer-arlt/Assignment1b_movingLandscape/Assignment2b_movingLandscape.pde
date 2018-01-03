/* Processing surface assignment: 
 
 "Perlin Mountains and Ice Lakes"
 
 Simulates the fly-over of a mountainous terrain with valleys of ice.
 Mountains are drawn based on the Perlin noise function.
 A sense of "fog" and increasing "visibility" as the mountains move 
 toward the viewer are created via a gradation of alpha values. 
 Terrain mesh made with the PShape calss. 
 
 Interactivity: 1) click to get RGB value at (x,y) point; 
 2) click-drag to move camera (needs imporvement).
 
*/


// ----- Global declarations -----

PShape Mesh; // shape group (terrain)
PShape[] mesh; // array of shape children (terrain)
PShape quad; // shape (ice)
PShape QuadAlpha; // shape group (ice shading)
PShape[] quadAlpha;  // array of shape children (ice shading)
PImage img; // ice texture

float scale = 15;
float h = 1600; 
float w = 1600; // ! arrays work only with square dimensions
float rows = round(h/scale);
float cols = round(w/scale);

float [][] zValues;
float yMove = 0;
float variation = 200; // height/depth of mountains (z value)
float diff = 0.09; // size of step change in y values


void setup () {
  size(700, 575, P3D);
  img = loadImage("Ice_road_in_the_Northwest_Territories_-a.jpg");
  frameRate(25);
}


void draw() {
  background(69); // value should match with line 100 fill color for "fog"
  calculateNoise();
  createMesh();
  createIce();

  pushMatrix();
  translate(width/2, height*.75, 0);
  rotateX(radians(45));
  shapeMode(CENTER);
  shape(Mesh);
  pushMatrix();
  translate(0, 0, -variation*.35);
  shape(quad);
  shape(QuadAlpha);
  popMatrix();
  popMatrix();
}

// ----- Functions -----

void calculateNoise() {
  /* Creates a 2D array of gradually changing Perlin noise values.
   These values are then applied as the z coordinate of the Mesh vertices. */

  yMove -= diff;
  zValues = new float[int(rows)][int(cols)]; // holds the z "noise" 
  // value for each vertex in (x,y) plane

  float yDiff = yMove;  // slowly decrementing the y noise starting 
  // value in each draw loop creates "flying" sensation
  for (int y = 0; y < rows-1; y++) {
    float xDiff = 0;
    for (int x = 0; x < cols; x++) {
      zValues[x][y] = map(noise(xDiff, yDiff), 0, 1, -variation, variation);
      xDiff += diff;
    }
    yDiff += diff; // small increments in x and y noise values create continuity in terrain
    // try different values for different effects
  }
}


void createMesh() {
  /* Creates a grid of triangles w * h units large in one parent object, Mesh
   and sets gradiant fill values for each triangle strip (mesh[y]). */

  mesh = new PShape[int(rows)];
  Mesh = createShape(GROUP);

  for (int y = 0; y < rows-1; y++) {
    mesh[y] = createShape();
    mesh[y].beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x++) {
      mesh[y].vertex(x*scale, y*scale, zValues[x][y]);
      mesh[y].vertex(x*scale, (y+1)*scale, zValues[x][y+1]);
    }
    mesh[y].endShape();

    // color/alpha is a function of row position
    mesh[y].setFill(color(y*2, y*3, y*3, y*(y-1))); 
    mesh[y].setStrokeWeight(1);
    mesh[y].setStroke(color(y*1, y*2, y*5, y*y));

    Mesh.addChild(mesh[y]);
  }
}

void createIce() {
  /* Creates a quad w * h units large, textured by an ice image.
   Creates a an identical grid of triangels to Mesh for adding shading to ice quad. */

  // create quad
  quad = createShape(QUAD, 0, 0, 0, h, h, w, w, 0);
  quad.setStrokeWeight(0);
  quad.setTexture(img);

  // create shading grid to overlay quad
  quadAlpha = new PShape[int(rows)];
  QuadAlpha = createShape(GROUP);

  for (int y = 0; y < rows-1; y++) {
    quadAlpha[y] = createShape();
    quadAlpha[y].beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x++) {
      quadAlpha[y].vertex(x*scale, y*scale, variation*.3);
      quadAlpha[y].vertex(x*scale, (y+1)*scale, variation*.3);
    }
    quadAlpha[y].endShape();
    quadAlpha[y].setFill(color(69, 69, 69, 255-(y*(y-1)))); // color should match with background
    quadAlpha[y].setStrokeWeight(0);
    QuadAlpha.addChild(quadAlpha[y]);
  }
}


// ----- Interactivity Functions -----

void mouseDragged() {
  // camera - needs improvement, but can be used for viewing and correction
  camera(mouseX*2, mouseY*5, (mouseY*2/2) / tan(PI*30.0 / 180.0), 
    width/2.0, height/2.0, 0, 
    0, 1, 0);
}

void mouseReleased() {
  delay(200);
  resetMatrix();
  camera();
}

void mousePressed() {
  /* Prints the RGB values at clicked point (x,y) to the console. */

  color c = get(mouseX, mouseY);
  println("RBG values (on click): ", red(c), ", ", green(c), ", ", blue(c));
}
import processing.opengl.*;
int edge = 200;
void setup() {
  size(600, 600, OPENGL); 
  background(255); 
  stroke(0);
}
void draw() {
  background(255);
  translate(width/2, height/2, 0);
  rotateY(frameCount * 0.001); //dynamische Rotation
  rotateX(radians(45.00));
  rotateZ(radians(45.0));

  ellipse(0.0, 0.0, 0.0, 6.0); //markiert den Punkt (0,0,0)

  fill(0, 0, 255); //blau
  beginShape(TRIANGLE_STRIP);
  vertex(0, 0, edge);
  //vertex(edge/2, edge/2, edge);
  vertex(edge, edge, edge);
  //vertex(edge/2, 0, edge/2);
  //vertex(edge, edge/2, edge/2);
  vertex(edge, 0, 0);
  endShape();

  fill(0, 255, 0); //gruen
  beginShape(TRIANGLE_STRIP);
  vertex(edge, 0, 0);
  vertex(0, edge, 0);
  vertex(edge, edge, edge);
  endShape();

  fill(255, 0, 0); //rot
  beginShape(TRIANGLE_STRIP);
  vertex(0, 0, edge);
  vertex(0, edge, 0);
  vertex(edge, edge, edge);
  endShape();

  fill(0, 255, 255); //
  beginShape(TRIANGLE_STRIP);
  vertex(edge, 0, 0);
  vertex(0, 0, edge);
  vertex(0, edge, 0);
  endShape();
}
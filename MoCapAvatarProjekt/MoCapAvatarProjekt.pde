import peasy.*;
import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.processing.*;

// Reads, processes, and displays motion capture BVH files (.bvh)
//
// Assumes there's only one hierarchy per file.
// Assumes channels: root: 3 positions (in that order: X,Y,Z) + 3 rotations (XYZ in any order),
//                   joints: 3 rotations (XYZ in any order),
//                   end sites: none.
// ** Joint translations are not supported! **
//
// A collection of BVH's can be found at http://www.cgspeed.com/ or http://www.motioncapturedata.com
//      (any version, MotionBuilder-, Max-, or Daz-friendly, will work;
//       notice that the latter seems to have a different scale).
//
// Based on mocapBVH from stefanG (with some simplifications): http://www.openprocessing.org/sketch/78767
// Display and overall program structure taken (with slight modifications)
//       from roxstomp's mocap1: http://www.openprocessing.org/sketch/1964
// Some inspiration (joint's transformation matrix) drawn from Bruce Hahne's BVHplay:
//       https://sites.google.com/a/cgspeed.com/cgspeed/bvhplay
//
// In a nut-shell:
// - a Joint has a set of positions;
// - a Mocap is a set of joints;
// - a MocapInstance draws a Mocap, and specifies how.
//
// Computing of positions:
// Except for the root, joints' positions are not directly given in a BVH file.
// Instead, a transformation specified by a joint's CHANNELS are applied to all 
// its descendants. This can be a composition of translation and rotation, though
// in this program only rotations are supported.
// The transfomations are applied to the joints' offsets, so as to produce the
// desired pose at each frame.
// Example: a linear hierarchy with four joints: j1 (root), j2, j3, j4 (end site);
//          each has an offset (zero-pose): 3-vectors off1, off2, off3, off4;
//          the root has a position channel: 3-vector posR;
//          all except the end site have rotation channels: for each joint, 3 angles
//                define a rotation R (which can be represented as a 3x3 matrix);
//          the joints' positions are then:
//                pos1 = off1 + posR;
//                pos2 = R1.off2 + pos1
//                pos3 = R1.R2.off2 + pos2
//                pos4 = R1.R2.R3.off2 + pos3
//          (The root position posR and the angles defining R1, R2, and R3, form the data
//                given at each frame.)


MocapInstance mocapinst;
ToxiclibsSupport render;
ParticleSystem particlesys0, particlesys1;

// ------- Camera -----
PeasyCam cam;
CameraState camReset;
boolean resetCam = false;

// ------- Terrain -----
int SCALE = 20; // Scales the grid
float GROUNDLEVEL = -2;

// Terrain ground
Mesh3D groundMesh;
Terrain ground;
float groundHeight = 200;
int groundSize = 56; // Grid size, even number

// Terrain water
Mesh3D waterMesh;
Terrain water;
float waterHeight = 50;
int waterSize = 18; // Grid size, even number
PImage water_img;

// Lamp
boolean lampOn = false;

void setup () {
  //--- Display --- 
  size(800, 600, P3D);
  frameRate(75); 
  //sphereDetail(8);
  smooth();
  drawAxes();

  //--- Camera ---
  cam = new PeasyCam(this, 0, 0, 0, 650);
  cam.rotateY(PI*3/2);
  cam.rotateX(PI/12);
  //cam.rotateZ(PI/8);
  cam.setMinimumDistance(200);
  cam.setMaximumDistance(900);
  cam.setSuppressRollRotationMode();
  camReset = cam.getState();

  // --- Graphics ---
  render = new ToxiclibsSupport(this);

  //--- Mootion captures ---
  Mocap mocap1 = new Mocap("Avatar-006#My MVN System.bvh");// found at http://www.motioncapturedata.com
  //--- To draw mocaps, specify:
  //which mocap; the time offset (starting frame); the space offset (translation); the scale; the color; the stroke weight. 
  mocapinst = new MocapInstance(mocap1, 0, new float[] {0., -20, -100.}, 0.9, color(0), 3);

  // --- Terrain ---
  water = new Terrain(waterSize, waterSize, SCALE);
  ground = new Terrain(groundSize, groundSize, SCALE);
  water_img = loadImage("img/water-1018808_640.jpg");

  // --- Particles ---
  particlesys0 = new ParticleSystem();
  particlesys1 = new ParticleSystem();
}

void draw() {
  println(resetCam);
  if (resetCam) {
    cam.setState(camReset, 1000);
    resetCam = false;
  }

  background(120, 160, 200);
  lights();

  rotateX(PI);
  drawAxes();

  rotateY(PI/6);

  drawEarth();

  drawLamp(200, -20, -200, lampOn);
  drawLamp(-370, -70, -100, lampOn);
  drawLamp(110, 12, -400, lampOn);
  drawLamp(-160, -15, 160, lampOn);

  //antig is now inside the particle
  PVector antig = new PVector(random(-0.02, 0.02), 0.01, random(-0.02, 0.02));
  // JUST TEMP FOR TESTING THE PARTICLE BEHAVIOR
  particlesys0.addForce(antig); // spheres
  particlesys1.addForce(antig); // cubes 

  if (keyPressed) {
    emissive(0, 0, 255);
    particlesys0.addParticleCube(random(2, 5));
    PVector wind = new PVector(random(-0.2, 0.17), random(0.02), random(-0.2, 0.17));
    particlesys0.addForce(wind); // spheres
    particlesys1.addForce(wind); // cubes
  } 

  mocapinst.drawMocap();

  drawRocks(120, -10, 120);
  pushMatrix();
  scale(1.2);
  rotateX(PI);
  rotateX(PI/15);
  drawRocks(-160, 30, -55);
  popMatrix();

  pushMatrix();
  rotateX(PI); 
  rotateY(PI);
  drawGround(ground, render, groundSize, groundHeight, 0.08);
  drawWater(water, render, waterSize, waterHeight, 0.2);
  popMatrix();

  particlesys0.addParticle(random(2, 5));
  particlesys0.startSys();
  particlesys1.addParticle(random(2, 5));
  particlesys1.startSys(); 

  cam.beginHUD();
  displayUI();
  cam.endHUD();

  /*
  pushMatrix();
   translate(width/5-80, height/5-80);
   //rotateX(-PI/6);
   rotateY(-radians(frameCount)/2);
   noFill();
   box(50);
   popMatrix();
   
   pushMatrix();
   translate((width/5)*2-100, height/5-100);
   //rotateX(-PI/6);
   rotateY(radians(frameCount+45));
   box(50, 40, 100);
   popMatrix();*/
}




//-------------------------------------
// Classes ----------------------------
//-------------------------------------

class MocapInstance {   
  Mocap mocap;
  int currentFrame, firstFrame, lastFrame;
  float[] translation;
  float scl, strkWgt;
  color clr;

  MocapInstance (Mocap mocap1, int startingFrame, float[] transl, float scl1, color clr1, float strkWgt1) {
    mocap = mocap1;
    currentFrame = startingFrame;
    firstFrame = startingFrame;
    lastFrame = startingFrame-1;   
    translation = transl;
    scl = scl1;
    clr = clr1;
    strkWgt = strkWgt1;
  }

  void drawMocap() {
    pushMatrix();
    pushStyle();
    stroke(clr);
    strokeWeight(strkWgt);
    translate(translation[0], translation[1], translation[2]);
    scale(scl);
    int countEnds = 0;

    for (Joint itJ : mocap.joints) {
      println(itJ.name + "!");


      if (itJ.name.toString().equals("EndSitenull")) {
        countEnds++;
        println(countEnds);
      }


      /* 
       
       // IF WE FIX THE BUG (STRG+F for "#bug"), WE FIND THE ENSITE WITH THIS SYNTAX
       
       if (itJ.name.toString().equals("EndSiteHead")) {
       println("Torso");
       fill(255, 0, 0);
       } else if (itJ.name.toString().equals("EndSiteRightWrist")) {
       println("Right arm + head");
       fill(0, 255, 0);
       } else if (itJ.name.toString().equals("EndSiteLeftWrist")) {
       println("Left arm + right hand");
       fill(255, 255, 255);
       } else if (itJ.name.toString().equals("EndSiteRightToe")) {
       println("Right leg");
       fill(0, 255, 255);
       } else if (itJ.name.toString().equals("EndSiteLeftToe")) {
       println("Left leg");
       fill(0, 255, 255);
       }
       
       */


      //if (!(itJ.name.toString().equals("RightToe")||itJ.name.toString().equals("LeftToe") ||itJ.name.toString().equals("EndSitenull"))) {
      // draw bodyparts
      if (countEnds == 0) {
        println("Torso");
        fill(255, 0, 0);
      } else if (countEnds == 1) {
        println("Right arm + head");
        fill(0, 255, 0);
      } else if (countEnds == 2) {
        println("Left arm + right hand");
        fill(255, 255, 255);
      } else if (countEnds == 3) {
        println("Right leg");
        fill(0, 255, 255);
      } else if (countEnds == 4) {
        println("Left leg");
        fill(0, 255, 255);
      } else
        fill(0);


      // Add force away from body to particles
      //PVector point = new PVector(midX/2, midY/2, midZ/2);
      PVector point = new PVector(itJ.parent.position.get(currentFrame).x + translation[0], itJ.parent.position.get(currentFrame).y + translation[1], itJ.parent.position.get(currentFrame).z + translation[2]);
      //PVector point = new PVector(150,0,150);
      particlesys0.fleefrombody(point);
      particlesys1.fleefrombody(point);

      pushMatrix();
      translate(itJ.position.get(currentFrame).x, itJ.position.get(currentFrame).y, itJ.position.get(currentFrame).z);
      popMatrix();

      // Draw body
      pushMatrix();
      translate(itJ.position.get(currentFrame).x, itJ.position.get(currentFrame).y, itJ.position.get(currentFrame).z);
      float midX = -(itJ.position.get(currentFrame).x - itJ.parent.position.get(currentFrame).x) ;
      float midY = -(itJ.position.get(currentFrame).y - itJ.parent.position.get(currentFrame).y) ;
      float midZ = -(itJ.position.get(currentFrame).z - itJ.parent.position.get(currentFrame).z) ;

      translate(midX/2, midY/2, midZ/2);

      //float a = atan(midY/midX);
      //rotateZ(radians(a));
      //float b = atan(midZ/midY);
      //rotateX(radians(b));
      //float c = atan(midX/midZ);
      //rotateY(radians(c));
      //      println(a,b,c);

      float a = atan2(midY, midX);
      rotateZ(a);
      float b = atan2(midZ, midY);
      rotateX(radians(b));
      float c = atan2(midX, midZ);
      rotateY(radians(c));
      //println(a,b,c);

      strokeWeight(3);
      //noFill();
      //fill(#0000EE);
      box(/*Y*/(midX/cos(a))-4, 10, 10);
      popMatrix();

      // draw joints
      if (!(itJ.name.toString().equals("EndSitenull"))) {//||itJ.name.toString().equals("RightToe")||itJ.name.toString().equals("LeftToe"))) {
        pushMatrix();
        translate(itJ.position.get(currentFrame).x, itJ.position.get(currentFrame).y, itJ.position.get(currentFrame).z);
        strokeWeight(0);
        fill(0);
        sphere(5*sqrt(2)-2);
        //box(7,7,7);
        popMatrix();
      }

      line(itJ.position.get(currentFrame).x, 
        itJ.position.get(currentFrame).y, 
        itJ.position.get(currentFrame).z, 
        itJ.parent.position.get(currentFrame).x, 
        itJ.parent.position.get(currentFrame).y, 
        itJ.parent.position.get(currentFrame).z);
      //}
    }

    popStyle();
    popMatrix();
    currentFrame = (currentFrame+1) % (mocap.frameNumber);
    if (currentFrame==lastFrame+1) currentFrame = firstFrame;
  }
}

class Mocap {
  float frmRate;
  int frameNumber;
  ArrayList<Joint> joints = new ArrayList<Joint>();

  Mocap (String fileName) {
    String[] lines = loadStrings(fileName);
    float frameTime;
    int readMotion = 0;
    int lineMotion = 0;
    Joint currentParent = new Joint();

    for (int i=0; i<lines.length; i++) {

      //--- Read hierarchy --- 
      String[] words = splitTokens(lines[i], " \t");

      //list joints, with parent
      if (words[0].equals("ROOT")||words[0].equals("JOINT")||words[0].equals("End")) {
        Joint joint = new Joint(); 
        joints.add(joint); // #bug THIS LINE IS BAD. We should move it to the bottom of this if-clause, then the EndSiteXXX will work :) 
        if (words[0].equals("End")) {
          joint.name = "EndSite"+((Joint)joints.get(joints.size()-1)).name;
          joint.isEndSite = 1;
        } else joint.name = words[1];
        if (words[0].equals("ROOT")) {
          joint.isRoot = 1;
          currentParent = joint;
        }
        joint.parent = currentParent;
      }

      //find parent
      if (words[0].equals("{")) {
        currentParent = (Joint)joints.get(joints.size()-1);
      }
      if (words[0].equals("}")) {
        currentParent = currentParent.parent;
      }

      //offset
      if (words[0].equals("OFFSET")) {
        joints.get(joints.size()-1).offset.x = float(words[1]);
        joints.get(joints.size()-1).offset.y = float(words[2]);
        joints.get(joints.size()-1).offset.z = float(words[3]);
      }

      //order of rotations
      if (words[0].equals("CHANNELS")) {
        joints.get(joints.size()-1).rotationChannels[0] = words[words.length-3];
        joints.get(joints.size()-1).rotationChannels[1] = words[words.length-2];
        joints.get(joints.size()-1).rotationChannels[2] = words[words.length-1];
      }

      if (words[0].equals("MOTION")) {
        readMotion = 1;
        lineMotion = i;
      }

      if (words[0].equals("Frames:"))
        frameNumber = int(words[1]);

      if (words[0].equals("Frame") && words[1].equals("Time:")) {
        frameTime = float(words[2]);
        frmRate = round(1000./frameTime)/1000.;
      }

      //--- Read motion, compute positions ---   
      if (readMotion==1 && i>lineMotion+2) {

        //motion data
        PVector RotRelativPos = new PVector();
        int iMotionData = 3;// number of data points read, skip root position      
        for (Joint itJ : joints) {
          if (itJ.isEndSite==0) {// skip end sites
            float[][] currentTransMat = {{1., 0., 0.}, {0., 1., 0.}, {0., 0., 1.}};
            //The transformation matrix is the (right-)product
            //of transformations specified by CHANNELS
            for (int iC=0; iC<itJ.rotationChannels.length; iC++) {
              currentTransMat = multMat(currentTransMat, 
                makeTransMat(float(words[iMotionData]), 
                itJ.rotationChannels[iC]));
              iMotionData++;
            }
            if (itJ.isRoot==1) {//root has no parent:
              //transformation matrix is read directly
              itJ.transMat = currentTransMat;
            } else {//other joints:
              //transformation matrix is obtained by right-applying
              //the current transformation to the transMat of parent
              itJ.transMat = multMat(itJ.parent.transMat, currentTransMat);
            }
          }

          //positions
          if (itJ.isRoot==1) {//root: position read directly + offset
            RotRelativPos.set(float(words[0]), float(words[1]), float(words[2]));
            RotRelativPos.add(itJ.offset);
          } else {//other joints:
            //apply trasnformation matrix from parent on offset
            RotRelativPos = applyMatPVect(itJ.parent.transMat, itJ.offset);
            //add transformed offset to parent position
            RotRelativPos.add(itJ.parent.position.get(itJ.parent.position.size()-1));
          }
          //store position
          itJ.position.add(RotRelativPos);
        }
      }
    }
  }
}

class Joint {
  String name;
  int isRoot = 0;
  int isEndSite = 0;
  Joint parent;
  PVector offset = new PVector();
  //transformation types (CHANNELS):
  String[] rotationChannels = new String[3];
  //current transformation matrix applied to this joint's children:
  float[][] transMat = {{1., 0., 0.}, {0., 1., 0.}, {0., 0., 1.}};
  //list of PVector, xyz position at each frame:
  ArrayList<PVector> position = new ArrayList<PVector>();
}


//-------------------------------------
// Functions --------------------------
//-------------------------------------

// --- Debugging ---
void drawAxes() {
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
}

// --- Display non-moving parts (UI) ---
void displayUI() {
  PShape timeBox, resetBox, UIinfo;

  // Calculate time from start of program
  int sec = millis()/1000;
  int min = millis()/60000;
  if (sec >= 60)
    sec -= 60*min;

  // Draw time box and text
  pushStyle();
  textSize(20);
  strokeWeight(1);
  stroke(255);
  fill(15, 150);
  timeBox = createShape();
  timeBox.beginShape();
  timeBox.vertex(width-10, height-10, 0);
  timeBox.vertex(width-10, height-50, 0);
  timeBox.vertex(width-140, height-50, 0);
  timeBox.vertex(width-140, height-10, 0);
  timeBox.endShape(CLOSE);
  shape(timeBox);

  if (mouseX >= width-300 && mouseX <= width-150 && mouseY >= height-50 && mouseY <= height-10) {
    fill(50);
  }

  resetBox = createShape();
  resetBox.beginShape();
  resetBox.vertex(width-150, height-10, 0);
  resetBox.vertex(width-150, height-50, 0);
  resetBox.vertex(width-300, height-50, 0);
  resetBox.vertex(width-300, height-10, 0);
  resetBox.endShape(CLOSE);
  shape(resetBox);

  UIinfo = createShape();
  UIinfo.beginShape();
  UIinfo.noStroke();
  UIinfo.vertex(width-310, height-10, 0);
  UIinfo.vertex(width-310, height-100, 0);
  UIinfo.vertex(width-790, height-100, 0);
  UIinfo.vertex(width-790, height-10, 0);
  UIinfo.endShape(CLOSE);
  shape(UIinfo);

  fill(0, 200, 0);
  if (sec < 10)
    text("Time "+min+":0"+sec, width-130, height-25);
  else
    text("Time "+min+":"+sec, width-130, height-25);

  fill(225);
  text("Reset camera", width-290, height-25);
  textSize(16);
  fill(0, 255, 0);
  text("Interactivity", width-780, height-75);
  fill(225);
  text("UP key= lights on, DOWN key= lights off, any key= wind\nclick-drag-scroll= camera", width-780, height-50);

  popStyle();
}
void mouseClicked() {
  if (mouseX >= width-300 && mouseX <= width-150 && mouseY >= height-50 && mouseY <= height-10)
    resetCam = true;
}

// --- Earth ---
void drawEarth() {
  PShape earth;
  PImage earth_img;
  earth = createShape(SPHERE, 300);
  earth_img = loadImage("img/earth.jpg");
  earth.setStrokeWeight(0);
  earth.setTexture(earth_img);

  pushMatrix();
  pushStyle();
  sphereDetail(20);
  translate(700, 500, 1000);
  rotateY(map(mouseY, 0, height, 0, TWO_PI));
  rotateX(map(mouseX, 0, width, 0, TWO_PI));
  shape(earth);
  popStyle();
  popMatrix();
}

// ----- Lamp -----
void drawLamp(int x, int y, int z, boolean on) {
  // x, y z define the base location of the lamp
  pushMatrix();
  pushStyle();
  strokeWeight(0);
  fill(25, 20, 20);
  translate(x, y, z);
  cylinder(12, 6, 25, 15);
  translate(0, 28, 0);
  sphere(6);
  cylinder(4, 4, 130, 15);
  translate(0, 130, 0);
  pushStyle();
  fill(190);
  if (on)
    emissive(255);
  sphere(10);
  translate(0, 6, 0);
  popStyle();
  cylinder(18, 4, 8, 15);
  if (on) {
    //noLights();
    //ambientLight(150, 150, 195);
    pointLight(225, 225, 225, 0, -1, 0);
  }
  translate(0, 6, 0);
  sphere(6);
  popStyle();
  popMatrix();
}

// ----- Lamp status -----
void keyPressed() {
  if (keyCode == UP)
    lampOn = true; 
  if (keyCode == DOWN)
    lampOn = false;
  else 
  emissive(0, 0, 255);
}

// --- Rocks ---
void drawRocks(float x, float y, float z) {
  pushStyle();
  pushMatrix();
  shininess(-0.2);
  sphereDetail(5);
  strokeWeight(0);
  translate(x, y, z);
  fill(80, 60, 30);
  sphere(70);
  translate(35, 10, 40);
  fill(70, 50, 20);
  sphere(45);
  translate(-15, 10, 40);
  sphereDetail(4);
  sphere(55);
  translate(-70, -40, 20);
  sphere(60);
  translate(-40, 30, 40);
  sphereDetail(5);
  sphere(30);
  popMatrix();
  popStyle();
}

// --- Draw water ---
void drawWater(Terrain terrain, ToxiclibsSupport gfx, int size, float height_, float diff) {
  float [][] elevation = elevationInit(height_, size, diff);
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      terrain.setHeightAtCell(i, j, elevation[i][j]);
      if (i < 1 || i > size-2) terrain.setHeightAtCell(i, j, GROUNDLEVEL);
      if (j < 1 || j > size-2) terrain.setHeightAtCell(i, j, GROUNDLEVEL);
    }
  }

  // Water texture
  PShape shape; 
  int sizeShape = size*SCALE;
  textureMode(NORMAL);
  pushStyle();
  shape = createShape(); 
  shape.setTexture(water_img);
  shape.beginShape();
  shape.noStroke();
  texture(water_img);
  shape.vertex(-sizeShape/2, 0, -sizeShape/2, 0, 0);
  shape.vertex(-sizeShape/2, 0, (sizeShape/2)-SCALE, 0, 1);
  shape.vertex((sizeShape/2)-SCALE, 0, (sizeShape/2)-SCALE, 1, 1);
  shape.vertex((sizeShape/2)-SCALE, 0, -(sizeShape/2), 1, 0);
  shape.vertex(-sizeShape/2, 0, -sizeShape/2, 0, 0);
  shape.vertex(-(sizeShape/2)+SCALE, height_*0.7, -(sizeShape/2)+SCALE, 0, 1);
  shape.vertex(-(sizeShape/2)+SCALE, height_*0.7, (sizeShape/2)-2*SCALE, 1, 1);
  shape.vertex((sizeShape/2)-2*SCALE, height_*0.7, (sizeShape/2)-2*SCALE, 1, 0);
  shape.vertex((sizeShape/2)-2*SCALE, height_*0.7, -(sizeShape/2)+SCALE, 0, 0);
  shape.vertex(-(sizeShape/2)+SCALE, height_*0.7, -(sizeShape/2)+SCALE, 0, 1);
  // ! Texture in 1st quadran not drawn correctly
  shape.endShape(CLOSE);
  shape.setStrokeWeight(4);
  shape(shape);
  popStyle();

  // Draw water
  waterMesh = terrain.toMesh(height_*0.8);
  pushStyle();
  noStroke();
  fill(0, 160, 200, 200);
  emissive(0, 0, 255);
  shininess(1.0);
  gfx.mesh(waterMesh, false);
  popStyle();
}

// --- Draw ground ---
void drawGround(Terrain terrain, ToxiclibsSupport gfx, int size, float height_, float diff) {
  float [][] elevation = elevationInit(height_, size, diff);
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      terrain.setHeightAtCell(i, j, elevation[i][j]);
      if ((i > waterSize+2 && i < groundSize-waterSize && j > waterSize && j < groundSize-waterSize-1)) 
        terrain.setHeightAtCell(i, j, GROUNDLEVEL);
      if ((i > waterSize+2 && i < groundSize-waterSize-2 && j > waterSize+1 && j < groundSize-waterSize-2)) 
        terrain.setHeightAtCell(i, j, GROUNDLEVEL+waterHeight+1);
    }
  }
  groundMesh = terrain.toMesh(height_*0.8);
  pushStyle();
  noStroke();
  fill(90, 50, 40);
  emissive(75, 15, 40);
  shininess(0.5);
  gfx.mesh(groundMesh, true);

  popStyle();
}

// --- Create elevation matrix ---
float[][] elevationInit(float maxElevation, int size, float diff) {
  float [][] yValues = new float [size][size];
  float variation = maxElevation;// height/depth of mountains (z value)
  //float diff = 0.1; // size of step change in y values
  float waves = 0;
  noiseSeed(2);

  waves += diff;
  float zDiff = waves;
  for (int z = 0; z < size; z++) {
    float xDiff = 0;
    for (int x = 0; x < size; x++) {
      yValues[z][x] = map(noise(xDiff, zDiff), 0, 1, variation, -variation);
      xDiff += diff;
    }
    zDiff += diff;
  }
  return yValues;
}

// --- Cylinder ---
void cylinder(float bottom, float top, float h, int sides) {
  pushMatrix();
  translate(0, h/2, 0);

  float angle;
  float[] x = new float[sides+1];
  float[] z = new float[sides+1];

  float[] x2 = new float[sides+1];
  float[] z2 = new float[sides+1];

  //get the x and z position on a circle for all the sides
  for (int i=0; i < x.length; i++) {
    angle = TWO_PI / (sides) * i;
    x[i] = sin(angle) * bottom;
    z[i] = cos(angle) * bottom;
  }

  for (int i=0; i < x.length; i++) {
    angle = TWO_PI / (sides) * i;
    x2[i] = sin(angle) * top;
    z2[i] = cos(angle) * top;
  }

  //draw the bottom of the cylinder
  beginShape(TRIANGLE_FAN);
  vertex(0, -h/2, 0);

  for (int i=0; i < x.length; i++) {
    vertex(x[i], -h/2, z[i]);
  }
  endShape();

  //draw the center of the cylinder
  beginShape(QUAD_STRIP); 

  for (int i=0; i < x.length; i++) {
    vertex(x[i], -h/2, z[i]);
    vertex(x2[i], h/2, z2[i]);
  }
  endShape();

  //draw the top of the cylinder
  beginShape(TRIANGLE_FAN); 
  vertex(0, h/2, 0);

  for (int i=0; i < x.length; i++) {
    vertex(x2[i], h/2, z2[i]);
  }
  endShape();
  popMatrix();
}

float[][] multMat(float[][] A, float[][] B) {//computes the matrix product AB
  int nA = A.length;
  int nB = B.length;
  int mB = B[0].length;
  float[][] AB = new float[nA][mB];
  for (int i=0; i<nA; i++) {
    for (int k=0; k<mB; k++) {
      if (A[i].length!=nB) {
        println("multMat: matrices A and B have wrong dimensions! Exit.");
        exit();
      }
      AB[i][k] = 0.;
      for (int j=0; j<nB; j++) {
        if (B[j].length!=mB) {
          println("multMat: matrices A and B have wrong dimensions! Exit.");
          exit();
        }
        AB[i][k] += A[i][j]*B[j][k];
      }
    }
  }
  return AB;
}

float[][] makeTransMat(float a, String channel) {
  //produces transformation matrix corresponding to channel, with argument a
  float[][] transMat = {{1., 0., 0.}, {0., 1., 0.}, {0., 0., 1.}};
  if (channel.equals("Xrotation")) {
    transMat[1][1] = cos(radians(a));
    transMat[1][2] = - sin(radians(a));
    transMat[2][1] = sin(radians(a));
    transMat[2][2] = cos(radians(a));
  } else if (channel.equals("Yrotation")) {
    transMat[0][0] = cos(radians(a));
    transMat[0][2] = sin(radians(a));
    transMat[2][0] = - sin(radians(a));
    transMat[2][2] = cos(radians(a));
  } else if (channel.equals("Zrotation")) {
    transMat[0][0] = cos(radians(a));
    transMat[0][1] = - sin(radians(a));
    transMat[1][0] = sin(radians(a));
    transMat[1][1] = cos(radians(a));
  } else {
    println("makeTransMat: unknown channel! Exit.");
    exit();
  }
  return transMat;
}

PVector applyMatPVect(float[][] A, PVector v) {
  //apply (square matrix) A to v (both must have dimension 3)
  for (int i=0; i<A.length; i++) {
    if (v.array().length!=3||A.length!=3||A[i].length!=3) {
      println("applyMatPVect: matrix and/or vector not of dimension 3! Exit.");
      exit();
    }
  }
  PVector Av = new PVector();
  Av.x = A[0][0]*v.x + A[0][1]*v.y + A[0][2]*v.z;
  Av.y = A[1][0]*v.x + A[1][1]*v.y + A[1][2]*v.z;
  Av.z = A[2][0]*v.x + A[2][1]*v.y + A[2][2]*v.z;
  return Av;
}
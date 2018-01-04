class Particle {
  float radius;
  float maxspeed;
  PShape shape;
  PVector loc;
  PVector vel;
  PVector acc;
  PVector instanceloc;
  PVector life;

  Particle(float radius_, PVector instanceloc_) {
    radius = radius_;
    PShape globe = createShape(SPHERE, radius_);
    shape = globe;
    instanceloc = instanceloc_;
    loc = new PVector(random(-50, 50), 0, 0);
    vel = new PVector(0, 0, 0);
    acc = new PVector(random(-0.05, 0.05), 0.0, random(-0.05, 0.05));
    life = new PVector(0, 0, 0);
    maxspeed = 5;
    loc.add(instanceloc);
  }

  void addForce(PVector force) {
    //acc = new PVector(random(-0.05, 0.05), 0.1, random(-0.05, 0.05));
    force.normalize();
    force.mult(0.2);
    //force.add(loc.mult(-0.2).normalize());
    force.x = force.x * (loc.x * 0.01);
    force.z = force.z * (loc.z * 0.01);
    acc.add(force);
  }

  void updateParticle() {
    //println("life = ", life); 
    //println("loc = ", loc);
    //println("vel = ", vel);
    //println("acc = ", acc);

    life.y=-(instanceloc.y-loc.y);
    vel.add(acc);
    loc.add(vel);
    acc.mult(0);
    //vel.limit(8);

    // set appearance according to life stage
    shape.setStrokeWeight(0);
    sphereDetail(20);
    if (life.y >= 100.0 && life.y < 200.0) { // ! need reference to global coordinate system
      //println("life 1 over");
      shape.setFill(color(200, 100, 100));
    } else if (life.y >= 200.0) {
      //println("life 2 over");
      shape.setFill(color(100, 200, 100));
    } else shape.setFill(color(100, 100, 200));
  }

  void drawParticle() {
    pushMatrix();
    translate(loc.x, loc.y, loc.z);
    shape(shape);
    popMatrix();
  }

  boolean livesOver() {
    if (life.y >= 300.0) {
      //println("livesOver");
      return true;
    } else return false;
  }
}
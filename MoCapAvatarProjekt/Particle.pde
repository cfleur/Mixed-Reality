class Particle {
   float radius;
   float maxspeed;
   float maxlife;
   float firstcolor;
   float secondcolor;
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
     
     maxlife = random(100, 600);
     firstcolor = random(50,100);
     secondcolor = random(100,maxlife);
     maxspeed = 5;
     loc.add(instanceloc);
   }
 
    void addForce(PVector force) {
      //acc = new PVector(random(-0.05, 0.05), 0.1, random(-0.05, 0.05));<
      acc.add(force);
    }
    
    void fleefrombody(PVector body){
      PVector temp = new PVector(loc.x,loc.y,loc.z).sub(body);
      temp.normalize();
      temp.y = 0;
      /*
      if(temp.x >= 0){
        loc.x += (1 - temp.x + random(-0.1,0.1));
      }else{
        loc.x -= (1 - (-temp.x) + random(-0.1,0.1));
      }

      if(temp.z >= 0){
        loc.z += (1 - temp.z + random(-0.1,0.1));
      }else{
        loc.z -= (1 - (-temp.z) + random(-0.1,0.1));
      } */
      
      //loc.z += (1 - temp.z + random(-0.1,0.1)) / 100;
     
     
     
      loc.add(temp);
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
    if (life.y >= firstcolor && life.y < secondcolor) { // ! need reference to global coordinate system
      //println("life 1 over");
      shape.setFill(color(255,204,92));
    } else if (life.y >= secondcolor) {
      //println("life 2 over");
      shape.setFill(color(255,238,173));
    } else shape.setFill(color(255,111,105));
   }
 
   void drawParticle() {
     pushMatrix();
     translate(loc.x, loc.y, loc.z);
     shape(shape);
     popMatrix();
   }
 
   boolean livesOver() {
     if (life.y >= maxlife) {
       //println("livesOver");
       return true;
     } else return false;
   }
 }
class ParticleSystem {
  ArrayList<Particle> particleList;
  float size;
  PVector location;
  Particle particle;

  ParticleSystem(PVector location_) {
    particleList = new ArrayList<Particle>();
    location = location_;
  }

  void addParticle(float size_) {
    size = size_;
    particleList.add(new Particle(size, location));
  }

  void addParticleCube(float size_) {
    size = size_;
    particleList.add(new ParticleCube(size, location));
  }

  void addForce(PVector force) {
    for (Particle particle : particleList)
      particle.addForce(force);
  }


  void startSys() {
    for (int i = 0; i < particleList.size(); i++) {
      Particle particle = particleList.get(i);
      particle.updateParticle();
      particle.drawParticle();

      if (particle.livesOver() == true) {
        //println(" life over. index =  ", i);
        particleList.remove(i);
        if (i > 0)
          i--;
        //println("reset index = ", i);
        //println("list length = ", particleList.size());
      }
    }
  }
}
// COH, HBHB, TVMA
void setup() {
  size(510, 510);
  background(255);
  strokeWeight(10);
  magie(0, 0, height, width, 0);
}


void draw(){
   if (mousePressed == true) {
    background(255);
    magie(0, 0, height - 5, width - 5, 0);
  } 
}


void magie(int x, int y, int w, int h, int step) {

  if (step > 3) {
    rect(x, y, w, h);
  } else {

    int choice = (int)random(0, 4);

    if (choice == 0 && step == 0) {
      magie(x, y, w, h, step);
    } else {
      step++;
      switch(choice) {
        case 0:
          int cooler = (int) random(0, 3);
          switch(cooler) {
            case  0:
              fill(255, 0, 0);
              break;
            case 1:
              fill(255, 238, 0);
              break;
            case 2:
              fill(0, 0, 240);
            break;
          }
        rect(x, y, w, h);
        noFill();

        break;
      case 1:
        magie(x, y, w/2, h, step);
        magie(x + (w/2), y, w/2, h, step);
        break;
      case 2:
        noFill();
        magie(x, y, w, h, step);
        break;
      case 3:
        magie(x, y, w, h/2, step);
        magie(x, y + (h/2), w, h/2, step);
      }
    }
  }
}
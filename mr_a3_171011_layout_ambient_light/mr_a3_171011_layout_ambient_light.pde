color c_bg = color(60, 71, 72); // background color of the application
color c_highlight = color(83, 93, 96); // highlight color to highlight important UI elements
/*?? = color of borders ??*/color c_cursor = color(33, 33, 33); //color of the cursor 
color c_selected, c_check = color(256, 256, 256); // should never happen in RGB 0-255 space, so we can check if value is set
color c_sunrise = color(255, 202, 112);
color c_underwater = color(35, 198, 193);
/*cat*/color c_labels = color(200, 200, 200);

Position pos_preview;
Button b_preview;
Position pos_sunrise;
Button b_sunrise;
Position pos_sunrise_color_field;
Button b_sun_color_field;
Position pos_underwater;
Button b_underwater;
Position pos_water_color_field;
Button b_water_color_field;
/*cat*/Position pos_brightHi;
/*cat*/Position pos_brightLo;
/*cat*/Position pos_satHi;
/*cat*/Position pos_satLo;

void setup() {
  // Window
  size(700, 800);
  background(c_bg);

  // Preview box
  strokeWeight(10);
  stroke(c_cursor);
  pos_preview = new Position(30, 30);
  b_preview = new Button(c_highlight, pos_preview, 640, 60); //preview box
  
  // Text Font and stroke
  PFont font = loadFont("SitkaDisplay-Italic-36.vlw");
  strokeWeight(1);
  
  // Sunrise Button
  pos_sunrise = new Position(50., 580.);
  b_sunrise = new Button(c_highlight, pos_sunrise, 600., 80.); //first suggestion "Sunrise"
  fill(c_sunrise);
  textFont(font);
  text("Sunrise", 70, 630);
  pos_sunrise_color_field = new Position(350, 590);
  b_sun_color_field = new Button(c_sunrise, pos_sunrise_color_field, 290, 60);

  // Underwater buton
  pos_underwater = new Position(50, 690);
  b_underwater = new Button(c_highlight, pos_underwater, 600, 80); //second suggestion "under water world"
  fill(c_underwater);
  textFont(font);
  text("Underwater World", 70, 740);
  pos_water_color_field = new Position(350, 700);
  b_water_color_field = new Button(c_underwater, pos_water_color_field, 290, 60) ;
}

void draw() {
  color_preview();
  color_picker();
  select_brightness();
  select_saturation();

  //Change the cusor shape in front of a button
  if ((mouseX >= pos_sunrise.x && mouseX <= pos_sunrise.x + b_sunrise.getWidth() && mouseY >= pos_sunrise.y && mouseY <= pos_sunrise.y + b_sunrise.getHeight()) || (mouseX >= pos_underwater.x && mouseX <= pos_underwater.x + b_underwater.getWidth() && mouseY >= pos_underwater.y && mouseY <= pos_underwater.y + b_underwater.getHeight())) {
    cursor(HAND);
  } else {
    cursor(ARROW);
  }
  
  //Change the color of the preview box if a button is pressed
  if (mousePressed == true) {
    if (mouseX >= pos_sunrise.x && mouseX <= pos_sunrise.x + b_sunrise.getWidth() && mouseY >= pos_sunrise.y && mouseY <= pos_sunrise.y + b_sunrise.getHeight()) {
      b_preview.setColor(c_sunrise);
    } else if (mouseX >= pos_underwater.x && mouseX <= pos_underwater.x + b_underwater.getWidth() && mouseY >= pos_underwater.y && mouseY <= pos_underwater.y + b_underwater.getHeight()) {
      b_preview.setColor(c_underwater);
    }
  }
}

class Position {
  float x;
  float y;
  Position(float x_new, float y_new) {
    x = x_new;
    y = y_new;
  }
}
class Button {
  color c;
  Position pos;
  float width; 
  float height;

  Button(color c_new, Position pos_new, float width_new, float height_new) {
    c = c_new;
    pos = pos_new;
    width = width_new; 
    height = height_new;

    fill (c);
    rect(pos.x, pos.y, width, height);
  }

  float getWidth() {
    return width;
  }

  float getHeight() {
    return height;
  }

  void setColor(color c_new) {
    c = c_new;
    fill(c);
    rect(pos.x, pos.y, width, height);
  }
}

// All Function for the main color box
void color_preview() {
  if (c_selected == c_check) {
    fill(c_highlight);
  } else {
    fill(c_selected);
  }
}

// All Functions for the color wheel 
void color_picker() {
  stroke(c_highlight);
  fill(c_highlight);
  strokeWeight(1);
  ellipse(width/2, height/2.5, 350, 350);
}

void select_brightness() {
  stroke(c_cursor);
  strokeWeight(10);
  /*cat-need these variables to be global...*/float brightnessY = width/7.5;
  float brightnessHi = height/4;
  float brightnessLo = height/1.8;
  line(brightnessY, brightnessHi, brightnessY, brightnessLo);
}


void select_saturation() {
  stroke(c_cursor);
  strokeWeight(10);
  line(width - width/7.5, height/4, width - width/7.5, height/1.8);
}

void changecolorto(color selected) {

  colorMode(HSB, 360, 1, 1); 

  // do the magic here

  colorMode(RGB, 255, 255, 255);
}
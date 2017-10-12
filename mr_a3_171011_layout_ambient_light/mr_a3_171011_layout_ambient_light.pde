color c_bg = color(60, 71, 72); // background color of the application
color c_highlight = color(83, 93, 96); // highlight color to highlight important UI elements
color c_cursor = color(33, 33, 33); //color of the cursor
color c_selected, c_check = color(256, 256, 256); // should never happen in RGB 0-255 space, so we can check if value is set

void setup() {
  size(700,800);
  background(c_bg);
  

}

void draw() {
  color_preview();
  color_picker();
  select_brightness();
  select_saturation();
}





// All Function for the main color box
void color_preview(){
  if(c_selected == c_check){
    fill(c_highlight);
  }else{
    fill(c_selected);
  }
  strokeWeight(1);
  stroke(c_highlight);
  rect(30,30, 640, 60);
}


// All Functions for the color wheel 
void color_picker(){
  stroke(c_highlight);
  fill(c_highlight);
  strokeWeight(1);
  ellipse(width/2,height/2.5,350,350);
}

void select_brightness(){
  stroke(c_cursor);
  strokeWeight(10);
  line(width/7.5,height/4,width/7.5,height/1.8);
  
}


void select_saturation(){
  stroke(c_cursor);
  strokeWeight(10);
  line(width - width/7.5,height/4,width - width/7.5,height/1.8);
}




void changecolorto(color selected){
 
  colorMode(HSB, 360, 1, 1); 
  
  // do the magic here
  
  colorMode(RGB, 255, 255, 255);
}
import peasy.*;
import controlP5.*;

PeasyCam cam;

ControlP5 cp5;
Textlabel frameRateLabel;

Slider s;

PFont font;

void setup(){
  //Screen Size
  size(1152, 864, P3D);
  //Camera 
  cam = new PeasyCam(this, 400);
  cam.lookAt(50, 50, 0);
  
  //HUD Library
  
    //Font
  font = createFont("Trebuchet MS", 24);
  
  cp5 = new ControlP5(this);
  cp5.setFont(font);

  setSliders();
     
  cp5.setAutoDraw(false);
}

void draw(){
   background(#4D4D4D);
   
   setupPoints();
   
   //=================   HUD  ==========================
   
   gui();
}

void setupPoints(){
   strokeWeight(3);
   stroke(#45D7C3);
   fill(#34C6B2, 200);
   box(100, 100, 40);

}

void setLabelsText(){
  frameRateLabel = new Textlabel(cp5, str(int(frameRate)), 20, 20); 

}

void setSliders(){
  cp5.addSlider("FPS")
     .setPosition(20, 40)
     .setWidth(200)
     .setRange(0,60) // values can range from big to small as well
     .setValue(1)
     .setDecimalPrecision(0)
     .setSliderMode(Slider.FIX)
     ;
      cp5.getController("FPS").getValueLabel().align(ControlP5.LEFT, ControlP5.RIGHT_OUTSIDE).setPaddingX(0);
      cp5.getController("FPS").getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE).setPaddingX(0);
}

void gui() {
  hint(DISABLE_DEPTH_TEST);
  cam.beginHUD();
  
  cp5.get("FPS").setValue(int(frameRate));
  
  cp5.draw();
  cam.endHUD();
  hint(ENABLE_DEPTH_TEST);
}

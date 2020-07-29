import peasy.*;
import controlP5.*;

PeasyCam cam;

ControlP5 cp5;

PFont font;

boolean camMoveXYToggle = false;
boolean camRotateToggle = true;
boolean camZoomToggle = true;

void setup(){
  //Screen Size
  size(1152, 864, P3D);
  //Camera 
  smooth();
  cam = new PeasyCam(this, 400);
  cam.reset();
  cam.setCenterDragHandler(null);
  cam.setMaximumDistance(1000);
  cam.setResetOnDoubleClick(false);
  
  //HUD Library
  
    //Font
  font = createFont("Trebuchet MS", 24);
  
  cp5 = new ControlP5(this);
  cp5.setFont(font);
  cp5.setColorBackground(#4D4D4D);
  cp5.setColorForeground(#34C6B2);
  cp5.setColorValueLabel(#67F9E5);

  setSliders();
  setLabelsText();
  setToggles();
  setButtons();
  
  cp5.setAutoDraw(false);
}

void draw(){
   background(#4D4D4D);
   
   testObject();
   
   //=================   HUD  ==========================
   
   cameraToggle();
   
   gui();
}


void testObject(){
   strokeWeight(3);
   stroke(#23B5A1);
   fill(#23B5A1, 150);
   sphere(100);

}

void gui() {
  hint(DISABLE_DEPTH_TEST);
  cam.beginHUD();
  
  cp5.get("FPS").setValue(int(frameRate));
  
  cp5.draw();
  cam.endHUD();
  hint(ENABLE_DEPTH_TEST);
}

void  cameraToggle(){
  if(camMoveXYToggle){
     cam.setCenterDragHandler(cam.getPanDragHandler());
  }else{
    cam.setCenterDragHandler(null);
  }
  
  if(camRotateToggle){
     cam.setLeftDragHandler(cam.getRotateDragHandler());
  }else{
     cam.setLeftDragHandler(null);
  }
  
  if(camZoomToggle){
     cam.setRightDragHandler(cam.getZoomDragHandler());
     cam.setWheelHandler(cam.getZoomWheelHandler());
  }else{
    cam.setRightDragHandler(null);
    cam.setWheelHandler(null);
  }
}

void setLabelsText(){
  cp5.addTextlabel("dbClickLabel")
     .setFont(createFont("Trebuchet MS", 16))
     .setText("Double-click to reset the camera position")
     .setPosition(20, height-24-20)
     .setColorValue(#67F9E5)
     ;
     
  cp5.addTextlabel("rigthClickOrWheelLabel")
     .setFont(createFont("Trebuchet MS", 16))
     .setText("Right-click and move/Wheel-up or Wheel-down to Zoom")
     .setPosition(20, height-24-50)
     .setColorValue(#67F9E5)
     ;
     
  cp5.addTextlabel("leftClickLabel")
     .setFont(createFont("Trebuchet MS", 16))
     .setText("Click and move to rotate object")
     .setPosition(20, height-24-80)
     .setColorValue(#67F9E5)
     ;
  cp5.addTextlabel("menuLabel")
     .setFont(createFont("Trebuchet MS", 20))
     .setText("MENU")
     .setPosition(width-70, 20)
     .setColorValue(#67F9E5)
     ;   
     
  cp5.addTextlabel("moveXYToggleLabel")
     .setFont(createFont("Trebuchet MS", 16))
     .setText("On/Off camera movment on x/y axis")
     .setPosition(width-340, 60)
     .setColorValue(#67F9E5)
     ;
     
  cp5.addTextlabel("rotateTogleLabel")
     .setFont(createFont("Trebuchet MS", 16))
     .setText("On/Off camera rotate")
     .setPosition(width-235, 120)
     .setColorValue(#67F9E5)
     ;
     
  cp5.addTextlabel("ScrollZoomLabel")
     .setFont(createFont("Trebuchet MS", 16))
     .setText("On/Off camera Zoom")
     .setPosition(width-230, 180)
     .setColorValue(#67F9E5)
     ;

}

void setSliders(){
  cp5.addSlider("FPS")
     .setPosition(20, 40)
     .setWidth(200)
     .setRange(0,60) // values can range from big to small as well
     .setValue(1)
     .setColorLabel(#67F9E5)
     .setDecimalPrecision(0)
     .setLock(true)
     .setSliderMode(Slider.FIX)
     ;
     
      cp5.getController("FPS").getValueLabel().align(ControlP5.CENTER, ControlP5.TOP_OUTSIDE).setPaddingX(0);
      cp5.getController("FPS").getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE).setPaddingX(0);
}

void setButtons(){
  cp5.addButton("resetCameraPosition")
     .setFont(createFont("Trebuchet MS", 16))
     .setColorBackground(#34C6B2)
     .setColorActive(#23B5A1) 
     .setLabel("Reset object position")
     .setValue(0)
     .setSize(190, 30)
     .setPosition(width-210, 240)
     ;
}

public void resetCameraPosition() {
  cam.reset();
}

void setToggles(){
 
  cp5.addToggle("camMoveXYToggle")
     .setFont(createFont("Trebuchet MS", 16))
     .setCaptionLabel("On/Off") 
     .setColorCaptionLabel(#67F9E5) 
     .setPosition(width-60,60)
     .setColorActive(#67F9E5) 
     .setColorBackground(#2B2B2B) 
     .setSize(40,20)
     .setValue(false)
     .setMode(ControlP5.SWITCH)
     ;
     
  cp5.addToggle("camRotateToggle")
     .setFont(createFont("Trebuchet MS", 16))
     .setCaptionLabel("On/Off") 
     .setColorCaptionLabel(#67F9E5) 
     .setPosition(width-60,120)
     .setColorActive(#67F9E5) 
     .setColorBackground(#2B2B2B) 
     .setSize(40,20)
     .setValue(true)
     .setMode(ControlP5.SWITCH)
     ;
     
  cp5.addToggle("camZoomToggle")
     .setFont(createFont("Trebuchet MS", 16))
     .setCaptionLabel("On/Off") 
     .setColorCaptionLabel(#67F9E5) 
     .setPosition(width-60,180)
     .setColorActive(#67F9E5) 
     .setColorBackground(#2B2B2B) 
     .setSize(40,20)
     .setValue(true)
     .setMode(ControlP5.SWITCH)
     ;
  
}


void gui() {
  hint(DISABLE_DEPTH_TEST);
  cam.beginHUD();
  
  cp5.get("FPS").setValue(int(frameRate));
  fill(#1A1A1A, 100);
  strokeWeight(1);
  rect(width - 300, 2, 299, 303);
  rect(width - 300, 309, 299, 443);
  
  cp5.draw();
  cam.endHUD();
  hint(ENABLE_DEPTH_TEST);
}

void setLabelsText(){
     
  cp5.addTextlabel("rigthClickOrWheelLabel")
     .setFont(createFont("Trebuchet MS", 16))
     .setText("Right-click and move/Wheel-up or Wheel-down to Zoom")
     .setPosition(20, height-24-20)
     .setColorValue(#67F9E5)
     ;
     
  cp5.addTextlabel("leftClickLabel")
     .setFont(createFont("Trebuchet MS", 16))
     .setText("Click and move to rotate object")
     .setPosition(20, height-24-50)
     .setColorValue(#67F9E5)
     ;
     
  cp5.addTextlabel("wheelClickLabel")
     .setFont(createFont("Trebuchet MS", 16))
     .setText("Click wheel to move object")
     .setPosition(20, height-24-80)
     .setColorValue(#67F9E5)
     ;
     
  cp5.addTextlabel("menuLabel")
     .setFont(createFont("Trebuchet MS", 20))
     .setText("OPTIONS")
     .setPosition(width-90, 20)
     .setColorValue(#67F9E5)
     ;   
     
  cp5.addTextlabel("moveXYToggleLabel")
     .setFont(createFont("Trebuchet MS", 16))
     .setText("Camera movment on x/y axis")
     .setPosition(width-290, 60)
     .setColorValue(#67F9E5)
     ;
     
  cp5.addTextlabel("rotateTogleLabel")
     .setFont(createFont("Trebuchet MS", 16))
     .setText("Camera rotate")
     .setPosition(width-185, 120)
     .setColorValue(#67F9E5)
     ;
     
  cp5.addTextlabel("ScrollZoomLabel")
     .setFont(createFont("Trebuchet MS", 16))
     .setText("Camera Zoom")
     .setPosition(width-180, 180)
     .setColorValue(#67F9E5)
     ;
     
  cp5.addTextlabel("pointCloudToMeshLabel")
     .setFont(createFont("Trebuchet MS", 16))
     .setText("Turn on/off mesh")
     .setPosition(width-200, 340)
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
     
   cp5.addToggle("pointCloudToMesh")
     .setFont(createFont("Trebuchet MS", 16))
     .setCaptionLabel("On/Off") 
     .setColorCaptionLabel(#67F9E5) 
     .setPosition(width-60,340)
     .setColorActive(#67F9E5) 
     .setColorBackground(#2B2B2B) 
     .setSize(40,20)
     .setValue(false)
     .setMode(ControlP5.SWITCH)
     ;
  
}

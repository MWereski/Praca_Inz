import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 
import peasy.*; 
import KinectPV2.KJoint; 
import KinectPV2.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class kinect_v1 extends PApplet {







public void setup() {
  //main settings
  
  hint(DISABLE_OPENGL_ERRORS);
  hint(ENABLE_STROKE_PURE);
  //size(800, 600, P3D);
  

  //Camera settings
  cam = new PeasyCam(this, CameraParams.cx, CameraParams.cy, CameraParams.cz, CameraParams.doubleDist);
  
  cam.rotateX(CameraParams.k1);   
  cam.rotateY(CameraParams.k2); 
  cam.rotateZ(CameraParams.k3);
  
  cam.setCenterDragHandler(null);
  cam.setResetOnDoubleClick(false);
    
  //Font
  font = createFont("Trebuchet MS", 24);
  
  //GUI
  cp5 = new ControlP5(this);
  cp5.setFont(font);
  cp5.setColorBackground(0xff4D4D4D);
  cp5.setColorForeground(0xff34C6B2);
  cp5.setColorValueLabel(0xff67F9E5);
  
  setSliders();
  setLabelsText();
  setToggles();
  setButtons();
  
  cp5.setAutoDraw(false);

  //Kinect settings

  kinect = new KinectPV2(this);

  //Enable point cloud
  kinect.enableDepthImg(true);
  kinect.enablePointCloud(true);

  kinect.init();
  
  //setting first point cloud data
  prevRawData = kinect.getRawDepthData();
}

public void draw() {
  //Background draw
  background(0);
  
  translate(0, 0, -1800);
  //scaling size of point cloud
  img = kinect.getPointCloudDepthImage();

  int w = img.width;
  int h = img.height;
  
  cols = w / scl;
  rows = h / scl;

  smoothData = new int [cols * rows];

  newRawData = kinect.getRawDepthData();
  //reduce boiling points
  for (int y = PApplet.parseInt(rows/leftPointsY); y < PApplet.parseInt(rows-rows/rightPointsY); y++) {
    for (int x = PApplet.parseInt(cols/leftPointsX); x < PApplet.parseInt(cols-cols/rightPointsX); x++) {
      int offset = x + y * w;
      
      int newD = newRawData[offset];
      int prevD = prevRawData[offset];

      int avgD = avgZofPoint(iterationsOfAvg, newD, prevD);
      
      if(abs(avgD-newD) > 300) avgD = max(newD, prevD) - abs(avgD-newD);
      
      //if(abs( newD - prevD) > 800) avgD = 0;
      
      if(abs( newD - prevD) > 650) avgD = 0;
      
      //if(avgD > 650) avgD = 0;
      
      smoothData[offset] = avgD;
      
    }
  }
  points = new ArrayList<PVector>();
  mesh = createShape(GROUP);
  //strokeWeight(2);
  //pushMatrix();
  
  strokeWeight(1);
  stroke(0xff23B5A1);
  fill(0xff23B5A1, 150);
  
  lights();

  for (int y = PApplet.parseInt(rows/leftPointsY); y < PApplet.parseInt(rows-rows/rightPointsY);  y++) {
      //beginShape(POINTS);
      //TRIANGLE_STRIP
    for (int x = PApplet.parseInt(cols/leftPointsX); x < PApplet.parseInt(cols-cols/rightPointsX); x++) {
      
      int offset = x*scl + y*scl * w;
      float d =smoothData[offset];
      d = map(d, 0, 4500, 2250, 0);

      if(d > 1000*leftPointsZ) continue;
      if(d < 1000*rightPointsZ) continue;
      
      PVector point1 = depthToPointCloudPos(x*scl, y*scl, d);
      
     // points.add(point1);
      
      int offset2 = x*scl + (y+1)*scl * w;
      float d2 =smoothData[offset2];
      d2 = map(d2, 0, 4500, 2250, 0);

      if(d2 > 1000*leftPointsZ) continue;
      if(d2 < 1000*rightPointsZ) continue;
      
      PVector point2 = depthToPointCloudPos(x*scl, (y+1)*scl, d2);
      
      
      if(abs(d - d2) > 1) continue;
      
      points.add(point1);
      points.add(point2);
      //vertex(point1.x, point1.y, point1.z);
      //vertex(point2.x, point2.y, point2.z);

    }
      //endShape();
  }
  
   if(pointCloudToMesh){
        for(int p = 1; p < points.size()-2; p+=2){
       
       PVector p1 = (PVector)points.get(p-1);
       PVector p2 = (PVector)points.get(p);
       PVector p3 = (PVector)points.get(p+1);
       PVector p4 = (PVector)points.get(p+2);
       
      if(abs(p3.x - p1.x) > 10) continue;
     
      if(dist(p1.z, p2.z, maxDistance) || dist(p1.z, p3.z, maxDistance) || dist(p2.z, p3.z, maxDistance)){
        continue;
      }
     
      t = createShape();
      t.beginShape(TRIANGLE_STRIP);
      t.vertex(p1.x, p1.y, p1.z);
      t.vertex(p2.x, p2.y, p2.z);
      t.vertex(p3.x, p3.y, p3.z);
      t.endShape();
      
      mesh.addChild(t);
      
      if(abs(p2.x - p3.x) > 10) continue;
     
      if(dist(p2.z, p3.z, maxDistance) || dist(p2.z, p4.z, maxDistance) || dist(p3.z, p4.z, maxDistance)){
        continue;
      }
     
      t = createShape();
      t.beginShape(TRIANGLE_STRIP);
      t.vertex(p2.x, p2.y, p2.z);
      t.vertex(p3.x, p3.y, p3.z);
      t.vertex(p4.x, p4.y, p4.z);
      t.endShape();
      
      mesh.addChild(t);

     } 
   }
 // pushMatrix();
  if(pointCloudToMesh)
  {
    shape(mesh);
  }else{
    beginShape(POINTS);
    for(int i = 0; i < points.size(); i++){
      PVector p = (PVector)points.get(i);
      vertex(p.x, p.y, p.z);
  }
    
   endShape();
  }

  
 // popMatrix();
  
  prevRawData = smoothData;
     
   cameraToggle();
   
   gui();

}

public void gui() {
  hint(DISABLE_DEPTH_TEST);
  cam.beginHUD();
  cp5.get("FPS").setValue(PApplet.parseInt(frameRate));

  fill(0xff1A1A1A, 100);
  strokeWeight(1);
  rect(width - 300, 2, 299, 303);
  rect(width - 300, 309, 299, 443);
  
  cp5.draw();
  cam.endHUD();
  hint(ENABLE_DEPTH_TEST);
}

public void setLabelsText(){
     
  cp5.addTextlabel("rigthClickOrWheelLabel")
     .setFont(createFont("Trebuchet MS", 16))
     .setText("Right-click and move/Wheel-up or Wheel-down to Zoom")
     .setPosition(20, height-24-20)
     .setColorValue(0xff67F9E5)
     ;
     
  cp5.addTextlabel("leftClickLabel")
     .setFont(createFont("Trebuchet MS", 16))
     .setText("Click and move to rotate object")
     .setPosition(20, height-24-50)
     .setColorValue(0xff67F9E5)
     ;
     
  cp5.addTextlabel("wheelClickLabel")
     .setFont(createFont("Trebuchet MS", 16))
     .setText("Click wheel to move object")
     .setPosition(20, height-24-80)
     .setColorValue(0xff67F9E5)
     ;
     
  cp5.addTextlabel("menuLabel")
     .setFont(createFont("Trebuchet MS", 20))
     .setText("OPTIONS")
     .setPosition(width-90, 20)
     .setColorValue(0xff67F9E5)
     ;   
     
  cp5.addTextlabel("moveXYToggleLabel")
     .setFont(createFont("Trebuchet MS", 16))
     .setText("Camera movment on x/y axis")
     .setPosition(width-290, 60)
     .setColorValue(0xff67F9E5)
     ;
     
  cp5.addTextlabel("rotateTogleLabel")
     .setFont(createFont("Trebuchet MS", 16))
     .setText("Camera rotate")
     .setPosition(width-185, 120)
     .setColorValue(0xff67F9E5)
     ;
     
  cp5.addTextlabel("ScrollZoomLabel")
     .setFont(createFont("Trebuchet MS", 16))
     .setText("Camera Zoom")
     .setPosition(width-180, 180)
     .setColorValue(0xff67F9E5)
     ;
     
  cp5.addTextlabel("pointCloudToMeshLabel")
     .setFont(createFont("Trebuchet MS", 16))
     .setText("Turn on/off mesh")
     .setPosition(width-200, 330)
     .setColorValue(0xff67F9E5)
     ;
     
  cp5.addTextlabel("stepToChangeLabel")
     .setFont(createFont("Trebuchet MS", 16))
     .setText("Step: " + str(stepToChange))
     .setPosition(width-225, 385)
     .setColorValue(0xff67F9E5)
     ;   
     
  cp5.addTextlabel("stepToChangeMultiplierLabel")
     .setFont(createFont("Trebuchet MS", 16))
     .setText("Mult: " + String.format(java.util.Locale.US,"%.0f", multiplier))
     .setPosition(width-75, 385)
     .setColorValue(0xff67F9E5)
     ; 
     
 cp5.addTextlabel("leftPointsXLabelText")
     .setFont(createFont("Trebuchet MS", 16))
     .setText("X axis")
     .setPosition(width-295, 415)
     .setColorValue(0xff67F9E5)
     ;
     
 cp5.addTextlabel("leftPointsXLabel")
     .setFont(createFont("Trebuchet MS", 16))
     .setText("Left: " + str(leftPointsX))
     .setPosition(width-225, 445)
     .setColorValue(0xff67F9E5)
     ;
     
  cp5.addTextlabel("rightPointsXLabel")
     .setFont(createFont("Trebuchet MS", 16))
     .setText("Right: " + str(rightPointsX))
     .setPosition(width-80, 445)
     .setColorValue(0xff67F9E5)
     ;
          
 cp5.addTextlabel("leftPointsYLabelText")
     .setFont(createFont("Trebuchet MS", 16))
     .setText("Y axis")
     .setPosition(width-295, 475)
     .setColorValue(0xff67F9E5)
     ;
     
 cp5.addTextlabel("leftPointsYLabel")
     .setFont(createFont("Trebuchet MS", 16))
     .setText("Top: " + str(leftPointsY))
     .setPosition(width-225, 505)
     .setColorValue(0xff67F9E5)
     ;
     
  cp5.addTextlabel("rightPointsYLabel")
     .setFont(createFont("Trebuchet MS", 16))
     .setText("Down: " + str(rightPointsY))
     .setPosition(width-80, 505)
     .setColorValue(0xff67F9E5)
     ;
     
 cp5.addTextlabel("leftPointsZLabelText")
     .setFont(createFont("Trebuchet MS", 16))
     .setText("Z axis")
     .setPosition(width-295, 535)
     .setColorValue(0xff67F9E5)
     ;
     
 cp5.addTextlabel("leftPointsZLabel")
     .setFont(createFont("Trebuchet MS", 16))
     .setText("Front: " + str(leftPointsZ))
     .setPosition(width-225, 565)
     .setColorValue(0xff67F9E5)
     ;
     
  cp5.addTextlabel("rightPointsZLabel")
     .setFont(createFont("Trebuchet MS", 16))
     .setText("Back: " + str(rightPointsZ))
     .setPosition(width-80, 565)
     .setColorValue(0xff67F9E5)
     ;

}

public void setSliders(){
  cp5.addSlider("FPS")
     .setPosition(20, 40)
     .setWidth(200)
     .setRange(0,60) // values can range from big to small as well
     .setValue(1)
     .setColorLabel(0xff67F9E5)
     .setDecimalPrecision(0)
     .setLock(true)
     .setSliderMode(Slider.FIX)
     ;
     
      cp5.getController("FPS").getValueLabel().align(ControlP5.CENTER, ControlP5.TOP_OUTSIDE).setPaddingX(0);
      cp5.getController("FPS").getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE).setPaddingX(0);
}

public void setButtons(){
  cp5.addButton("resetCameraPosition")
     .setFont(createFont("Trebuchet MS", 16))
     .setColorBackground(0xff34C6B2)
     .setColorActive(0xff23B5A1) 
     .setLabel("Reset object position")
     .setValue(0)
     .setSize(190, 30)
     .setPosition(width-210, 240)
     ;
     
 cp5.addButton("addstepToChange")
     .setFont(createFont("Trebuchet MS", 16))
     .setColorBackground(0xff34C6B2)
     .setColorActive(0xff23B5A1) 
     .setLabel("+")
     .setSize(30, 30)
     .setPosition(width-260, 380)
     ;
     
 cp5.addButton("substepToChange")
     .setFont(createFont("Trebuchet MS", 16))
     .setColorBackground(0xff34C6B2)
     .setColorActive(0xff23B5A1) 
     .setLabel("-")
     .setSize(30, 30)
     .setPosition(width-295, 380)
     ;
     
 cp5.addButton("addstepToChangeMultiplier")
     .setFont(createFont("Trebuchet MS", 16))
     .setColorBackground(0xff34C6B2)
     .setColorActive(0xff23B5A1) 
     .setLabel("+")
     .setSize(30, 30)
     .setPosition(width-105, 380)
     ;
     
 cp5.addButton("substepToChangeMultiplier")
     .setFont(createFont("Trebuchet MS", 16))
     .setColorBackground(0xff34C6B2)
     .setColorActive(0xff23B5A1) 
     .setLabel("-")
     .setSize(30, 30)
     .setPosition(width-140, 380)
     ;
     
 cp5.addButton("addLeftPointsX")
     .setFont(createFont("Trebuchet MS", 16))
     .setColorBackground(0xff34C6B2)
     .setColorActive(0xff23B5A1) 
     .setLabel("+")
     .setSize(30, 30)
     .setPosition(width-260, 440)
     ;
     
 cp5.addButton("subLeftPointsX")
     .setFont(createFont("Trebuchet MS", 16))
     .setColorBackground(0xff34C6B2)
     .setColorActive(0xff23B5A1) 
     .setLabel("-")
     .setSize(30, 30)
     .setPosition(width-295, 440)
     ;
     
     
 cp5.addButton("addRightPointsX")
     .setFont(createFont("Trebuchet MS", 16))
     .setColorBackground(0xff34C6B2)
     .setColorActive(0xff23B5A1) 
     .setLabel("+")
     .setSize(30, 30)
     .setPosition(width-115, 440)
     ;
     
 cp5.addButton("subRightPointsX")
     .setFont(createFont("Trebuchet MS", 16))
     .setColorBackground(0xff34C6B2)
     .setColorActive(0xff23B5A1) 
     .setLabel("-")
     .setSize(30, 30)
     .setPosition(width-150, 440)
     ;
     
 cp5.addButton("addLeftPointsY")
     .setFont(createFont("Trebuchet MS", 16))
     .setColorBackground(0xff34C6B2)
     .setColorActive(0xff23B5A1) 
     .setLabel("+")
     .setSize(30, 30)
     .setPosition(width-260, 500)
     ;
     
 cp5.addButton("subLeftPointsY")
     .setFont(createFont("Trebuchet MS", 16))
     .setColorBackground(0xff34C6B2)
     .setColorActive(0xff23B5A1) 
     .setLabel("-")
     .setSize(30, 30)
     .setPosition(width-295, 500)
     ;
     
     
 cp5.addButton("addRightPointsY")
     .setFont(createFont("Trebuchet MS", 16))
     .setColorBackground(0xff34C6B2)
     .setColorActive(0xff23B5A1) 
     .setLabel("+")
     .setSize(30, 30)
     .setPosition(width-115, 500)
     ;
     
 cp5.addButton("subRightPointsY")
     .setFont(createFont("Trebuchet MS", 16))
     .setColorBackground(0xff34C6B2)
     .setColorActive(0xff23B5A1) 
     .setLabel("-")
     .setSize(30, 30)
     .setPosition(width-150, 500)
     ;
     
 cp5.addButton("addLeftPointsZ")
     .setFont(createFont("Trebuchet MS", 16))
     .setColorBackground(0xff34C6B2)
     .setColorActive(0xff23B5A1) 
     .setLabel("+")
     .setSize(30, 30)
     .setPosition(width-260, 560)
     ;
     
 cp5.addButton("subLeftPointsZ")
     .setFont(createFont("Trebuchet MS", 16))
     .setColorBackground(0xff34C6B2)
     .setColorActive(0xff23B5A1) 
     .setLabel("-")
     .setSize(30, 30)
     .setPosition(width-295, 560)
     ;
       
 cp5.addButton("addRightPointsZ")
     .setFont(createFont("Trebuchet MS", 16))
     .setColorBackground(0xff34C6B2)
     .setColorActive(0xff23B5A1) 
     .setLabel("+")
     .setSize(30, 30)
     .setPosition(width-115, 560)
     ;
     
 cp5.addButton("subRightPointsZ")
     .setFont(createFont("Trebuchet MS", 16))
     .setColorBackground(0xff34C6B2)
     .setColorActive(0xff23B5A1) 
     .setLabel("-")
     .setSize(30, 30)
     .setPosition(width-150, 560)
     ;
}

public void setToggles(){
 
  cp5.addToggle("camMoveXYToggle")
     .setFont(createFont("Trebuchet MS", 16))
     .setCaptionLabel("On/Off") 
     .setColorCaptionLabel(0xff67F9E5) 
     .setPosition(width-60,60)
     .setColorActive(0xff67F9E5) 
     .setColorBackground(0xff2B2B2B) 
     .setSize(40,20)
     .setValue(false)
     .setMode(ControlP5.SWITCH)
     ;
     
  cp5.addToggle("camRotateToggle")
     .setFont(createFont("Trebuchet MS", 16))
     .setCaptionLabel("On/Off") 
     .setColorCaptionLabel(0xff67F9E5) 
     .setPosition(width-60,120)
     .setColorActive(0xff67F9E5) 
     .setColorBackground(0xff2B2B2B) 
     .setSize(40,20)
     .setValue(true)
     .setMode(ControlP5.SWITCH)
     ;
     
  cp5.addToggle("camZoomToggle")
     .setFont(createFont("Trebuchet MS", 16))
     .setCaptionLabel("On/Off") 
     .setColorCaptionLabel(0xff67F9E5) 
     .setPosition(width-60,180)
     .setColorActive(0xff67F9E5) 
     .setColorBackground(0xff2B2B2B) 
     .setSize(40,20)
     .setValue(true)
     .setMode(ControlP5.SWITCH)
     ;
     
   cp5.addToggle("pointCloudToMesh")
     .setFont(createFont("Trebuchet MS", 16))
     .setCaptionLabel("On/Off") 
     .setColorCaptionLabel(0xff67F9E5) 
     .setPosition(width-60,330)
     .setColorActive(0xff67F9E5) 
     .setColorBackground(0xff2B2B2B) 
     .setSize(40,20)
     .setValue(false)
     .setMode(ControlP5.SWITCH)
     ;
  
}
static class CameraParams {
  
  static float cx = 256.4065f;
  static float cy = 256.64053f;
  static float cz = 0;
  
  static float doubleDist = 366.775560f;
  
  static float k1 = 0;
  static float k2 = 0;
  static float k3 = 0;
}

public PVector depthToPointCloudPos(int x, int y, float depthValue) {
  PVector point = new PVector();
  point.z = (depthValue);// / (1.0f); // Convert from mm to meters
  point.x = x;
  point.y = y;
  return point;
}

public int avgZofPoint(int iterationsOfAvg, int nD, int pD){
  int temp1 = (nD + pD)/2;   
  int temp2 = 0;
  int t = temp1;
  for(int i = 0; i < iterationsOfAvg-1; i++){
    temp2 = (t + pD)/2;  
    t = temp2;
  }
     
  return temp2;
}

public boolean dist(float a, float b, float maxDist){
  
  if(abs(a-b) > maxDist){
    return true;
  }
  return false;
}

public void resetCameraPosition() {
  cam.reset();
}

public void cameraToggle(){
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

public void addstepToChange(){
  stepToChange += (1/multiplier);
  Textlabel l = (Textlabel)cp5.get("stepToChangeLabel");
  l.setText("Step: " + String.format(java.util.Locale.US,"%.3f", stepToChange));
 
}
public void substepToChange(){
  if(stepToChange > 0){
      stepToChange -= (1/multiplier);
        Textlabel l = (Textlabel)cp5.get("stepToChangeLabel");
        l.setText("Step: " + String.format(java.util.Locale.US,"%.3f", stepToChange));
  }
}

public void addstepToChangeMultiplier(){
  if(multiplier <= 100){
      multiplier = multiplier * 10;
        Textlabel l = (Textlabel)cp5.get("stepToChangeMultiplierLabel");
        l.setText("Mult: " + String.format(java.util.Locale.US,"%.0f", multiplier));
  }
 
}
public void substepToChangeMultiplier(){
  if(multiplier > 10){
      multiplier = multiplier / 10;
        Textlabel l = (Textlabel)cp5.get("stepToChangeMultiplierLabel");
        l.setText("Mult: " + String.format(java.util.Locale.US,"%.0f", multiplier));
  }
}

public void addLeftPointsX(){
  leftPointsX += stepToChange;
    Textlabel l = (Textlabel)cp5.get("leftPointsXLabel");
  l.setText("Left: " + String.format(java.util.Locale.US,"%.1f", leftPointsX));
}
public void subLeftPointsX(){
  if(leftPointsX > 0){
   leftPointsX -= stepToChange; 
     Textlabel l = (Textlabel)cp5.get("leftPointsXLabel");
     l.setText("Left: " + String.format(java.util.Locale.US,"%.1f", leftPointsX));
  }
}

public void addRightPointsX(){
  rightPointsX += stepToChange;
    Textlabel l = (Textlabel)cp5.get("rightPointsXLabel");
  l.setText("Right: " + String.format(java.util.Locale.US,"%.1f", rightPointsX));
}
public void subRightPointsX(){
  if(rightPointsX > 0){
   rightPointsX -= stepToChange; 
     Textlabel l = (Textlabel)cp5.get("rightPointsXLabel");
     l.setText("Right: " + String.format(java.util.Locale.US,"%.1f", rightPointsX));
  }
}

public void addLeftPointsY(){
  leftPointsY += stepToChange;
    Textlabel l = (Textlabel)cp5.get("leftPointsYLabel");
  l.setText("Top: " + String.format(java.util.Locale.US,"%.1f", leftPointsY));
}
public void subLeftPointsY(){
  if(leftPointsY > 0){
   leftPointsY -= stepToChange; 
     Textlabel l = (Textlabel)cp5.get("leftPointsYLabel");
     l.setText("Top: " + String.format(java.util.Locale.US,"%.1f", leftPointsY));
  }
}

public void addRightPointsY(){
  rightPointsY += stepToChange;
    Textlabel l = (Textlabel)cp5.get("rightPointsYLabel");
  l.setText("Down: " + String.format(java.util.Locale.US,"%.1f", rightPointsY));
}
public void subRightPointsY(){
  if(rightPointsY > 0){
   rightPointsY -= stepToChange; 
     Textlabel l = (Textlabel)cp5.get("rightPointsYLabel");
     l.setText("Down: " + String.format(java.util.Locale.US,"%.1f", rightPointsY));
  }
}

public void addLeftPointsZ(){
  leftPointsZ += stepToChange;
    Textlabel l = (Textlabel)cp5.get("leftPointsZLabel");
  l.setText("Front: " + String.format(java.util.Locale.US,"%.1f", leftPointsZ));
}
public void subLeftPointsZ(){
  if(leftPointsZ > 0){
   leftPointsZ -= stepToChange; 
     Textlabel l = (Textlabel)cp5.get("leftPointsZLabel");
     l.setText("Front: " + String.format(java.util.Locale.US,"%.1f", leftPointsZ));
  }
}

public void addRightPointsZ(){
  rightPointsZ += stepToChange;
    Textlabel l = (Textlabel)cp5.get("rightPointsZLabel");
  l.setText("Back: " + String.format(java.util.Locale.US,"%.1f", rightPointsZ));
}
public void subRightPointsZ(){
  if(rightPointsZ > 0){
   rightPointsZ -= stepToChange; 
     Textlabel l = (Textlabel)cp5.get("rightPointsZLabel");
     l.setText("Back: " + String.format(java.util.Locale.US,"%.1f", rightPointsZ));
  }
}
//Kinect object
KinectPV2 kinect;

//Camera object
PeasyCam cam;


//depth img from kinect
PImage img;

//main mesh and single tris
PShape mesh, t;

//max distance to draw triangle
float maxDistance = 10;

//reduce size of point cloud
int cols, rows;
int scl = 1;

float multiplier = 10f;

float stepToChange = 1/multiplier;

float leftPointsX = 2.5f;
float rightPointsX = 2.5f;

float leftPointsY = 3f;
float rightPointsY = 3f;

float leftPointsZ = 2.2f;
float rightPointsZ = 1.7f;

//smooth boiling points
int [] newRawData;
int [] prevRawData; 
int [] smoothData;

int iterationsOfAvg = 4;

ArrayList points;

// GUI Object
ControlP5 cp5;

//Gui variables

PFont font;

boolean camMoveXYToggle = false;
boolean camRotateToggle = true;
boolean camZoomToggle = true;
boolean pointCloudToMesh = false;
  public void settings() {  fullScreen(P3D);  smooth(8); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "kinect_v1" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

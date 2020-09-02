
PVector depthToPointCloudPos(int x, int y, float depthValue) {
  PVector point = new PVector();
  point.z = (depthValue);// / (1.0f); // Convert from mm to meters
  point.x = x;
  point.y = y;
  return point;
}

int avgZofPoint(int iterationsOfAvg, int nD, int pD){
  int temp1 = (nD + pD)/2;   
  int temp2 = 0;
  int t = temp1;
  for(int i = 0; i < iterationsOfAvg-1; i++){
    temp2 = (t + pD)/2;  
    t = temp2;
  }
     
  return temp2;
}

boolean dist(float a, float b, float maxDist){
  
  if(abs(a-b) > maxDist){
    return true;
  }
  return false;
}

public void resetCameraPosition() {
  cam.reset();
}

void cameraToggle(){
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


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

void makeTriangleMesh(){
  meshTM = new TriangleMesh("shape");
   if(radioButtonsVal == 2){
    for(int p = 1; p < points.size()-2; p+=1){
       
       PVector p1 = (PVector)points.get(p-1);
       PVector p2 = (PVector)points.get(p);
       PVector p3 = (PVector)points.get(p+1);
       //PVector p4 = (PVector)points.get(p+2);
       
      if(abs(p3.x - p1.x) > maxDistance) continue;
     
      if(dist(p1.z, p2.z, maxDistance) || dist(p1.z, p3.z, maxDistance) || dist(p2.z, p3.z, maxDistance)){
        continue;
      }
     
      //t = createShape();
      //t.beginShape(TRIANGLE_STRIP);
      //t.fill( lerpColor( color(255,0,0),color(0,0,255),0 ));
      //t.vertex(p1.x, p1.y, p1.z);
      //t.fill( lerpColor( color(255,0,0),color(0,0,255),0 ));
      //t.vertex(p2.x, p2.y, p2.z);
      //t.fill( lerpColor( color(255,0,0),color(0,0,255),0 ));
      //t.vertex(p3.x, p3.y, p3.z);
      //t.endShape();
      
      Vec3D a = new Vec3D(p1.x, p1.y, p1.z);
      Vec3D b = new Vec3D(p2.x, p2.y, p2.z);
      Vec3D c = new Vec3D(p3.x, p3.y, p3.z);
      //mesh.addChild(t);
      
      meshTM.addFace(a, b, c);
      
     // if(abs(p2.x - p3.x) > 1) continue;
     
     // if(dist(p2.z, p3.z, maxDistance) || dist(p2.z, p4.z, maxDistance) || dist(p3.z, p4.z, maxDistance)){
     //   continue;
    ///  }
     
      //t = createShape();
      //t.beginShape(TRIANGLE_STRIP);
      //t.fill( lerpColor( color(255,0,0),color(0,0,255),0 ));
      //t.vertex(p2.x, p2.y, p2.z);
      //t.fill( lerpColor( color(255,0,0),color(0,0,255),0 ));
      //t.vertex(p3.x, p3.y, p3.z);
      //t.fill( lerpColor( color(255,0,0),color(0,0,255),0 ));
      //t.vertex(p4.x, p4.y, p4.z);
      //t.endShape();
      
     // a = new Vec3D(p2.x, p2.y, p2.z);
     // b = new Vec3D(p3.x, p3.y, p3.z);
     // c = new Vec3D(p4.x, p4.y, p4.z);
      //mesh.addChild(t);
      
     // meshTM.addFace(a, b, c);
 
   }
  }else if(radioButtonsVal == 1){
     meshTM = new TriangleMesh("shape");
   for(int p = 1; p < points.size()-2; p+=2){
     PVector p1 = (PVector)points.get(p);
     AABB box = new AABB(0.06 * p1.z/256.0);
     TriangleMesh m = (TriangleMesh) box.toMesh();
     m.translate(p1.x, p1.y, p1.z);
     
     meshTM.addMesh(m);
   }
    
  }
  
   
  // mesh.beginShape(TRIANGLE_STRIP);
  
  // for(int p = 1; p < points.size()-2; p+=2){
  //    PVector p1 = (PVector)points.get(p-1);
  //    PVector p2 = (PVector)points.get(p);
  //    PVector p3 = (PVector)points.get(p+1);
  //    PVector p4 = (PVector)points.get(p+2);
      
  //   mesh.fill( lerpColor( color(255,0,0),color(0,0,255),0 ));
  //   mesh.vertex(p1.x, p1.y, p1.z);
  //   mesh.fill( lerpColor( color(255,0,0),color(0,0,255),0 ));
  //   mesh.vertex(p2.x, p2.y, p2.z);
  //   mesh.fill( lerpColor( color(255,0,0),color(0,0,255),0 ));
  //   mesh.vertex(p3.x, p3.y, p3.z);
     
  //   mesh.fill( lerpColor( color(255,0,0),color(0,0,255),0 ));
  //   mesh.vertex(p3.x, p3.y, p3.z);
  //   mesh.fill( lerpColor( color(255,0,0),color(0,0,255),0 ));
  //   mesh.vertex(p2.x, p2.y, p2.z);
  //   mesh.fill( lerpC( color(255,0,0),color(0,0,255),0 ));
  //   mesh.vertex(p1.x, p1.y, p1.z);

  // }
  //mesh.endShape(); 
}

public void testColorMesh(PGraphics pg, int p){
pg.beginShape(TRIANGLE_STRIP);
      
      aaa.loadPixels();
      
  // for(int p = 1; p < points.size()-2; p+=1){
      PVector p1 = (PVector)points.get(p-1);
      PVector p2 = (PVector)points.get(p);
      PVector p3 = (PVector)points.get(p+1);
      PVector p4 = (PVector)points.get(p+2);
      
      int offsetP2 = (int)p2.x + (int)p2.y * cols;
      
      //int colorIndexP2 = (offsetP2 + (offsetP2 - 1) * 2) - 1;
      
      //float colorIndexP2_raw = map(colorIndexP2, 0 , (cols * rows), 0, (1920 * 1080));
      //println(colorIndexP2_raw);
      
      if(abs(p3.x - p1.x) > maxDistance) return;
     
      if(dist(p1.z, p2.z, maxDistance) || dist(p1.z, p3.z, maxDistance) || dist(p2.z, p3.z, maxDistance)){
       return;
      }
      //int red = abs((int)colorBuffer.get((int)(colorIndexP2_raw - (colorIndexP2_raw % 3))));
      //int green = abs((int)colorBuffer.get((int)(colorIndexP2_raw - (colorIndexP2_raw % 3)+1)));
      //int blue = abs((int)colorBuffer.get((int)(colorIndexP2_raw - (colorIndexP2_raw % 3)+2)));
      
     pg.fill( red(aaa.pixels[offsetP2]), green(aaa.pixels[offsetP2]), blue(aaa.pixels[offsetP2]));
     
     pg.vertex(p1.x, p1.y, p1.z-2000);
     pg.vertex(p2.x, p2.y, p2.z-2000);
     pg.vertex(p3.x, p3.y, p3.z-2000);
     
     
     int offsetP4 = (int)p4.x + (int)p4.y * cols;
      
      
      //float colorIndexP4 = (offsetP4 + (offsetP4 - 1) * 2)-1;
      //float colorIndexP4_raw = map(colorIndexP4, 0 , (cols * rows), 0, (1920 * 1080));

      if(abs(p4.x - p2.x) > maxDistance) return;
     
      if(dist(p2.z, p3.z, maxDistance) || dist(p2.z, p4.z, maxDistance) || dist(p3.z, p4.z, maxDistance)){
       return;
      }


       //red = abs((int)colorBuffer.get((int)(colorIndexP4_raw - (colorIndexP4_raw % 3))));
      // green = abs((int)colorBuffer.get((int)(colorIndexP4_raw- (colorIndexP4_raw % 3)+1)));
       //blue = abs((int)colorBuffer.get((int)(colorIndexP4_raw- (colorIndexP4_raw % 3)+2)));
      
      println(red(aaa.pixels[offsetP4]));
      
     pg.fill( red(aaa.pixels[offsetP4]), green(aaa.pixels[offsetP4]), green(aaa.pixels[offsetP4]));
     pg.vertex(p2.x, p2.y, p2.z-2000);
     pg.vertex(p4.x, p4.y, p4.z-2000);
     pg.vertex(p3.x, p3.y, p3.z-2000);
     
  pg.endShape();
}
public void testColorMesh2(PGraphics pg, int p){
pg.beginShape(TRIANGLE_STRIP);

  // for(int p = 1; p < points.size()-2; p+=1){
      PVector p1 = (PVector)points.get(p-1);
      PVector p2 = (PVector)points.get(p);
      PVector p3 = (PVector)points.get(p+1);
      //PVector p4 = (PVector)points.get(p+2);

      float offsetP3 = p3.x + p3.y * cols;
      
      float colorIndexP3_raw = map(offsetP3, 0 , (cols * rows), 0, (1920 * 1080));
      float colorIndexP3 = (colorIndexP3_raw + (colorIndexP3_raw - 1) * 2);

      if(abs(p3.x - p1.x) > maxDistance) return;
     
      if(dist(p1.z, p2.z, maxDistance) || dist(p1.z, p3.z, maxDistance) || dist(p2.z, p3.z, maxDistance)){
       return;
      }


      int red = abs((int)colorBuffer.get((int)(colorIndexP3 - (colorIndexP3 % 3))) - 255);
      int green = abs((int)colorBuffer.get((int)(colorIndexP3- (colorIndexP3 % 3)+1)) - 255);
      int blue = abs((int)colorBuffer.get((int)(colorIndexP3- (colorIndexP3 % 3)+2)) - 255);
      
     pg.fill( blue, green, red);
     pg.vertex(p1.x, p1.y, p1.z-2000);
     pg.vertex(p3.x, p3.y, p3.z-2000);
     pg.vertex(p2.x, p2.y, p2.z-2000);
     
     //println( " Col1 : " +colorBuffer.get(colorIndexP2) + " " + colorBuffer.get(colorIndexP2) + " " + colorBuffer.get(colorIndexP2));
     
     //if(abs(p2.x - p3.x) > 1) continue;
     
      //if(dist(p3.z, p2.z, maxDistance) || dist(p3.z, p1.z, maxDistance) || dist(p2.z, p1.z, maxDistance)){
     //  continue;
    //  }
    //  if(dist(p3.x, p2.x, maxDistance) || dist(p3.x, p1.x, maxDistance) || dist(p2.x, p1.x, maxDistance)){
    //   continue;
    //  }
     
    // pg.fill( lerpColor( color(255,0,0),color(0,0,255),0 ));
    // pg.vertex(p3.x, p3.y, p3.z);
    // pg.fill( lerpColor( color(255,0,0),color(0,0,255),0 ));
     //pg.vertex(p2.x, p2.y, p2.z);
    // pg.fill( lerpColor( color(255,0,0),color(0,0,255),0 ));
     //pg.vertex(p1.x, p1.y, p1.z);

  // }
  pg.endShape();
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

public void saveObj(){
   record = true; 
}

public void moveXp(){
   Textfield s = (Textfield)cp5.get("moveStepTF");
   String a = s.getText();
   moveObjX += int(a);
}

public void moveXm(){
  Textfield s = (Textfield)cp5.get("moveStepTF");
   String a = s.getText();
   moveObjX -= int(a);
}

public void moveYp(){
  Textfield s = (Textfield)cp5.get("moveStepTF");
   String a = s.getText();
   moveObjY += int(a);
}

public void moveYm(){
  Textfield s = (Textfield)cp5.get("moveStepTF");
   String a = s.getText();
   moveObjY -= int(a); 
}

public void moveZp(){
  Textfield s = (Textfield)cp5.get("moveStepTF");
   String a = s.getText();
   moveObjZ += int(a);
}

public void moveZm(){
  Textfield s = (Textfield)cp5.get("moveStepTF");
   String a = s.getText();
   moveObjZ -= int(a); 
}

public void rotXp(){
  Textfield s = (Textfield)cp5.get("rotStepTF");
   String a = s.getText();
   rotObjX += float(a);
}

public void rotXm(){
  Textfield s = (Textfield)cp5.get("rotStepTF");
   String a = s.getText();
   rotObjX -= float(a); 
}

public void rotYp(){
  Textfield s = (Textfield)cp5.get("rotStepTF");
   String a = s.getText();
   rotObjY += float(a);
}

public void rotYm(){
  Textfield s = (Textfield)cp5.get("rotStepTF");
   String a = s.getText();
   rotObjY -= float(a);
}

public void rotZp(){
  Textfield s = (Textfield)cp5.get("rotStepTF");
   String a = s.getText();
   rotObjZ += float(a);
}

public void rotZm(){
  Textfield s = (Textfield)cp5.get("rotStepTF");
   String a = s.getText();
   rotObjZ -= float(a);
}

public void addPointsButton(){

  if(!pointCloudToMesh){
      for(int i = 0; i < points.size(); i++){
      PVector p = (PVector)points.get(i);
      p.x = p.x + moveObjX;
      p.y = p.y + moveObjY;
      p.z = p.z + moveObjZ;
      oldPoints.add(p);
    }
  }else{
     oldPoints = new ArrayList<PVector>();
  }
}
void controlEvent(ControlEvent theEvent) {
  if(theEvent.isFrom(r)) {
    radioButtonsVal = (int)theEvent.getValue();
  }
}

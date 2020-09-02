
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

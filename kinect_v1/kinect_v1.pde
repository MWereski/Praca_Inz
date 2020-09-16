import nervoussystem.obj.*;

import toxi.audio.*;
import toxi.color.*;
import toxi.color.theory.*;
import toxi.data.csv.*;
import toxi.data.feeds.*;
import toxi.data.feeds.util.*;
import toxi.doap.*;
import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.geom.mesh.subdiv.*;
import toxi.geom.mesh2d.*;
import toxi.geom.nurbs.*;
import toxi.image.util.*;
import toxi.math.*;
import toxi.math.conversion.*;
import toxi.math.noise.*;
import toxi.math.waves.*;
import toxi.music.*;
import toxi.music.scale.*;
import toxi.net.*;
import toxi.newmesh.*;
import toxi.nio.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;
import toxi.physics2d.constraints.*;
import toxi.physics3d.*;
import toxi.physics3d.behaviors.*;
import toxi.physics3d.constraints.*;
import toxi.processing.*;
import toxi.sim.automata.*;
import toxi.sim.dla.*;
import toxi.sim.erosion.*;
import toxi.sim.fluids.*;
import toxi.sim.grayscott.*;
import toxi.util.*;
import toxi.util.datatypes.*;
import toxi.util.events.*;
import toxi.volume.*;

import controlP5.*;

import peasy.*;
import KinectPV2.KJoint;
import KinectPV2.*;

void setup() {
  //main settings
  fullScreen(P3D);
  hint(DISABLE_OPENGL_ERRORS);
  hint(ENABLE_STROKE_PURE);
  //size(800, 600, P3D);
  smooth(8);

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
  cp5.setColorBackground(#4D4D4D);
  cp5.setColorForeground(#34C6B2);
  cp5.setColorValueLabel(#67F9E5);
  
  setSliders();
  setLabelsText();
  setToggles();
  setButtons();
  setTextfields();
  
  cp5.setAutoDraw(false);

  //Kinect settings

  kinect = new KinectPV2(this);

  //Enable point cloud
  kinect.enableDepthImg(true);
  kinect.enablePointCloud(true);

  kinect.init();
  
  //setting first point cloud data
  prevRawData = kinect.getRawDepthData();
  
  oldPoints = new ArrayList<PVector>();
}

void draw() {
  //Background draw
  background(0);
  
 // translate(0, 0, -1800);
  //scaling size of point cloud
  img = kinect.getPointCloudDepthImage();

  int w = img.width;
  int h = img.height;
  
  cols = w / scl;
  rows = h / scl;

  smoothData = new int [cols * rows];

  newRawData = kinect.getRawDepthData();
  //reduce boiling points
  for (int y = int(rows/leftPointsY); y < int(rows-rows/rightPointsY); y++) {
    for (int x = int(cols/leftPointsX); x < int(cols-cols/rightPointsX); x++) {
      int offset = x + y * cols;
      
      int newD = newRawData[offset];
      int prevD = prevRawData[offset];

      int avgD = avgZofPoint(iterationsOfAvg, newD, prevD);
      
      //if(abs(avgD-newD) > 300) avgD = max(newD, prevD) - abs(avgD-newD);
      
      if(abs( newD - prevD) > 650) avgD = 0;
      
      smoothData[offset] = avgD;
      
    }
  }
  points = new ArrayList<PVector>();
  mesh = createShape(GROUP);
  //strokeWeight(2);
  //pushMatrix();
  
  lights();

  for (int y = int(rows/leftPointsY); y < int(rows-rows/rightPointsY);  y++) {
      //beginShape(POINTS);
      //TRIANGLE_STRIP
    for (int x = int(cols/leftPointsX); x < int(cols-cols/rightPointsX); x++) {
      
      int offset = x + y * cols;
      float d =smoothData[offset];
      d = map(d, 0, 4500, 2250, 0);

      if(d > 1000*leftPointsZ) continue;
      if(d < 1000*rightPointsZ) continue;
      
      PVector point1 = depthToPointCloudPos(x, y, d);
      
      //points.add(point1);
      
      int offset2 = x + (y+1) * cols;
      float d2 =smoothData[offset2];
     d2 = map(d2, 0, 4500, 2250, 0);

     // if(d2 > 1000*leftPointsZ) continue;
     //if(d2 < 1000*rightPointsZ) continue;
      
      //PVector point2 = depthToPointCloudPos(x, (y+1), d2);
      
      
      if(abs(d - d2) > 1) continue;
      
      points.add(point1);
      //points.add(point2);
      //vertex(point1.x, point1.y, point1.z);
      //vertex(point2.x, point2.y, point2.z);

    }
      //endShape();
  }
  
  if(pointCloudToMesh){
       makeTriangleMesh();
  }
 // pushMatrix();
  if (record) {
    beginRecord("nervoussystem.obj.OBJExport", "savedObject.obj"); 
  }  
  beginShape(POINTS);
  strokeWeight(1);
  
  
   stroke(#23B5A1);
  fill(#23B5A1, 150);
  for(int i = 0; i < oldPoints.size(); i++){
      PVector p = (PVector)oldPoints.get(i);

      vertex(p.x, p.y, p.z);
  }
  endShape();
  stroke(#FF3B42);
  
  fill(#FF3B42, 150);

  
  rotateX(rotObjX);
  rotateY(rotObjY);
  rotateZ(rotObjZ);
//box(100, 100, 100);
  translate(moveObjX, moveObjY, moveObjZ);
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


  if (record) {
    endRecord();
    record = false;
  }
  
 // popMatrix();
  
  prevRawData = smoothData;
     
   cameraToggle();
   
   gui();

}

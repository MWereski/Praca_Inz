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

void draw() {
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
  for (int y = int(rows/leftPointsY); y < int(rows-rows/rightPointsY); y++) {
    for (int x = int(cols/leftPointsX); x < int(cols-cols/rightPointsX); x++) {
      int offset = x + y * cols;
      
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
  stroke(#23B5A1);
  fill(#23B5A1, 150);
  
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
      
     // points.add(point1);
      
      int offset2 = x + (y+1) * cols;
      float d2 =smoothData[offset2];
      d2 = map(d2, 0, 4500, 2250, 0);

      if(d2 > 1000*leftPointsZ) continue;
      if(d2 < 1000*rightPointsZ) continue;
      
      PVector point2 = depthToPointCloudPos(x, (y+1), d2);
      
      
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
  if (record) {
    beginRecord("nervoussystem.obj.OBJExport", "savedObject.obj"); 
    saveZ = 1500;
  }  
  if(pointCloudToMesh)
  {
    shape(mesh);
  }else{
    beginShape(POINTS);
    for(int i = 0; i < points.size(); i++){
      PVector p = (PVector)points.get(i);
      vertex(p.x, p.y, p.z-saveZ);
  }
    
   endShape();
  }

  if (record) {
    endRecord();
    record = false;
    saveZ = 0;
  }
  
 // popMatrix();
  
  prevRawData = smoothData;
     
   cameraToggle();
   
   gui();

}

void keyPressed() {
  if (key == 's') {
    record = true;
  }
}

import peasy.*;
import KinectPV2.KJoint;
import KinectPV2.*;

void setup() {
  //main settings
  //fullScreen(P3D);
  size(800, 600, P3D);
  //smooth(8);

  //Camera settings
  cam = new PeasyCam(this, CameraParams.cx, CameraParams.cy, CameraParams.cz, CameraParams.doubleDist);
  
  cam.rotateX(CameraParams.k1);   
  cam.rotateY(CameraParams.k2); 
  cam.rotateZ(CameraParams.k3);

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
  //scaling size of point cloud
  img = kinect.getPointCloudDepthImage();

  int w = img.width;
  int h = img.height;
  
  cols = w / scl;
  rows = h / scl;

  smoothData = new int [cols * rows];

  newRawData = kinect.getRawDepthData();
  //reduce boiling points
  for (int y = rows/3; y < rows-rows/3; y++) {
    for (int x = int(cols/2.5f); x < int(cols-cols/2.5f); x++) {
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
  stroke(255);
  fill(255, 0, 0, 50);

  for (int y = rows/3; y < rows-rows/3; y++) {
      //beginShape(POINTS);
      //TRIANGLE_STRIP
    for (int x = int(cols/2.5f); x < int(cols-cols/2.5f); x++) {
      
      int offset = x*scl + y*scl * w;
      float d =smoothData[offset];
      d = map(d, 0, 4500, 2250, 0);

      if(d > 2200) continue;
      if(d < 1700) continue;
      
      PVector point1 = depthToPointCloudPos(x*scl, y*scl, d);
      
     // points.add(point1);
      
      int offset2 = x*scl + (y+1)*scl * w;
      float d2 =smoothData[offset2];
      d2 = map(d2, 0, 4500, 2250, 0);

      if(d2 > 2200) continue;
      if(d2 < 1700) continue;
      
      PVector point2 = depthToPointCloudPos(x*scl, (y+1)*scl, d2);
      
      
      if(abs(d - d2) > 1) continue;
      
      points.add(point1);
      points.add(point2);
      //vertex(point1.x, point1.y, point1.z);
      //vertex(point2.x, point2.y, point2.z);

    }
      //endShape();
  }
  
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
 // pushMatrix();
  
  shape(mesh);
  
 // popMatrix();
  
  prevRawData = smoothData;


}

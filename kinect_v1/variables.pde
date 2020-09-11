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

int moveObjX = -325;
int moveObjY = -208;
int moveObjZ = -2000;

float rotObjX = 0f;
float rotObjY = 0f;
float rotObjZ = 0f;

float multiplier = 10f;

float stepToChange = 1/multiplier;

float leftPointsX = 2.7f;
float rightPointsX = 3.7f;

float leftPointsY = 3f;
float rightPointsY = 3f;

float leftPointsZ = 2.0f;
float rightPointsZ = 1.9f;

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

boolean record = false;

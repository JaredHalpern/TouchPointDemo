import processing.opengl.*;
import SimpleOpenNI.*;
SimpleOpenNI kinect;
float rotation = 0;
// set the box size
int boxSize = 150; //1
// a vector holding the center of the box 
PVector boxCenter = new PVector(0, 0, 600); // 2

// zooming
float s = 1;

void setup() {
  size(1024, 768, OPENGL);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
}

void draw() {
    
  background(0);
  kinect.update();
  translate(width/2, height/2, -1000); //3 
  rotateX(radians(180));
  
  translate(0, 0, 1400);
  rotateY(radians(map(mouseX, 0, width, -180, 180)));
  
  // zoom in
  translate(0,0,s*-1000);
  scale(s);
  println(s);
  stroke(255);
  
  PVector[] depthPoints = kinect.depthMapRealWorld();
  
  // points found in box in this frame
  int depthPointsInBox = 0;

for (int i = 0; i < depthPoints.length; i+=10) {
    PVector currentPoint = depthPoints[i];
    
  // The nested if statements inside of our loop //2 
  if (currentPoint.x > boxCenter.x - boxSize/2
          && currentPoint.x < boxCenter.x + boxSize/2)
      {
        if (currentPoint.y > boxCenter.y - boxSize/2
            && currentPoint.y < boxCenter.y + boxSize/2)
        {
          if (currentPoint.z > boxCenter.z - boxSize/2
              && currentPoint.z < boxCenter.z + boxSize/2)
          {
            depthPointsInBox++;
          }
        } 
      }

    point(currentPoint.x, currentPoint.y, currentPoint.z);
}

  println(depthPointsInBox);
  
  // set the box color's transparency
  // 0 is transparent, 1000 points is fully opaque red
  float boxAlpha = map(depthPointsInBox, 0, 1000, 0, 255); // 3
  translate(boxCenter.x, boxCenter.y, boxCenter.z);

  // the fourth argument to fill() is "alpha"
  // it determines the color's opacity
  // we set it based on the number of points
  fill(255, 0, 0, boxAlpha);
  stroke(255, 0, 0);
  box(boxSize);
}

// use keys to control zoom
// up-arrow zooms in
// down arrow zooms out
// s gets passed to scale() in draw() 
void keyPressed(){ //4
  if(keyCode == 38){
    s = s + 0.01;
  }

if(keyCode == 40){
        s = s - 0.01;
  } 
}

void mousePressed(){
      save("touchedPoint.png");
}

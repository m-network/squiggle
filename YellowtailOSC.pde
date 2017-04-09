/**
 * Yellowtail
 * by Golan Levin (www.flong.com). 
 * 
 * Click, drag, and release to create a kinetic gesture.
 * 
 * Yellowtail (1998-2000) is an interactive software system for the gestural 
 * creation and performance of real-time abstract animation. Yellowtail repeats 
 * a user's strokes end-over-end, enabling simultaneous specification of a 
 * line's shape and quality of movement. Each line repeats according to its 
 * own period, producing an ever-changing and responsive display of lively, 
 * worm-like textures.
 */


import java.awt.Polygon;

Gesture gestureArray[];
final int nGestures = 36;  // Number of gestures
final int minMove = 3;     // Minimum travel for a new point
int currentGestureID;

Polygon tempP;
int tmpXp[];
int tmpYp[];
PImage bg_img;
PFont font;
boolean add1stMessage;
boolean add2ndMessage;
boolean add1stPhoto;
boolean add2ndPhoto;

void settings()
{
  //fullScreen();
  size(2880, 1800, P2D);
}

void setup() {
  bg_img = loadImage("../assets/mycelial/fullSlider_cropped3.png");
  background(bg_img);
  noStroke();
  oscSetup();
  currentGestureID = -1;
  gestureArray = new Gesture[nGestures];
  for (int i = 0; i < nGestures; i++) {
    gestureArray[i] = new Gesture(width, height);
  }
  clearGestures();
  font = loadFont("BlowBrush-48.vlw");
  textFont(font, 32);
}


void draw() {
  background(bg_img);

  updateGeometry();
  fill(0,0,0);
  for (int i = 0; i < nGestures; i++) {
    renderGesture(gestureArray[i], width, height);
  }
  drawChat();
  drawImages();
}

void drawImages()
{
  PImage p1;
  PImage p2;
  PImage p3;
  PImage p4;
  PImage p5;
  
  p1 = loadImage("../assets/mycelial/selfies/01.jpg");
  p2 = loadImage("../assets/mycelial/selfies/02.jpg");
  p3 = loadImage("../assets/mycelial/selfies/03.jpg");
  p4 = loadImage("../assets/mycelial/selfies/04.jpg");
  p5 = loadImage("../assets/mycelial/selfies/05.jpg");
  
  pushMatrix();
  translate(200,0);
  pushMatrix();
  translate(50,95);
  rotate(-.1);
  tint(255,100);
  image(p1, 0, 0);
  popMatrix();
  pushMatrix();
  translate(110,695);
  rotate(.2);
  tint(255,130);
  image(p2, 0, 0);
  popMatrix();
  pushMatrix();
  translate(1070,795);
  rotate(-.5);
  tint(255,160);
  image(p3, 0, 0);
  popMatrix();
            if(add1stPhoto)
            {
              pushMatrix();
              translate(480,795);
              rotate(-.03);
  tint(255,200);
  image(p4, 0, 0);
              popMatrix();
            }
            if(add2ndPhoto)
            {
              pushMatrix();
              translate(1280,10);
              rotate(.1);
  tint(255,230);
  image(p5, 0, 0);
              popMatrix();
            }
              popMatrix();
}

void drawChat()
{
  
            int posX = 200;
            int posY = 230;
            pushMatrix();
            translate(400,150);
    stroke(0);
            fill(128,0,0,70);
            textAlign(LEFT);
            textSize(36);
            text("        Bob: Why aren't people more angry?", posX, posY);
            pushMatrix();
            translate(0,95);
            rotate(-.1);
            fill(0,128,0,100);
            text("        Sam: Maybe because they are afraid...", posX, posY);
            popMatrix();
            pushMatrix();
            translate(-5,90);
            rotate(.05);
            fill(0,0,200,130);
            text("        Beth: all that is happening makes me sad :(", posX, posY);
            popMatrix();
            pushMatrix();
            translate(-25,160);
            rotate(.01);
            fill(0,0,0,160);
            text("        Rebecca: I simply do not understand", posX, posY);
            popMatrix();
            if(add1stMessage)
            {
              pushMatrix();
              translate(25,230);
              rotate(-.03);
              fill(128,128,0,190);
              text("        James: what r u talking about?", posX, posY);
              popMatrix();
            }
            if(add2ndMessage)
            {
              pushMatrix();
              translate(25,235);
              rotate(.02);
              fill(0,128,0,220);
              text("        toneguy: i remain confused", posX, posY);
              popMatrix();
            } 
            popMatrix();
}

void mousePressed() {
  currentGestureID = (currentGestureID+1) % nGestures;
  Gesture G = gestureArray[currentGestureID];
  G.clear();
  G.clearPolys();
  G.addPoint(mouseX, mouseY);
}


void mouseDragged() {
  if (currentGestureID >= 0) {
    Gesture G = gestureArray[currentGestureID];
    if (G.distToLast(mouseX, mouseY) > minMove) {
      G.addPoint(mouseX, mouseY);
      G.smooth();
      G.compile();
    }
  }
}


void keyPressed() {
  if (key == '+' || key == '=') {
    if (currentGestureID >= 0) {
      float th = gestureArray[currentGestureID].thickness;
      gestureArray[currentGestureID].thickness = min(96, th+1);
      gestureArray[currentGestureID].compile();
    }
  } else if (key == '-') {
    if (currentGestureID >= 0) {
      float th = gestureArray[currentGestureID].thickness;
      gestureArray[currentGestureID].thickness = max(2, th-1);
      gestureArray[currentGestureID].compile();
    }
  } else if (key == ' ') {
    clearGestures();
  } else if (key == '1') {
    add1stMessage = true;
  }else if (key == '2') {
    add2ndMessage = true;
  } else if (key == '3') {
    add1stPhoto = true;
  }else if (key == '4') {
    add2ndPhoto = true;
  }
}


void renderGesture(Gesture gesture, int w, int h) {
  if (gesture.exists) {
    if (gesture.nPolys > 0) {
      Polygon polygons[] = gesture.polygons;
      int crosses[] = gesture.crosses;

      int xpts[];
      int ypts[];
      Polygon p;
      int cr;

      beginShape(QUADS);
      int gnp = gesture.nPolys;
      for (int i=0; i<gnp; i++) {

        p = polygons[i];
        xpts = p.xpoints;
        ypts = p.ypoints;

        vertex(xpts[0], ypts[0]);
        vertex(xpts[1], ypts[1]);
        vertex(xpts[2], ypts[2]);
        vertex(xpts[3], ypts[3]);

        if ((cr = crosses[i]) > 0) {
          if ((cr & 3)>0) {
            vertex(xpts[0]+w, ypts[0]);
            vertex(xpts[1]+w, ypts[1]);
            vertex(xpts[2]+w, ypts[2]);
            vertex(xpts[3]+w, ypts[3]);

            vertex(xpts[0]-w, ypts[0]);
            vertex(xpts[1]-w, ypts[1]);
            vertex(xpts[2]-w, ypts[2]);
            vertex(xpts[3]-w, ypts[3]);
          }
          if ((cr & 12)>0) {
            vertex(xpts[0], ypts[0]+h);
            vertex(xpts[1], ypts[1]+h);
            vertex(xpts[2], ypts[2]+h);
            vertex(xpts[3], ypts[3]+h);

            vertex(xpts[0], ypts[0]-h);
            vertex(xpts[1], ypts[1]-h);
            vertex(xpts[2], ypts[2]-h);
            vertex(xpts[3], ypts[3]-h);
          }

          // I have knowingly retained the small flaw of not
          // completely dealing with the corner conditions
          // (the case in which both of the above are true).
        }
      }
      endShape();
    }
  }
}

void updateGeometry() {
  Gesture J;
  for (int g=0; g<nGestures; g++) {
    if ((J=gestureArray[g]).exists) {
      if (g!=currentGestureID) {
        advanceGesture(J);
      } else if (!mousePressed) {
        advanceGesture(J);
      }
    }
  }
}

void advanceGesture(Gesture gesture) {
  // Move a Gesture one step
  if (gesture.exists) { // check
    int nPts = gesture.nPoints;
    int nPts1 = nPts-1;
    Vec3f path[];
    float jx = gesture.jumpDx;
    float jy = gesture.jumpDy;

    if (nPts > 0) {
      path = gesture.path;
      for (int i = nPts1; i > 0; i--) {
        path[i].x = path[i-1].x;
        path[i].y = path[i-1].y;
      }
      path[0].x = path[nPts1].x - jx;
      path[0].y = path[nPts1].y - jy;
      gesture.compile();
    }
  }
}

void clearGestures() {
  for (int i = 0; i < nGestures; i++) {
    gestureArray[i].clear();
  }
}
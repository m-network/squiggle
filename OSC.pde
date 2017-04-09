import netP5.*;
import oscP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

String ip = "10.0.1.17";
int port = 12002;
boolean flag = false;

void oscSetup(){
  oscP5 = new OscP5(this,port);
  oscP5.plug(this,"incoming","/squiggle");
}

void incoming(int user, String msg){
  flag = true;
  currentGestureID = (currentGestureID+1) % nGestures;
  Gesture G = gestureArray[user];
  G.clear();
  G.clearPolys();
  println("Recieved message from "+user);
  String[] coords = msg.split(",");
  
  for(int i = 0; i<coords.length; i++){ 
    int space = coords[i].indexOf(' ');
    float x = parseFloat(coords[i].substring(0,space).trim())*width;
    float y = parseFloat(coords[i].substring(space).trim())*height;
    G.addPoint(x, y);
    if(i>0){
      G.smooth();
      G.compile();
    }
  }
  flag = false;
}
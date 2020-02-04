class Spine {
  int id;
  
  float x,y;
  float xx,yy;
  
  float step;
  
  float theta;
  float thetav;
  float thetamax;
  float time;
  
  int depth = 1;
  float[] t = new float[depth];
  float[] amp = new float[depth];
  
  color myc;

  Spine(int Id) {
    id = Id;
    init();
  }
  
  void init() {
    step = random(2.0,7.3);
    thetamax = 0.1;
    theta = random(TWO_PI);
    for (int n=0;n<depth;n++) {
      amp[n] = random(0.01,0.3);
      t[n] = random(0.01,0.2);
    }
    myc = #FFFFFF;//somefcolor();
  }
  
  void setPosition(float X, float Y) {
    x = X;
    y = Y;
  }
  
  void setTheta(float T) {
    theta = T;
  }
  
  void traceInto(float MT) {
    // skip into the future
    for (time=random(MT);time<MT*2;time+=random(0.1,2.0)) {
      grow();
    }
  }

  void grow() {
    // save last position
    xx = x;
    yy = y;
    
    // calculate new position
    x+=step*cos(theta);
    y+=step*sin(theta);
    
    // rotational meander
    float thetav = 0.0;
    for (int n=0;n<depth;n++) {
      thetav+=amp[n]*sin(time*t[n]);
      amp[n]*=0.9998;
      t[n]*=0.998;
    }
    
    step*=1.005;
//    step*=0.995;
//    step+=0.01;
    theta+=thetav;
    
    // render    
    render();
    
    // randomly choose to place a node
    if (random(1000)<200) {
      // mass of node is constrained by time
      float m = random(5,15+1000/(1+time));
      makeNode(x,y,m);
    }
  }  
  
  void render() {
    // shadow
    stroke(0,34);
    line(x+1,y+1,xx+1,yy+1);
    // highlight
    stroke(255,64);
    line(x-1,y-1,xx-1,yy-1);
    // color center
    //stroke(myc,73);
    //line(x,y,xx,yy);
  }
}

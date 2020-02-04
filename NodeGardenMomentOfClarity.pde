// Node Garden: Moment of Clarity
//   Jared S Tarbell
//   February 3, 2020
//   Albuquerque, New Mexico
//
// Processing 3.5.3
//
// Based off old sketch from 2004
//   http://www.complexification.net/gallery/machines/nodeGarden/

int numSpines;          // actual number of spines
int maxSpines = 222;    // maximum number of spines, adjust this for more or less complexity
int numNodes;           // actual number of nodes
int maxNodes = 10000;   // maximum number of nodes

// node drawing images
PImage nodeIcoDark;
PImage nodeIcoSpec;
PImage nodeIcoBase;

// collection of nodes
GNode[] gnodes;

// collection of spines
Spine[] spines;

// some flourescent colors
color[] fColor = {#ff9966, #ccff00, #ff9933, #ff00cc, #ee34d3, #4fb4e5, #abf1cf, #ff6037, #ff355e, #66ff66, #ffcc33, #ff6eff, #ffff66, #fd5b78};

// color gradient
color amyc, bmyc;

// render flag
boolean doRender = true;

// zooming and panning
float scale;
float focusX, focusY;

void setup() {
  //size(1400,1400);
  fullScreen();
  background(0);
  
  // load node images   
  nodeIcoDark = loadImage("nodeXlgDarkAlpha.png");
  nodeIcoSpec = loadImage("nodeXlgSpecular3Alpha.png");
  nodeIcoBase = loadImage("nodeXlgBaseAlpha.png");
  
  // create all nodes
  gnodes = new GNode[maxNodes];
  
  // create all spines
  spines = new Spine[maxSpines];
  
  // set default view
  scale = 1.0;
  focusX = width/2;
  focusY = height/2;

}

void draw() {
  // calculate view size and position (for zooming and panning)
  float fx = -(focusX-width/2)*scale;
  float fy = -(focusY-height/2)*scale;
  translate(width/2-width*scale/2+fx,height/2-height*scale/2+fy);
  scale(scale);
  //strokeWeight(1.0/scale);
  
  if (doRender) generate();      // if the render flag is up, make a node garden
}

void generate() {
  // keep track of total generation time
  int startMs = millis();
  
  // go baby
  init();
      
  // randomly connect all nodes
  for (int n=0;n<numNodes*5;n++) {
    int i = (int)random(numNodes);
    gnodes[i].findNearConnection();
  }
  
  // remove obscured nodes
  for (int n=0;n<numNodes;n++) gnodes[n].calcHidden();
  
  // draw all gnodes
  for (int n=0;n<numNodes;n++) gnodes[n].drawNodeDark();
  
  // draw all connections
  blendMode(SCREEN);
  for (int n=0;n<numNodes;n++) gnodes[n].drawConnections();
  blendMode(BLEND);
  
  // decorate gnodes
  for (int n=0;n<numNodes;n++) gnodes[n].drawNodeBase();
  
  // draw the specular highlights
  for (int n=0;n<numNodes;n++) gnodes[n].drawNodeSpecular();
  
  // done, report render time
  int ms = millis()-startMs;
  println("Done in "+ms+"ms");  
  
  doRender = false;    // wait for prompt before generating another again
}

// initialize and build a composition
void init() {
  background(32);  
  // reset object counters
  numSpines = 0;
  numNodes = 0;

  // randomize composition colors
  amyc = somefcolor();
  bmyc = somefcolor();

  // make some spine objects (nodes autogrow on spines)
  makeSpineLine();
  
  //makeSpineLines();
  
  //float r = .17*height;
  //makeSpineRing(r);
  
}

void makeSpineLine() {
  // arrange spines in line
  for (int i=0;i<maxSpines;i++) {
    float x = width/4 + i*width/(maxSpines-1);
    float y = height/2;
    float mt = random(11,140); 
    makeSpine(x,y,-HALF_PI,mt);
    makeSpine(x,y,HALF_PI,mt);
  }
}
 
void makeSpineLines() {
  // arrange spines in two lines
  for (int i=0;i<maxSpines;i++) {
    float mt = random(11,140); 
    float x = map(i,0,maxSpines,0,width);
    if (i%2==0) {
      makeSpine(x,height*.1,HALF_PI,mt);
    } else {
      makeSpine(x,height*.9,-HALF_PI,mt);
    }
  }
}
  
void makeSpineRing(float r) {
  // arrange spines in circle
  for (int i=0;i<maxSpines;i++) {
    float a = TWO_PI*i/(maxSpines-1);
    float x = width/2 + r*cos(a);
    float y = height/2 + r*sin(a);
    float mt = random(11,140); 
    makeSpine(x,y,a,mt);
  }
}

void makeNode(float X, float Y, float M) {
  if (numNodes<maxNodes) {
    gnodes[numNodes] = new GNode(numNodes);
    gnodes[numNodes].setPosition(X,Y);
    gnodes[numNodes].setMass(M);
    numNodes++;
  }
}

void makeSpine(float X, float Y, float T, float MTime) {
  if (numSpines<maxSpines) {
    spines[numSpines] = new Spine(numSpines);
    spines[numSpines].setPosition(X,Y);
    spines[numSpines].setTheta(T);
    spines[numSpines].traceInto(MTime);
    numSpines++;
  }
}

color somefcolor() {
  // return some random color from the palette
  return fColor[int(random(fColor.length))];
}

color blendfcolor() {
  // randomly switch up selected colors
  if (random(10000)<2) amyc = somefcolor();
  if (random(10000)<2) bmyc = somefcolor();
  
  // return a blended color somewhere between two currently selected colors
  float t = random(1.0);
  float r = red(amyc) + (red(bmyc)-red(amyc))*t;
  float g = green(amyc) + (green(bmyc)-green(amyc))*t;
  float b = blue(amyc) + (blue(bmyc)-blue(amyc))*t;
  color c = color(r,g,b);
  return c;
}


void mousePressed() {
}

void keyPressed() {
  if (key==' ') {
    // press spacebar to make a new composition
    scale = 1.0;
    focusX = width/2;
    focusY = height/2;
    doRender = true;
  }
}

class GNode {
  int id;
  float x, y;
  float mass;

  // connections
  int numcons;
  int maxcons = 11;
  int[] cons;
  
  boolean hidden;
  
  color myc;
      
  GNode(int Id) {
    // set identification number
    id = Id;
    // create connection list
    cons = new int[maxcons];
    // initialize one time
    initSelf();
  }

  void initSelf() { 
    // initialize connections
    initConnections();
    // pick color
    myc = somefcolor();
    hidden = false;
  }
  
  void initConnections() {
    // set number of connections to zero
    numcons=0;
  }
  
  void calcHidden() {
    // determine if hidden by larger gnode
    for (int n=0;n<numNodes;n++) {
      if (n!=id) {
        if (gnodes[n].mass>mass) {
          float d = dist(x,y,gnodes[n].x,gnodes[n].y);
          if (d<abs(mass*0.321-gnodes[n].mass*0.321)) {
            hidden = true;
          }
        }
      }
    }
  }
  
  void setPosition(float X, float Y) {
    // position self
    x=X;
    y=Y;
  }
  
  void setMass(float Sz) {
    // set size
    mass=Sz;
  }
   
  void findRandomConnection() {
    // check for available connection element
    if ((numcons<maxcons) && (numcons<mass)) {
      // pick other gnode at large
      int cid = int(random(numNodes));
      if (cid!=id) {
        cons[numcons]=cid;
        numcons++;
//        println(id+" connected to "+cid);
      } else {
        // random connection failed
      }
    } else {
      // no connection elements available
    }
  }
  
  void findNearConnection() {
    // find closest node
    if ((numcons<maxcons) && (numcons<mass)) {
      // sample 5% of nodes for near connection
      float dd = width;
      int dcid = -1;
      for (int k=0;k<(numNodes/20);k++) {
        int cid = int(random(numNodes-1));
        float d = sqrt((x-gnodes[cid].x)*(x-gnodes[cid].x)+(y-gnodes[cid].y)*(y-gnodes[cid].y));
        if ((d<dd) && (d<mass*6)) {
          // closer gnode has been found
          dcid = cid;
          dd = d;
        }
      }
    
      if (dcid>=0) {
        // close node has been found, connect to it
        connectTo(dcid);
      }
    }
  }

  void connectTo(int Id) {
    if (numcons<maxcons) {
      boolean duplicate = false;
      for (int n=0;n<numcons;n++) {
        if (cons[n]==Id) {
          duplicate = true;
        }
      }
      if (!duplicate) {
        cons[numcons]=Id;
        numcons++;  
      }
    }
  }
                         
  void drawNodeDark() {
    // stamp node icon down
    if (!hidden) {
      float half_mass = mass/2;
      //blend(nodeIcoDark,0,0,nodeIcoDark.width,nodeIcoDark.height,int(x-half_mass),int(y-half_mass),int(mass),int(mass),DARKEST);
      blendMode(MULTIPLY);
      //tint(255,192);
      noTint();
      image(nodeIcoDark,x-half_mass,y-half_mass,mass,mass);
      blendMode(BLEND);
    }
  }

  void drawNodeSpecular() {
    // stamp node specular
    if (!hidden) {
      float m = mass*.618;
      float hm = m/2;
      //blend(nodeIcoSpec,0,0,nodeIcoSpec.width,nodeIcoSpec.height,int(x-half_mass),int(y-half_mass),int(mass),int(mass),LIGHTEST);
      blendMode(SCREEN);
      noTint();
      image(nodeIcoSpec,x-hm,y-hm,m,m);
      blendMode(BLEND);
    }
  }

  void drawNodeBase() {
    // stamp node base
    if (!hidden) {
      float m = mass;
      float hm = m/2;
      //blend(nodeIcoBase,0,0,nodeIcoBase.width,nodeIcoBase.height,int(x-half_mass),int(y-half_mass),int(mass),int(mass),DARKEST);  
      blendMode(MULTIPLY);
      tint(255,128);
      image(nodeIcoBase,x-hm,y-hm,m,m);
      blendMode(BLEND);
    }
  }
      
                  
  void drawConnections() {
    for (int n=0;n<numcons;n++) {
      // colored line for connections
      stroke(blendfcolor(),88);
      line(x,y,gnodes[cons[n]].x,gnodes[cons[n]].y);
      
      // little points of light at the tips
      stroke(255,128);
      point(x,y);
      point(gnodes[cons[n]].x,gnodes[cons[n]].y);
    }   
  }  
}

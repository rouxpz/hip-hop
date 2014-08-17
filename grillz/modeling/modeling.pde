import unlekker.mb2.geo.*;
import unlekker.mb2.util.*;
import ec.util.*;
import geomerative.*;
import org.apache.batik.svggen.font.table.*;
import org.apache.batik.svggen.font.*;

RShape[] frame = new RShape[4];
RPolygon[] pframe = new RPolygon[4];

UVertexList[] vl = new UVertexList[9];
UGeo geo;
UNav3D nav;

boolean flat = false;

void setup() {

  //initialization
  size(300, 300, P3D);
  UMB.setPApplet(this);
  nav = new UNav3D();
  smooth();
  RG.init(this);

  //load SVGs
  for (int i = 0; i < 4; i++) {
    frame[i] = RG.loadShape("vl" + i + ".svg");
    //println("loaded frame" + i);
  }

  buildFrame();
  addRandomData();
}

void draw() {
  background(150);
  lights();
  nav.doTransforms();

  stroke(240);
  fill(100);
  geo.draw();

  stroke(255, 0, 0);
  geo.drawNormals(10);
}

void buildFrame() {

  float diff;
  
  //build the uniform frame for the grill
  for (int i = 0; i < 4; i++) {
    int curveLength = int(frame[i].getCurveLengths()[0]);
    //println(curveLength);
    RCommand.setSegmentator(RG.UNIFORMSTEP);
    if (i < 1 || i > 2) {
      RCommand.setSegmentStep(45);
      pframe[i] = frame[i].toPolygon();

      vl[i] = new UVertexList();
      for (int j = 0; j < pframe[i].contours[0].points.length-1; j++) {
        //println(pframe[i].contours[0].points.length);
        RPoint fp = pframe[i].contours[0].points[j];
        vl[i].add(new UVertex(fp.x, fp.y, 0));
      }
    } else {
      RCommand.setSegmentStep(30);
      pframe[i] = frame[i].toPolygon();

      vl[i] = new UVertexList();
      for (int j = pframe[i].contours[0].points.length-1; j > 0; j--) {
        //println(pframe[i].contours[0].points.length);
        RPoint fp = pframe[i].contours[0].points[j];
        vl[i].add(new UVertex(fp.x, fp.y, 0));
      }
    }

    println(vl[i].size());
  }

  //n3xt l3v3l UVertexLists
  vl[3].translate(0, 0, 5);
  vl[4] = vl[2].copy().translate(0, 0, 10);
  vl[5] = vl[1].copy().translate(0, 0, 10);
  vl[7] = vl[2].copy().translate(0, 0, 5);
  
  //shaping the top into a "mouth-friendly" form
  vl[6] = new UVertexList();
  for (int i = 0; i < vl[3].size(); i++) {
      if (i < 44) {
      diff = vl[3].get(i).z + 0.7*i;
    } else if (i > 48) {
      diff = vl[3].get(i).z + 0.7*(92-i);
    } else {
      diff = vl[3].get(43).z + 31.5;
    }
    
    UVertex nv = new UVertex(vl[3].get(i).x, vl[3].get(i).y, diff);    
    vl[6].add(nv);
  }

  //adding dem faces
  geo = new UGeo().quadstrip(vl[1], vl[0]);
  geo.quadstrip(vl[7], vl[4]).quadstrip(vl[4], vl[5]).quadstrip(vl[5], vl[1]).quadstrip(vl[3], vl[7]).quadstrip(vl[3], vl[6]);
  geo.addFace(vl[3].first(), vl[0].first(), vl[6].first()).addFace(vl[0].first(), vl[3].first(), vl[7].first()).addFace(vl[1].first(), vl[0].first(), vl[7].first()).addFace(vl[1].first(), vl[7].first(), vl[5].first()).addFace(vl[5].first(), vl[7].first(), vl[4].first());
  geo.addFace(vl[6].last(), vl[0].last(), vl[3].last()).addFace(vl[7].last(), vl[3].last(), vl[0].last()).addFace(vl[7].last(), vl[0].last(), vl[1].last()).addFace(vl[5].last(), vl[7].last(), vl[1].last()).addFace(vl[4].last(), vl[7].last(), vl[5].last());
}

void addRandomData() {

  //add random data to make the front into a landscape
  vl[8] = new UVertexList();

  for (UVertex v : vl[0]) { 
    
    int randomX;
    int randomY;
    
    randomY = round(random(-20, 0));
    
    if (v.x <= vl[0].get(46).x) {
      randomX = round(random(-20, 0));
    } else {
      randomX = round(random(0, 20));
    }

    UVertex nv = new UVertex(v.x + randomX, v.y + randomY, v.z);
    vl[8].add(nv);
  }

  vl[8].translate(0, 0, 15);
  geo.quadstrip(vl[6], vl[8]).quadstrip(vl[8], vl[0]);
  geo.addFace(vl[0].first(), vl[8].first(), vl[6].first()).addFace(vl[6].last(), vl[8].last(), vl[0].last());
}

void addRealData() {
  //nothing here yet stay tuned
  
}

void keyPressed() {

  //write to STL file 
  if (key == 's') {
    geo.writeSTL("testv2.stl");
  }
}


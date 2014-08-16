import unlekker.mb2.geo.*;
import unlekker.mb2.util.*;
import ec.util.*;
import geomerative.*;
import org.apache.batik.svggen.font.table.*;
import org.apache.batik.svggen.font.*;

RShape[] frame = new RShape[4];
RPolygon[] pframe = new RPolygon[4];

UVertexList[] vl = new UVertexList[10];
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
}

void draw() {
  background(150);
  lights();
  nav.doTransforms();

  stroke(240);
  geo.draw();
  for (int i = 0; i < 4; i++) {
    //vl[i].draw();
    //println("loaded frame" + i);
  }
}

void buildFrame() {
  
  //build the uniform frame for the grill
  for (int i = 0; i < 4; i++) {
    int curveLength = int(frame[i].getCurveLengths()[0]);
    //println(curveLength);
    RCommand.setSegmentator(RG.UNIFORMSTEP);
    if (i < 1 || i > 2) {
      RCommand.setSegmentStep(45);
      pframe[i] = frame[i].toPolygon();
      //pframe[i].addClose();

      vl[i] = new UVertexList();
      for (int j = 0; j < pframe[i].contours[0].points.length-1; j++) {
        //println(pframe[i].contours[0].points.length);
        RPoint fp = pframe[i].contours[0].points[j];
        vl[i].add(new UVertex(fp.x, fp.y, 0));
      }
    } else {
      RCommand.setSegmentStep(30);
      pframe[i] = frame[i].toPolygon();
      //pframe[i].addClose();

      vl[i] = new UVertexList();
      for (int j = pframe[i].contours[0].points.length-1; j > 0; j--) {
        //println(pframe[i].contours[0].points.length);
        RPoint fp = pframe[i].contours[0].points[j];
        vl[i].add(new UVertex(fp.x, fp.y, 0));
      }
    }

    println(vl[i].size());
  }

  //reverse(vl[1]);
  vl[6] = vl[3].copy().translate(0, 0, 20);
  vl[3].translate(0, 0, 5);
  vl[4] = vl[2].copy().translate(0, 0, 10);
  vl[5] = vl[1].copy().translate(0, 0, 10);
  vl[7] = vl[2].copy().translate(0, 0, 5);
  geo = new UGeo().quadstrip(vl[1], vl[0]);
  geo.quadstrip(vl[6], vl[0]).quadstrip(vl[7], vl[4]).quadstrip(vl[4], vl[5]).quadstrip(vl[3], vl[6]).quadstrip(vl[5], vl[1]).quadstrip(vl[3], vl[7]);
}

void addData() {
  //add data to make the front into a landscape
}

void keyPressed() {
  //write to STL file
  
  if (key == 's') {
    geo.writeSTL("testv2.stl");
  }
}


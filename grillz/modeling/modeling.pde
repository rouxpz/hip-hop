import unlekker.mb2.geo.*;
import unlekker.mb2.util.*;
import ec.util.*;
import geomerative.*;
import org.apache.batik.svggen.font.table.*;
import org.apache.batik.svggen.font.*;

RShape[] frame = new RShape[4];
RPolygon[] pframe = new RPolygon[4];

ArrayList<Float> data = new ArrayList<Float>();

UVertexList[] vl = new UVertexList[9];
UGeo geo;
UNav3D nav;

PVector control1, control2;

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
  addData();
  buildFront();
}

void draw() {
  background(150);
  lights();
  nav.doTransforms();

  stroke(240);
  fill(125);
  geo.draw();

  //  stroke(255, 0, 0);
  //  geo.drawNormals(10);
}

void addData() {
  //pulling data in from the lyrics
  //random for now, will change when python script is done 
  for (int i = 0; i < vl[0].size (); i++) {
    float randSeed = random(20);
    data.add(randSeed);
  }
}

void buildFrame() {
  //build the uniform frame for the grill
  //polygonizing the RShapes from SVGs & creating UVertexLists out of them
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
  float diff;
  
  vl[6] = new UVertexList();
  for (int i = 0; i < vl[3].size (); i++) {
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

void buildFront() {
  //build the front of the grill into a landscape
  //get control points from the base SVG
  RPoint[] handles = frame[0].getHandles();

  control1 = new PVector(handles[2].x, handles[2].y);
  control2 = new PVector(handles[4].x, handles[4].y);
  //println(control1.x + ", " + control1.y);

  //adding dat data
  vl[8] = new UVertexList();

  float beginX = vl[0].first().x;
  float beginY = vl[0].first().y;
  float endX = vl[0].last().x;
  float endY = vl[0].last().y;

  //create vertices from perpendicular lines to point, length determined by data
  for (int i = 0; i < vl[0].size (); i++) { 

    UVertex v = vl[0].get(i);

    float l = data.get(i);
    float t = i/float(vl[0].size());

    float tx = bezierTangent(beginX, control1.x, control2.x, endX, t);
    float ty = bezierTangent(beginY, control1.y, control2.y, endY, t);

    float a = atan2(ty, tx);
    a -= PI/2.0;

    UVertex nv = new UVertex(-cos(a)*l + v.x, -sin(a)*l + v.y, 0);
    vl[8].add(nv);
  }

  vl[8].translate(0, 0, 5);

  //create vertical curvature for front
  float diff;
  for (int i = 0; i < vl[8].size (); i++) {
    if (i < 44) {
      diff = 5 + 0.23*i;
    } else if (i > 48) {
      diff = 5 + 0.23*(92-i);
    } else {
      diff = 14.89;
    }
    vl[8].get(i).z += diff;
  }

  //mo' faces, mo' problemz
  geo.quadstrip(vl[6], vl[8]).quadstrip(vl[8], vl[0]);
  geo.addFace(vl[0].first(), vl[8].first(), vl[6].first()).addFace(vl[6].last(), vl[8].last(), vl[0].last());
}

void keyPressed() {

  //write to STL file 
  if (key == 's') {
    geo.writeSTL("testv2.stl");
  }
}


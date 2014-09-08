import unlekker.mb2.geo.*;
import unlekker.mb2.util.*;
import ec.util.*;
import geomerative.*;
import org.apache.batik.svggen.font.table.*;
import org.apache.batik.svggen.font.*;
import java.util.Collections;

RShape[] frame = new RShape[5];
RPolygon[] pframe = new RPolygon[5];

String title = "juicy";
String artist = "the notorious big";

float half;
ArrayList<Float> data = new ArrayList<Float>();

UVertexList[] vl = new UVertexList[11];
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
  for (int i = 0; i < 5; i++) {
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
  //noStroke();
  fill(125);
  geo.draw();

  //  stroke(255, 0, 0);
  //  geo.drawNormals(10);
}

void addData() {
  //pulling data in from the lyrics

  String[] lyrics = loadStrings("data/lyrics/" + artist + "-" + title + ".txt");

  for (int i = 0; i < lyrics.length; i++) {
    String[] splitLyrics = lyrics[i].split(",");
    float score = float(splitLyrics[1]);
    data.add(score);
    //println(score);
  }


  if (lyrics.length < 91) {
    float remainder = 91 - lyrics.length;
    //println(remainder);

    if (remainder % 2 != 0) {
      half = remainder/2;
      int frontHalf = int(half + 0.5);
      int backHalf = int(half - 0.5);
      for (int i = 0; i < frontHalf; i++) {
        data.add(0, 0.0);
      }
      for (int i = 0; i < backHalf; i++) {
        data.add(0.0);
      }
    }
    
    else {
      half = int(remainder/2);
      for (int i = 0; i < half; i++) {
        data.add(0, 0.0);
        data.add(0.0);
        println(data);
      }
    }

    println(data.size());
  }
}

void buildFrame() {
  //build the uniform frame for the grill
  //polygonizing the RShapes from SVGs & creating UVertexLists out of them
  for (int i = 0; i < 5; i++) {
    //int curveLength = int(frame[i].getCurveLengths()[0]);
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
  vl[4].translate(0, 0, 5);
  vl[5] = vl[2].copy().translate(0, 0, 10);
  vl[7] = vl[1].copy().translate(0, 0, 10);
  vl[8] = vl[2].copy().translate(0, 0, 5);

  //shaping the top into a "mouth-friendly" form
  shapeTop(6, 3);
  shapeTop(10, 4);

  //adding dem faces
  geo = new UGeo().quadstrip(vl[1], vl[0]);
  geo.quadstrip(vl[8], vl[5]).quadstrip(vl[5], vl[7]).quadstrip(vl[7], vl[1]).quadstrip(vl[4], vl[8]).quadstrip(vl[4], vl[10]).quadstrip(vl[6], vl[10]);
  geo.addFace(vl[4].first(), vl[0].first(), vl[10].first()).addFace(vl[0].first(), vl[4].first(), vl[8].first()).addFace(vl[1].first(), vl[0].first(), vl[8].first()).addFace(vl[1].first(), vl[8].first(), vl[7].first()).addFace(vl[7].first(), vl[8].first(), vl[5].first()).addFace(vl[0].first(), vl[6].first(), vl[10].first());
  geo.addFace(vl[10].last(), vl[0].last(), vl[4].last()).addFace(vl[8].last(), vl[4].last(), vl[0].last()).addFace(vl[8].last(), vl[0].last(), vl[1].last()).addFace(vl[7].last(), vl[8].last(), vl[1].last()).addFace(vl[5].last(), vl[8].last(), vl[7].last()).addFace(vl[0].last(), vl[6].last(), vl[10].last());
}

void buildFront() {
  //build the front of the grill into a landscape
  //get control points from the base SVG
  RPoint[] handles = frame[0].getHandles();

  control1 = new PVector(handles[2].x, handles[2].y);
  control2 = new PVector(handles[4].x, handles[4].y);
  //println(control1.x + ", " + control1.y);

  float highest = Collections.max(data);
  //println(highest);

  //adding dat data
  vl[8] = new UVertexList();

  float beginX = vl[0].first().x;
  float beginY = vl[0].first().y;
  float endX = vl[0].last().x;
  float endY = vl[0].last().y;

  //create vertices from perpendicular lines to point, length determined by data
  for (int i = 0; i < vl[0].size (); i++) { 

    UVertex v = vl[0].get(i);

    float d = data.get(i);
    float l = map(d, 0, highest, 1, 20);
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
    if (i < 25) {
      diff = 5 + 0.6*i;
    } else if (i > 67) {
      diff = 5 + 0.6*(92-i);
    } else {
      diff = 15;
    }
    vl[8].get(i).z += diff;
  }

  //mo' faces, mo' problemz
  geo.quadstrip(vl[6], vl[8]).quadstrip(vl[8], vl[0]);
  geo.addFace(vl[0].first(), vl[8].first(), vl[6].first()).addFace(vl[6].last(), vl[8].last(), vl[0].last());
}

void shapeTop(int index, int baseIndex) {
  float diff;

  vl[index] = new UVertexList();
  for (int i = 0; i < vl[baseIndex].size(); i++) {
    if (i < 25) {
      diff = vl[baseIndex].get(i).z + 1.28*i;
    } else if (i > 67) {
      diff = vl[baseIndex].get(i).z + 1.28*(92-i);
    } else {
      diff = vl[baseIndex].get(43).z + 32;
    }

    UVertex nv = new UVertex(vl[baseIndex].get(i).x, vl[baseIndex].get(i).y, diff);    
    vl[index].add(nv);
  }
}

void keyPressed() {

  //write to STL file 
  if (key == 's') {
    geo.writeSTL("stl/" + artist + "-" + title + ".stl");
  }
}

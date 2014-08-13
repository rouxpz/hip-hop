import unlekker.mb2.geo.*;
import unlekker.mb2.util.*;
import ec.util.*;
import geomerative.*;
import org.apache.batik.svggen.font.table.*;
import org.apache.batik.svggen.font.*;

RShape bottom;
RPolygon pbottom;

UVertexList vl, vl2, vl3, vl4, vl5, vl6, vl7;
UGeo geo;
UNav3D nav;

void setup() {
  size(600, 600, P3D);
  UMB.setPApplet(this);
  nav = new UNav3D();

  smooth();
  RG.init(this);

  bottom = RG.loadShape("bottom.svg");

  buildBottom();
}

void draw() {
  background(100);
  lights();
  nav.doTransforms();
  stroke(0);
  translate(width/2, height/2);
  // vl.draw();
  //vl2.draw();
  geo.draw();
//
//  stroke(255, 0, 0);
//  geo.drawNormals(10);
}

void buildBottom() {
  RCommand.setSegmentLength(5);
  RCommand.setSegmentator(RG.UNIFORMLENGTH);

  pbottom = bottom.toPolygon();
  pbottom.addClose();

  //create outer boundary from SVG
  vl = new UVertexList();
  for (int i = 0; i < pbottom.contours[0].points.length-59; i++) {
    RPoint bottompoint = pbottom.contours[0].points[i];
    vl.add(new UVertex(bottompoint.x, bottompoint.y, 0));
    println(bottompoint.x + ", " + bottompoint.y);
  }

  //println(vl.size());

  vl2 = vl.copy().translate(0, 0, 6);
  geo = new UGeo().quadstrip(vl, vl2);

  vl3 = new UVertexList();
  
  //create inner boundary
  vl3 = vl.copy().scale(0.6, 0.6, 0.6).translate(30, 30, 0);
  vl4 = vl3.copy().translate(0, 0, 6);
  geo.quadstrip(vl4, vl3);
  geo.quadstrip(vl, vl3);
  geo.quadstrip(vl4, vl2);
  
  vl5 = new UVertexList();
  vl6 = new UVertexList();
  vl7 = new UVertexList();
  
  vl5 = vl4.copy().translate(0, 0, 5);
  vl6 = vl5.copy().scale(1.1, 1.1, 1.1).translate(-8, -8, -1);
  vl7 = vl6.copy().translate(0, 0, -5);
  geo.quadstrip(vl5, vl4);
  geo.quadstrip(vl7, vl6);
  geo.quadstrip(vl6, vl5);
  
  //adding faces to the ends
  geo.addFace(vl.first(), vl2.first(), vl4.first());
  geo.addFace(vl4.first(), vl3.first(), vl.first());
  geo.addFace(vl4.last(), vl2.last(), vl.last());
  geo.addFace(vl.last(), vl3.last(), vl4.last());
  
  geo.addFace(vl5.first(), vl6.first(), vl7.first());
  geo.addFace(vl5.first(), vl4.first(), vl7.first());
  geo.addFace(vl5.last(), vl6.last(), vl7.last());
  geo.addFace(vl5.last(), vl4.last(), vl7.last());

  // if (bottompoints != null) {
  //   stroke(255);
  //   beginShape();
  // for (int i = 0; i < bottompoints.length; i++) {
  //   stroke(255, 0, 0);
  //   ellipse(bottompoints[i].x, bottompoints[i].y, 5, 5);
  // }
  //   endShape();
  // }
}

void keyPressed() {
  
  geo.writeSTL("test.stl");
  
}

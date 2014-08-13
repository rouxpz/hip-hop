import unlekker.mb2.geo.*;
import unlekker.mb2.util.*;
import ec.util.*;
import geomerative.*;
import org.apache.batik.svggen.font.table.*;
import org.apache.batik.svggen.font.*;

RShape bottom;
RPolygon pbottom;

UVertexList vl, vl2;
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
  translate(width/3, height/3);
  vl.draw();
  vl2.draw();
  geo.draw();
  
  // stroke(255, 0, 0);
  // geo.drawNormals(50);
}

void buildBottom() {
  RCommand.setSegmentLength(5);
  RCommand.setSegmentator(RG.UNIFORMLENGTH);

  pbottom = bottom.toPolygon();
  pbottom.addClose();

  vl = new UVertexList();
    for (int i = 0; i < pbottom.contours[0].points.length; i++) {
      RPoint bottompoint = pbottom.contours[0].points[i];
      vl.add(new UVertex(bottompoint.x, bottompoint.y, 0));
      println(bottompoint.x + ", " + bottompoint.y);
    }
  
  vl2 = vl.copy().translate(0, 0, 7.5);
  geo = new UGeo().quadstrip(vl, vl2);
  
  // geo.triangleFan(vl.close());
  // geo.triangleFan(vl2);

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

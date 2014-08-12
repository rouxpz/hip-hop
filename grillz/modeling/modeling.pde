import unlekker.mb2.geo.*;
import unlekker.mb2.util.*;
import ec.util.*;
import geomerative.*;
import org.apache.batik.svggen.font.table.*;
import org.apache.batik.svggen.font.*;

RShape bottom;
RShape pbottom;
RPoint[] bottompoints;

UVertexList vl;
UNav3D nav;

void setup() {
  size(300, 300, P3D);
  UMB.setPApplet(this);
  nav = new UNav3D();

  smooth();
  RG.init(this);

  bottom = RG.loadShape("bottom.svg");

  buildBottom();
}

void draw() {
  background(0);
  lights();
  nav.doTransforms();

  vl.draw();
}

void buildBottom() {
  RG.setPolygonizer(RG.UNIFORMLENGTH);
  RG.setPolygonizerLength(5);

  pbottom = RG.polygonize(bottom);

  bottompoints = pbottom.getPoints();

  vl = new UVertexList();
  if (bottompoints != null) {
    for (int i = 0; i < bottompoints.length; i++) {
      vl.add(new UVertex(bottompoints[i].x, bottompoints[i].y, 0));
    }
  }

  // if (bottompoints != null) {
  //   stroke(255);
  //   beginShape();
  //   for (int i = 0; i < bottompoints.length; i++) {
  //     vertex(bottompoints[i].x, bottompoints[i].y);
  //   }
  //   endShape();
  // }
}

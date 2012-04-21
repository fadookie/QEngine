class Arc {
  float startAngle;
  float stopAngle;
  float maxRadius;
  float minRadius;
  PVector center;

  Arc() {
    center = new PVector();
  }

  boolean collidesWith(Arc otherArc) {
    boolean collides = false;

    if( startAngle > otherArc.stopAngle ||
        stopAngle < otherArc.startAngle ||
        minRadius > otherArc.maxRadius  ||
        maxRadius < otherArc.minRadius ) {
      collides = false;  
    } else {
      collides = true;
    }
     
    return collides;
  }


  void debugDraw() {
    pushStyle();
    noFill();
    ellipseMode(RADIUS);
    pushMatrix();
    translate(center.x, center.y);
    arc(0, 0, maxRadius, maxRadius, startAngle, stopAngle);
    arc(0, 0, minRadius, minRadius, startAngle, stopAngle);
    //Draw sides
    PolarCoord startMinP = new PolarCoord(minRadius, startAngle);
    PolarCoord startMaxP = new PolarCoord(maxRadius, startAngle);
    PolarCoord stopMinP = new PolarCoord(minRadius, stopAngle);
    PolarCoord stopMaxP = new PolarCoord(maxRadius, stopAngle);
    PVector startMinC = startMinP.getCartesianCoords();
    PVector startMaxC = startMaxP.getCartesianCoords();
    PVector stopMinC = stopMinP.getCartesianCoords();
    PVector stopMaxC = stopMaxP.getCartesianCoords();
    line(startMinC.x, startMinC.y, startMaxC.x, startMaxC.y);
    line(stopMinC.x, stopMinC.y, stopMaxC.x, stopMaxC.y);
    popMatrix();
    popStyle();
  }
}

class Arc {
  //Not a true arc, more of a segment of one or a "Block Arc", but it's much easier to type.
  float startAngle;
  float stopAngle;
  float maxRadius;
  float minRadius;
  PVector center;

  //For debugDraw:
  color _color;

  Arc() {
    center = new PVector();
    _color = color(0, 0, 0);
  }

  boolean collidesWith(Arc otherArc) {
    return !( startAngle > otherArc.stopAngle ||
              stopAngle < otherArc.startAngle ||
              minRadius > otherArc.maxRadius  ||
              maxRadius < otherArc.minRadius );
  }

  boolean collidesWith(PolarCoord point) {
    return !( startAngle > point.t ||
              stopAngle < point.t ||
              minRadius > point.r ||
              maxRadius < point.r );
  }

  //Call this after resetting position to a non-colliding one
  CollisionInfo collisionInfo(PolarCoord point) {
    CollisionInfo info = new CollisionInfo();

    //Check for floor/ceiling
    if (startAngle < point.t &&
        stopAngle > point.t) {
      //We're inside the arc
      if (maxRadius < point.r) {
        info.type = info.ABOVE_TYPE;
      } else if (minRadius > point.r) {
        info.type = info.BELOW_TYPE;
      }
    }

    if (info.type == info.NO_TYPE) {
      //If we didn't find anything earlier, check for side collisions
      if (maxRadius > point.r &&
          minRadius < point.r) {
        //We're within the radius band
        if (startAngle > point.t) {
          info.type = info.COUNTERCLOCKWISE_TYPE;
        } else if (stopAngle < point.t) {
          info.type = info.CLOCKWISE_TYPE;
        }
      }
    }
        

    return info;
  }


  void debugDraw() {
    pushStyle();
    noFill();
    stroke(_color);
    strokeWeight(2);

    ellipseMode(RADIUS);

    pushMatrix();

    translate(center.x, center.y);

    //Draw min and max arc
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

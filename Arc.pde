class Arc {
  //Not a true arc, more of a segment of one or a "Block Arc", but it's much easier to type.
  float startAngle;
  float stopAngle;
  float maxRadius;
  float minRadius;
  PVector pole;
  PolarCoord center;
  QSprite sprite;

  //For debugDraw:
  color _color;

  Arc() {
    pole = zero;
    center = new PolarCoord();
    _color = color(0, 0, 0);
    sprite = new QSprite();
    sprite.imageMode = CENTER;
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

  //Collision test with line segment -- FIXME fake hack sweep shit
  boolean collidesWith(PolarCoord startPoint, PolarCoord endPoint) {
    PolarCoord lerpPoint = new PolarCoord();
    for (float lerpAmount = 0.25; lerpAmount < 1; lerpAmount += 0.25) {
      lerpPoint.r = lerp(startPoint.r, endPoint.r, lerpAmount);
      lerpPoint.t = lerp(startPoint.t, endPoint.t, lerpAmount);
      if (collidesWith(lerpPoint)) {
        return true;
      }
    }
    return false;
  }

  boolean collidesWithDebug(PolarCoord startPoint, PolarCoord endPoint) {
    PolarCoord lerpPoint = new PolarCoord();
    for (float lerpAmount = 0.25; lerpAmount < 1; lerpAmount += 0.25) {
      lerpPoint.r = lerp(startPoint.r, endPoint.r, lerpAmount);
      lerpPoint.t = lerp(startPoint.t, endPoint.t, lerpAmount);
      PVector p = lerpPoint.getCartesianCoords();
      ellipseMode(RADIUS);
      ellipse(p.x, p.y, 10, 10);
      if (collidesWith(lerpPoint)) {
        return true;
      }
    }
    return false;
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


  void draw() {
    center.r = minRadius + ((maxRadius - minRadius) / 2); //Had to fudge this positioning, not sure why
    center.t = startAngle + ((stopAngle - startAngle) / 2);
    sprite.position = center;
    sprite.rotation = center.t;
    if (sprite.type > QSprite.INVALID) {
      sprite.draw();
    }
  }

  void debugDraw() {
    pushStyle();
    noFill();
    stroke(_color);
    strokeWeight(2);

    ellipseMode(RADIUS);

    pushMatrix();

    translate(pole.x, pole.y);

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

    //Draw center
    //ellipseMode(RADIUS);
    //ellipse(sprite.position.x, sprite.position.y, 10, 10);

    popMatrix();
    popStyle();
  }
}

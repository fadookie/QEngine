/**
 * An example of how you might set up a class heirarchy for game objects,
 * and some common functionality you might want.
 *
 * @author Eliot Lash
 * @copyright Copyright (c) 2010-2012 Eliot Lash
 */
class GameObjectController {
  PVector heading;

  PolarCoord position;
  PVector center;

  QSprite sprite;
  String tag = "";

  //Re-using some PVector objects to reduce garbage during calcs in a tight loop
  PVector workVectorA;
  PVector workVectorB;
  PVector workVectorC;

  GameObjectController() {
    construct();
  }

  void construct() {
    heading = new PVector();

    position = new PolarCoord();
    center = new PVector();

    sprite = new QSprite();

    workVectorA = new PVector();
    workVectorB = new PVector();
    workVectorC = new PVector();
  }

  void setPosition(float r, float t) {
    position.r = r;
    position.t = t;
  }

  //TODO: clean up this cartesian shit
  PVector getPosition() {
    return sprite.position.get();
  }

  PVector getHeading() {
    return heading.get();
  }

  PVector getHeadingNormal() {
    return QMath.rotatePVector2D(heading, radians(90));
  }

  PVector getSize() {
    return sprite.size.get();
  }


  void setSize(float u) {
    setSize(u, u);
  }

  void setSize(float x, float y) {
    sprite.size.x = x;
    sprite.size.y = y;
  }

  void update() {
    for (Arc arc : arcs) {
      if (arc.collidesWith(position)) {
        arc._color = color(255, 0, 0);
      } else {
        arc._color = color(255, 255, 255);
      }
    }
  }

  void draw() {
    sprite.draw();
  }

  void debugDraw() {
    pushStyle();
    PVector pos = position.getCartesianCoords();
    ellipseMode(RADIUS);
    pushMatrix();
    translate(center.x, center.y);

    pushMatrix();
    translate(pos.x, pos.y);

    ellipse(0, 0, 10, 10);

    popMatrix();

    popMatrix();
    popStyle();
  }

  String toString() {
    if (null != tag) {
      return tag;
    } else {
      return super.toString();
    }
  }
}

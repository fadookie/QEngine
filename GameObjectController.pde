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
  PolarCoord velocity;
  PolarCoord accel;
  PVector center;
  ArrayList<Arc> collidesWith;

  QSprite sprite;
  String tag = "";

  boolean removeFromScene = false;

  float curSmooth = 0.2; //Smooth curve for velocity, etc.

  //Re-using some PVector objects to reduce garbage during calcs in a tight loop
  PVector workVectorA;
  PVector workVectorB;
  PVector workVectorC;

  GameObjectController() {
    construct();
  }

  GameObjectController(UnitTemplate template){
    construct();
    sprite.setAnimationTemplate(template.animationTemplate);
  }

  void construct() {
    heading = new PVector();

    position = new PolarCoord();
    velocity = new PolarCoord();
    accel = new PolarCoord();
    center = new PVector();
    collidesWith = new ArrayList<Arc>();

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
    //Update velocity
    velocity.r += accel.r;
    velocity.t += accel.t;

    float adjustedAngluarVelocity = velocity.t * getConstantVelocityCoefficient(velocity.t);

    //velocity.r *= deltaTime;
    //velocity.t *= deltaTime;

    //Update position
    position.r += velocity.r;
    position.t += adjustedAngluarVelocity;

    checkCollisions();
  }

  void checkCollisions() {
    collidesWith.clear();

    for (Arc arc : arcs) {
      if (arc.collidesWith(position)) {
        arc._color = color(255, 0, 0);
        collidesWith.add(arc);
      } else {
        arc._color = color(255, 255, 255);
      }
    }
  }
  
  float getConstantVelocityCoefficient(float _targetVelocity) {
      if (_targetVelocity == pForward.t) {
        return 1;
      }
      float arcLength = position.r * radians(1);
      float constantVelocityCoefficient = abs(_targetVelocity) / arcLength;
      //println("arcLength =" +arcLength+ ", _targetVelocity = "+_targetVelocity+",f = " + constantVelocityCoefficient);
      return constantVelocityCoefficient;
  }

  void draw() {
    pushMatrix();
    //translate(center.x, center.y);
    sprite.updateSize();
    sprite.position = position.getCartesianCoords();
    sprite.rotation = position.t + radians(90);
    sprite.draw();
    popMatrix();
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

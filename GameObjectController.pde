/**
 * An example of how you might set up a class heirarchy for game objects,
 * and some common functionality you might want.
 *
 * @author Eliot Lash
 * @copyright Copyright (c) 2010-2012 Eliot Lash
 */
class GameObjectController {
  PVector heading;
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
    sprite = new QSprite();

    workVectorA = new PVector();
    workVectorB = new PVector();
    workVectorC = new PVector();
  }

  void setPosition(float x, float y) {
    sprite.position.x = x;
    sprite.position.y = y;
  }

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

  boolean collidesWith(GameObjectController otherObject) {
    boolean collides = false;
    PVector currentPosition = getPosition();
    PVector size = getSize();
    PVector otherPosition = otherObject.getPosition();
    
    float myMinX = currentPosition.x;
    float myMaxX = currentPosition.x + size.x;
    float myMinY = currentPosition.y;
    float myMaxY = currentPosition.y + size.y;
    
    float theirMinX = otherPosition.x;
    float theirMaxX = otherPosition.x + size.x;
    float theirMinY = otherPosition.y;
    float theirMaxY = otherPosition.y + size.y;
    
    /*myMinX = currentPosition.x;
    myMaxX = currentPosition.x + size.x;
    myMinY = currentPosition.y;
    myMaxY = currentPosition.y + size.y;
    
    theirMinX = otherPosition.x;
    theirMaxX = otherPosition.x + otherBRect.size.x;
    theirMinY = otherPosition.y;
    theirMaxY = otherPosition.y + otherBRect.size.y;*/
    
    if(  myMinX > theirMaxX ||
         myMaxX < theirMinX ||
         myMinY > theirMaxY ||
         myMaxY < theirMinY ) {
       collides = false;  
     } else {
       collides = true;
     }
    
    return collides;
  }

  void update() {
  }

  void draw() {
    sprite.draw();
  }

  String toString() {
    if (null != tag) {
      return tag;
    } else {
      return super.toString();
    }
  }
}

/**
 * A sprite class to handle drawing of game objects.
 * You might need to modify it to suit your needs.
 *
 * @author Eliot Lash
 * @copyright Copyright (c) 2010-2012 Eliot Lash
 */
class QSprite {
  static final int INVALID = 0;
  static final int RECT = 1;
  static final int ELLIPSE = 2;
  static final int STATICIMAGE = 3;

  int type;
  PVector position;
  PVector size;
  color fillColor;
  PImage image;

  //For dummy objects
  QSprite() {
    construct(INVALID);
  }

  QSprite(int _type) {
    construct(_type);
  }

  QSprite(String file) {
    construct(STATICIMAGE);
    image = loadImage(file);
    size.x = image.width;
    size.y = image.height;
  }

  void construct(int _type) {
    type = _type;

    position = new PVector();
    size = new PVector(1,1);
    fillColor = color(120, 30, 90);
  }

  void draw() {
    pushMatrix();
    pushStyle();
    translate(position.x, position.y);
    fill(fillColor);

    if (RECT == type) {
      rectMode(CORNER);
      rect(position.x, position.y, size.x, size.y);
    } else if (ELLIPSE == type) {
      ellipseMode(CENTER);
      ellipse(position.x, position.y, size.x, size.y);
    } else if (STATICIMAGE == type) {
      imageMode(CENTER);
      image(image, 0, 0, size.x, size.y);
    } else {
      println("The sprite type " + type + " is not valid. Not drawing.");
    }

    popStyle();
    popMatrix();
  }
}

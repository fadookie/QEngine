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
  static final int PIMAGE = 3;
  static final int ANIM = 4;

  int type;
  PVector position;
  PVector size;
  color fillColor;
  PImage image;
  String imageFileName;
  Animation animation;
  int imageMode = CORNER;
  float rotation;

  //For dummy objects
  QSprite() {
    construct(INVALID);
  }

  QSprite(int _type) {
    construct(_type);
  }

  void construct(int _type) {
    type = _type;

    position = new PVector();
    size = new PVector(1,1);
    fillColor = color(120, 30, 90);
  }

  void setImage(String _fileName) {
    type = PIMAGE;
    imageFileName = _fileName;
    image = loadImage(imageFileName);
    size.x = image.width;
    size.y = image.height;
  }

  void setAnimationTemplate(AnimationTemplate animationTemplate) {
    type = ANIM;
    animation = new Animation(animationTemplate);
    println(animation);
  }

  void draw() {
    pushMatrix();
    pushStyle();
    translate(position.x, position.y);
    rotate(rotation);
    fill(fillColor);

    if (RECT == type) {
      rectMode(CENTER);
      rect(0, 0, size.x, size.y);
    } else if (ELLIPSE == type) {
      ellipseMode(CENTER);
      ellipse(0, 0, size.x, size.y);
    } else if (PIMAGE == type) {
      if (image instanceof PImage) {
        imageMode(imageMode);
        image(image, 0, 0, size.x, size.y);
      }
    } else if (ANIM == type) {
      updateSize();
      animation.draw();
    } else {
      println("The sprite type " + type + " is not valid. Not drawing.");
    }

    popStyle();
    popMatrix();
  }

  void play() {
    if (ANIM == type) {
      animation.play();
    }
  }

  void pause() {
    if (ANIM == type) {
      animation.pause();
    }
  }

  void setState(int state) {
    if (ANIM == type) {
      animation.setState(state);
    }
  }

  boolean isPlaying() {
    if (ANIM == type) {
      return animation.isPlaying();
    } else {
      return false;
    }
  }

  void updateSize() {
    if (ANIM == type) {
      size = animation.getCurrentSize();
    }
  }
}

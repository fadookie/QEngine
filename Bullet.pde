class Bullet extends GameObjectController {
  static final int numTypes = 3;

  static final int BULLET_TYPE = 0;
  static final int MISSILE_TYPE = 1;
  static final int RAYGUN_TYPE = 2;

  boolean friendly;
  int type;
  color _color;
  float lifeDurationMs = 1000;
  float spawnTimeMs = 0;

  Bullet() {
    super();
    construct(BULLET_TYPE);
  }

  Bullet(int _type) {
    super();
    construct(_type);
  }

  void construct(int _type) {
    type = _type;
    sprite.type = QSprite.ELLIPSE;
    sprite.size.x = 5;
    sprite.size.y = 5;
    _color = bulletColors[type]; //These are defined in QEngine
    spawnTimeMs = millis();
  }

  void update() {
    super.update();
    if ((millis() - spawnTimeMs) > lifeDurationMs) {
      //Kill this bullet on the next update
      removeFromScene = true;
    }

    if (!collidesWith.isEmpty()) {
      removeFromScene = true;
    }
  }

  void draw() {
    pushStyle();
    PVector pos = position.getCartesianCoords();
    ellipseMode(RADIUS);
    noStroke();
    fill(_color);
    pushMatrix();
    translate(center.x, center.y);

    pushMatrix();
    translate(pos.x, pos.y);

    ellipse(0, 0, sprite.size.x, sprite.size.y);

    popMatrix();

    popMatrix();
    popStyle();
  }
}

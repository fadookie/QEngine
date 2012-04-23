class Bullet extends GameObjectController {
  static final int BULLET_TYPE = 1;
  static final int MISSILE_TYPE = 2;
  static final int RAYGUN_TYPE = 3;

  boolean friendly;
  int type;
  color _color;
  float lifeDurationMs = 1000;
  float spawnTimeMs = 0;

  Bullet() {
    super();
    type = BULLET_TYPE;
    sprite.type = QSprite.ELLIPSE;
    sprite.size.x = 5;
    sprite.size.y = 5;
    _color = color(255, 255, 255);
    spawnTimeMs = millis();
  }

  void update() {
    super.update();
    if ((millis() - spawnTimeMs) > lifeDurationMs) {
      //Kill this bullet on the next update
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

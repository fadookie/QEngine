/**
 * An example Player controller
 *
 * @author Eliot Lash
 * @copyright Copyright (c) 2010-2012 Eliot Lash
 */
class PlayerController extends GameObjectController {
  QInput input;
  int health = 10;
  float lastDamageTime;


  PlayerController() {
    super();
    input = new QInput();
    sprite = new QSprite("sister.png");
  }

  void damage() {
    if (millis() - lastDamageTime > 1000) {
      health--;
      lastDamageTime = millis();
      println("Damage");
    }
  }

  void update() {
    super.update();

  }

  void draw() {
    super.draw();

  }
}

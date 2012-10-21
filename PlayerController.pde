/**
 * An example Player controller
 *
 * @author Eliot Lash
 * @copyright Copyright (c) 2010-2012 Eliot Lash
 */
class PlayerController extends GameObjectController {
  QInput input;

  PlayerController() {
    super();
    input = new QInput();
    sprite = new QSprite("sister.png");
  }

  void update() {
    super.update();

  }

  void draw() {
    super.draw();

  }
}

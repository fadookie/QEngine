/**
 * An example Player controller
 *
 * @author Eliot Lash
 * @copyright Copyright (c) 2010-2012 Eliot Lash
 */
class PlayerController extends GameObjectController {
  QInput input;
  float radialMoveAmount = 2;
  float angularMoveAmount;

  PlayerController() {
    input = new QInput();
    angularMoveAmount = radians(2);
  }

  void update() {
    super.update();

    if (input.upKeyDown) {
      position.r += radialMoveAmount;
    } else if (input.downKeyDown) {
      position.r -= radialMoveAmount;
    } else if (input.leftKeyDown) {
      position.t -= angularMoveAmount;
    } else if (input.rightKeyDown) {
      position.t += angularMoveAmount;
    }
  }

  void draw() {
    super.draw();

  }
}

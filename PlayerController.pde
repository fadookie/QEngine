/**
 * An example Player controller
 *
 * @author Eliot Lash
 * @copyright Copyright (c) 2010-2012 Eliot Lash
 */


class PlayerController extends GameObjectController {
  QInput input;
  PolarCoord oldPosition;
  PolarCoord targetVelocity;
  float radialMoveAmount = 20;
  float angularMoveAmount;
  float gravity = -1;
  float curSmooth = 0.2;
  float horizontalMomentum = 0;

  PlayerController() {
    super();
    input = new QInput();
    angularMoveAmount = radians(10);
    oldPosition = new PolarCoord();
    targetVelocity = new PolarCoord();
  }

  void update() {
    oldPosition.r = position.r;
    oldPosition.t = position.t;

    //TODO: timer so jump has to end after 0.25 seconds or whatever
    if (input.upKeyDown) {
      velocity.r = radialMoveAmount;
    } else if (input.downKeyDown) {
      velocity.r = -radialMoveAmount;
    }

    if (input.leftKeyDown) {
      targetVelocity.t = -angularMoveAmount;
    } else if (input.rightKeyDown) {
      targetVelocity.t = angularMoveAmount;
    } else {
      targetVelocity.t = pForward.t;
    }

    //My attempt to keep target speed constant, we'll see if it works
    if (targetVelocity.t != pForward.t) {
      float arcLength = position.r * radians(1);
      float constantVelocityCoefficient = abs(targetVelocity.t) / arcLength;
      targetVelocity.t *= constantVelocityCoefficient;
      //println("arcLength =" +arcLength+ ", targetVelocity.t = "+targetVelocity.t+",f = " + constantVelocityCoefficient);
    }

    //Apply gravity
    accel.r = gravity;

    //Modify horizontal momentum
    //curSmooth *= horizontalTraction;
    //accel.t = lerp(accel.t, pForward.t, curSmooth);
    velocity.t = lerp(velocity.t, targetVelocity.t, curSmooth);

    //Update velocity
    velocity.r += accel.r;
    velocity.t += accel.t;

    //Update position
    position.r += velocity.r;
    position.t += velocity.t;

    //Don't let the player fall through the world, for now.
    position.r = constrain(position.r, worldCoreSize, Float.MAX_VALUE);


    //Constrain position to 0-2PI
    position.t = QMath.wrapTwoPI(position.t);

    //Check collisions, etc.
    super.update();

    for (Arc arc : collidesWith) {
      CollisionInfo info = arc.collisionInfo(oldPosition);
      if (info.type == info.ABOVE_TYPE ||
          info.type == info.BELOW_TYPE) {
        velocity.r = pForward.r;
        position.r = oldPosition.r;
      } else if (info.type == info.COUNTERCLOCKWISE_TYPE ||
                 info.type == info.CLOCKWISE_TYPE) {
        velocity.t = pForward.t;
        position.t = oldPosition.t;
      }
    }

    //println("position: "+position+" velocity: " + velocity + ", targetVelocity: " + targetVelocity + " accel: " + accel);

  }

  void draw() {
    super.draw();

  }
}

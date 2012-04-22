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
  float radialMoveAmount = 15;
  float angluarMoveAmountDegrees = 25;
  float angularMoveAmount; //Angular move amount in radians
  float gravity = -1;
  float curSmooth = 0.2;
  float horizontalMomentum = 0;

  boolean onGround = true;
  boolean jumpReleased = true;
  float jumpDurationMs = 100;
  float lastJumpMs = 0;
  int numJumps = 0;
  int maxJumps = Integer.MAX_VALUE;

  boolean upKeyReleased = false;

  PlayerController() {
    super();
    input = new QInput();
    angularMoveAmount = radians(angluarMoveAmountDegrees);
    oldPosition = new PolarCoord();
    targetVelocity = new PolarCoord();
  }

  void update() {
    oldPosition.r = position.r;
    oldPosition.t = position.t;

    if (input.upKeyDown) {
      upKeyReleased = false;

      //Handle jump logic
      if (!jumpReleased) {
        //In the middle of a jump, continue while it's still valid
        if (millis() - lastJumpMs < jumpDurationMs) {
          velocity.r = radialMoveAmount;
        }
      } else {
        //Trying to start a new jump
        if ((numJumps < maxJumps) && jumpReleased) {
          velocity.r = radialMoveAmount;
          jumpReleased = false;
          numJumps++;
          lastJumpMs = millis();
          setOnGround(false);
        }
      }
    } else if (!upKeyReleased) {
      upKeyReleased = true;
      jumpReleased = true;
      if (velocity.r > 0) {
        velocity.r = 0;
      }
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

    //Interpolate horizontal velocity towards target to give a feeling of momentum
    velocity.t = lerp(velocity.t, targetVelocity.t, curSmooth);

    //Update velocity
    velocity.r += accel.r;
    velocity.t += accel.t;

    //velocity.r *= deltaTime;
    //velocity.t *= deltaTime;

    //Update position
    position.r += velocity.r;
    position.t += velocity.t;

    //Don't let the player fall through the world, for now.
    position.r = constrain(position.r, worldCoreSize, Float.MAX_VALUE);

    if (position.r == worldCoreSize) {
      setOnGround(true);
    }

    //Constrain position to 0-2PI
    position.t = QMath.wrapTwoPI(position.t);

    //Check collisions, etc.
    super.update();
    //collidesWith.clear();

    //for (Arc arc : arcs) {
    //  if (arc.collidesWith(oldPosition, position)) {
    //    arc._color = color(255, 0, 0);
    //    collidesWith.add(arc);
    //  } else {
    //    arc._color = color(255, 255, 255);
    //  }
    //}

    for (Arc arc : collidesWith) {
      //print(deltaTime + "] collides with arc " + arc);
      CollisionInfo info = arc.collisionInfo(oldPosition);
      if (info.type == info.ABOVE_TYPE ||
          info.type == info.BELOW_TYPE) {
        velocity.r = pForward.r;
        position.r = oldPosition.r;
        //print(", vertical collison\n");

        if (info.type == info.ABOVE_TYPE) {
          setOnGround(true);
        }
      } else if (info.type == info.COUNTERCLOCKWISE_TYPE ||
                 info.type == info.CLOCKWISE_TYPE) {
        velocity.t = pForward.t;
        position.t = oldPosition.t;
        //println("horizontal collision");
      } else {
        //This is an unknown collision type, let's stop movment to be safe so we don't fall through the floor or some shit.
        println("Collision type : " + info.type);
        velocity.r = pForward.r;
        velocity.t = pForward.t;
        position.r = oldPosition.r;
        position.t = oldPosition.t;
      }
    }

    //println("position: "+position+" velocity: " + velocity + ", targetVelocity: " + targetVelocity + " accel: " + accel);

  }

  void setOnGround(boolean _onGround) {
    onGround = _onGround;
    if (onGround) {
      numJumps = 0;
    }
  }

  void draw() {
    super.draw();

  }
}

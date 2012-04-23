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
  float radialMoveAmount = 30;
  float angluarMoveAmountDegrees = 25;
  float angularMoveAmount; //Angular move amount in radians
  float gravity = -1;
  float horizontalMomentum = 0;

  boolean onGround = true;
  boolean jumpReleased = true;
  float jumpDurationMs = 100;
  float lastJumpMs = 0;
  int numJumps = 0;
  int maxJumps = Integer.MAX_VALUE;

  float bulletVelocityDegrees = 35;
  float bulletVelocity; //Angular move amount in radians
  float lastTimeFiredMs = 0;
  float fireIntervalMs = 125;
  float fireHeight = 100;

  boolean jumpKeyReleased = false;

  PlayerController(UnitTemplate template) {
    super(template);
    input = new QInput();
    input.heading = right;
    angularMoveAmount = radians(angluarMoveAmountDegrees);
    bulletVelocity = radians(bulletVelocityDegrees);
    oldPosition = new PolarCoord();
    targetVelocity = new PolarCoord();
  }

  void update() {
    oldPosition.r = position.r;
    oldPosition.t = position.t;

    if (input.jumpKeyDown) {
      jumpKeyReleased = false;

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
    } else if (!jumpKeyReleased) {
      jumpKeyReleased = true;
      jumpReleased = true;
      if (velocity.r > 0) {
        velocity.r = 0;
      }
    }

    if (input.leftKeyDown) {
      input.heading = left;
      targetVelocity.t = -angularMoveAmount;
    } else if (input.rightKeyDown) {
      input.heading = right;
      targetVelocity.t = angularMoveAmount;
    } else {
      targetVelocity.t = pForward.t;
    }

    targetVelocity.t *= getConstantVelocityCoefficient(targetVelocity.t);

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
    checkCollisions();

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
        //This is an unknown collision type, let's stop vertical to be safe so we don't fall through the floor or some shit.
        velocity.r = pForward.r;
        position.r = oldPosition.r;
      }
    }

    //println("position: "+position+" velocity: " + velocity + ", targetVelocity: " + targetVelocity + " accel: " + accel);

    //Fire gun
    if (input.shootKeyDown &&
        (millis() - lastTimeFiredMs > fireIntervalMs)) {
      shoot();
      lastTimeFiredMs = millis();
    }

    //Set sprite facing
    if (targetVelocity.t > 0) {
      sprite.setState(onGround ? configManager.moveRightAnimation : configManager.jumpUpRightAnimation);
      sprite.play();
    } else if (targetVelocity.t < 0) {
      sprite.setState(onGround ? configManager.moveLeftAnimation : configManager.jumpUpLeftAnimation);
      sprite.play();
    } else {
      if (input.heading.x >= 0) {
        sprite.setState(onGround ? configManager.idleLeftAnimation : configManager.jumpUpLeftAnimation);
      } else {
        sprite.setState(onGround ? configManager.idleRightAnimation : configManager.jumpUpRightAnimation);
      }
      sprite.play();
    }
  }

  void shoot() {
    Bullet bullet = new Bullet();
    bullet.friendly = true;
    bullet.position = position.get();
    bullet.position.r += fireHeight;
    bullet.velocity.t = velocity.t + -(bulletVelocity * input.heading.x);
    bullet.velocity.r = input.heading.y;
    bullets.add(bullet);
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

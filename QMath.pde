/**
 * Math helper library for Processing
 *
 * @author Eliot Lash
 * @copyright Copyright (c) 2010-2012 Eliot Lash
 */
static class QMath {

  /**
   * Based on code from http://www.shiffman.net/2011/02/03/rotate-a-vector-processing-js/
   */
  static PVector rotatePVector2D(PVector _v, float theta) {
    PVector v = _v.get();
    v.x = _v.x * cos(theta) - _v.y * sin(theta);
    v.y = _v.x * sin(theta) + _v.y * cos(theta);

    return v;
  }

  static boolean isFurtherThan(float a, float b, float range) {
    return (abs(a - b) > range);
  }

  // modulu - similar to matlab's mod()
  // result is always possitive. not similar to fmod()
  // Mod(-3,4)= 1   fmod(-3,4)= -3
  static float mod(float x, float y)
  {
      if (0 == y)
          return x;

      return x - y * floor(x/y);
  }

  // wrap [rad] angle to [-PI..PI)
  static float wrapPosNegPI(float fAng)
  {
      return mod(fAng + PI, TWO_PI) - PI;
  }

  // wrap [rad] angle to [0..TWO_PI)
  static float wrapTwoPI(float fAng)
  {
      return mod(fAng, TWO_PI);
  }
  static float getConstantRadialDistanceCoefficient(float radius, float theta) {
      if (theta == pForward.t) {
        return 1;
      }
      float arcLength = radius * radians(1);
      float constantDistanceCoefficient = abs(theta) / arcLength;
      //println("arcLength =" +arcLength+ ", theta = "+theta+",f = " + constantVelocityCoefficient);
      return constantDistanceCoefficient;
  }
}

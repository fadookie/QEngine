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

  boolean isFurtherThan(float a, float b, float range) {
    return (abs(a - b) > range);
  }
}

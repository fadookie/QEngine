class PolarCoord {
  float r; //Distance from center in radians
  float t; //

  PolarCoord() {
    r = 0;
    t = radians(0);
  }

  PolarCoord(float _r, float _t) {
    r = _r;
    t = _t;
  }

  PVector getCartesianCoords() {
    return new PVector(
        r * cos(t),
        r * sin(t)
    );
  }
}

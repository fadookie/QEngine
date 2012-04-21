class Arc {
  float startAngle;
  float stopAngle;
  float maxRadius;
  float minRadius;
  PVector center;

  Arc() {
    center = new PVector();
  }

  void debugDraw() {
    pushStyle();
    noFill();
    ellipseMode(RADIUS);
    arc(center.x, center.y, maxRadius, maxRadius, startAngle, stopAngle);
    arc(center.x, center.y, minRadius, minRadius, startAngle, stopAngle);
    popStyle();
  }
}

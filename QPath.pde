/**
 * This class is used to repsresent a path of points (represented as PVectors.)
 * It can manage the length of these paths to enforce a maximum. 
 *
 * @author Eliot Lash
 * @copyright Copyright (c) 2010-2012 Eliot Lash
 */
class QPath {

  ArrayList<PVector> points;
  float length = 0.0;
  boolean lengthChanged = false;

  QPath() {
    points = new ArrayList<PVector>();
  }

  /**
   * @return boolean True on successful add, false on failed add (path would exceed max length)
   */
  boolean add(PVector point) {
    float newLength = newLength(point);
    //No need for max path length in this game
    //if (newLength <= maxPathLength) {
    points.add(point);
    length = newLength;
    return true;
    /*} else {
      return false;
    }*/
  }

  float newLength(PVector point) {
    PVector lastPoint = lastPoint();
    if (null != lastPoint) {
      return length() + point.dist(lastPoint);
    } else {
      length = 0.0;
      lengthChanged = false; //We just calculated that length is 0 since path length is 0 so we'll keep that calculation... hope this doesn't bite me in the ass later
      return length;
    }
  }

  /**
   * Reduces points array to distance float, if the length was flagged as changed, otherwise uses stored float value.
   * Fake lazy seq :(
   */
  float length() {
    float newLength = 0.0;
    if (lengthChanged) {
      PVector previousPoint = null;
      for (PVector currentPoint : points) {
        if (previousPoint == null) {
          previousPoint = currentPoint;
        }

        newLength += currentPoint.dist(previousPoint);
        previousPoint = currentPoint;
      }
    } else {
      newLength = length;
    }

    return newLength;
  }

  PVector get(int i) {
    return points.get(i);
  }

  void set(int i, PVector point) {
    points.set(i, point);
    lengthChanged = true;
  }

  void clear() {
    points = new ArrayList<PVector>();
    length = 0.0;
  }

  void remove(int i) {
    points.remove(i);
    lengthChanged = true;
  }

  int size() {
    return points.size();
  }

  PVector lastPoint() {
    PVector lastPoint = null;
    if (lastElementIndex() >= 0) {
      lastPoint = points.get(lastElementIndex());
    }
    return lastPoint;
  }

  int lastElementIndex() {
    return points.size() - 1;
  }

  //Draw path
  void draw() {
    //println("draw begin @ " + points.size());
    pushStyle();
    stroke(color(255, 0, 0));
    strokeWeight(2);
    strokeJoin(ROUND);

    for (int i = 0; i < (points.size() - 2); i++) {
      //println("draw " + i + "/" + points.size());
      PVector currentVector = points.get(i);
      PVector nextVector = points.get(i+1);
      PVector thirdVector = points.get(i+2);
      line(currentVector.x, currentVector.y, nextVector.x, nextVector.y);
      //println("line(" + currentVector.x + "," + currentVector.y + "," + nextVector.x + "," + nextVector.y + ")");
      line(nextVector.x, nextVector.y, thirdVector.x, thirdVector.y);
    }
    popStyle();
  }

  String toString() {
    return points.toString();
  }
}

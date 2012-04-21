/**
 * Base class (pseudo-interface) for all game states,
 * inherit from this class or a subclass to define your custom game states
 *
 * @author Eliot Lash
 * @copyright Copyright (c) 2010-2012 Eliot Lash
 */
class QGameState {
  //'Virtual' methods to be overriden in subclasses
  void setup() {
  }

  void cleanup() {
  }

  void pause() {
  }

  void resume(QGameState previousState) {
  }

  void update() {
  }

  void draw() {
  }

  void mouseDragged() {
  }

  void mousePressed() {
  }

  void mouseReleased() {
  }

  void keyPressed() {
  }

  void keyReleased() {
  }

}

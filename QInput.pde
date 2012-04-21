/**
 * An input wrapper. Feel free to modify this for your needs. 
 *
 * @author Eliot Lash
 * @copyright Copyright (c) 2010-2012 Eliot Lash
 */
class QInput {
  boolean useMouse = false;

  boolean centerKeyDown = false;
  boolean upKeyDown = false;
  boolean downKeyDown = false;
  boolean leftKeyDown = false;
  boolean rightKeyDown = false;
  boolean scaleXNegativeKeyDown = false;
  boolean scaleXPositiveKeyDown = false;
  boolean scaleYNegativeKeyDown = false;
  boolean scaleYPositiveKeyDown = false;
  boolean scaleModKeyDown = false;

  PVector heading;
  float rotation;

  QKey CENTER_KEY;
  QKey UP_KEY;
  QKey DOWN_KEY;
  QKey LEFT_KEY;
  QKey RIGHT_KEY;
  QKey SCALE_MOD_KEY;
  QKey SCALE_X_POSITIVE_KEY;
  QKey SCALE_X_NEGATIVE_KEY;
  QKey SCALE_Y_POSITIVE_KEY;
  QKey SCALE_Y_NEGATIVE_KEY;

  QInput() {
    heading = forward.get();
    CENTER_KEY = new QKey();
    UP_KEY = new QKey();
    DOWN_KEY = new QKey();
    LEFT_KEY = new QKey();
    RIGHT_KEY = new QKey();
    SCALE_MOD_KEY = new QKey();
    SCALE_X_POSITIVE_KEY = new QKey();
    SCALE_X_NEGATIVE_KEY = new QKey();
    SCALE_Y_POSITIVE_KEY = new QKey();
    SCALE_Y_NEGATIVE_KEY = new QKey();
  }

  /**
   * Copy constructor.
   */
  QInput(QInput otherInput) {
    scaleModKeyDown = otherInput.scaleModKeyDown;
    upKeyDown = otherInput.upKeyDown;
    downKeyDown = otherInput.downKeyDown;
    leftKeyDown = otherInput.leftKeyDown;
    rightKeyDown = otherInput.rightKeyDown;
    scaleXNegativeKeyDown = otherInput.scaleXNegativeKeyDown;
    scaleXPositiveKeyDown = otherInput.scaleXPositiveKeyDown;
    scaleYNegativeKeyDown = otherInput.scaleYNegativeKeyDown;
    scaleYPositiveKeyDown = otherInput.scaleYPositiveKeyDown;

    CENTER_KEY = otherInput.CENTER_KEY;
    UP_KEY = otherInput.UP_KEY;
    DOWN_KEY = otherInput.DOWN_KEY;
    LEFT_KEY = otherInput.LEFT_KEY;
    RIGHT_KEY = otherInput.RIGHT_KEY;
    SCALE_MOD_KEY = otherInput.SCALE_MOD_KEY;
    SCALE_X_POSITIVE_KEY = otherInput.SCALE_X_POSITIVE_KEY;
    SCALE_X_NEGATIVE_KEY = otherInput.SCALE_X_NEGATIVE_KEY;
    SCALE_Y_POSITIVE_KEY = otherInput.SCALE_Y_POSITIVE_KEY;
    SCALE_Y_NEGATIVE_KEY = otherInput.SCALE_Y_NEGATIVE_KEY;
  }

  void keyPressed(QKey k) {
    setKeyDown(k, true);
  }

  void keyReleased(QKey k) {
    setKeyDown(k, false);
  }

  private void setKeyDown(QKey k, boolean down) {
    if (CENTER_KEY.equals(k)) {
      centerKeyDown = down;
    } else if (UP_KEY.equals(k)) {
      upKeyDown = down;
    } else if (DOWN_KEY.equals(k)) {
      downKeyDown = down;
    } else if (LEFT_KEY.equals(k)) {
      leftKeyDown = down;
    } else if (RIGHT_KEY.equals(k)) {
      rightKeyDown = down;
    } else if (SCALE_MOD_KEY.equals(k)) {
      scaleModKeyDown = down;
    } else if (SCALE_X_NEGATIVE_KEY.equals(k)) {
      scaleXPositiveKeyDown = down;
    } else if (SCALE_X_POSITIVE_KEY.equals(k)) {
      scaleXNegativeKeyDown = down;
    } else if (SCALE_Y_NEGATIVE_KEY.equals(k)) {
      scaleYPositiveKeyDown = down;
    } else if (SCALE_Y_POSITIVE_KEY.equals(k)) {
      scaleYNegativeKeyDown = down;
    }
  }
}

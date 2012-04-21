/**
 * This state displays a message before transitioning to another game state.
 * If displayLengthMs is set, the interstitial will automatically transition after the specified time has elapsed.
 * The transition will also occur if a key or mouse button is pressed.
 *
 * @author Eliot Lash
 * @copyright Copyright (c) 2010-2012 Eliot Lash
 */
class QInterstitialState extends QGameState {
  String message;
  QGameState nextState;
  boolean resetStateStack = false;
  color backgroundColor = color(66);
  int verticalOffset = -50;
  float displayLengthMs = -1;
  float displayStartMs = 0;

  QInterstitialState(String _message, QGameState _nextState) {
    super();
    message = _message;
    nextState = _nextState;
  }

  QInterstitialState(String _message, QGameState _nextState, float _displayLengthMs) {
    super();
    message = _message;
    nextState = _nextState;
    displayLengthMs = _displayLengthMs;
  }

  QInterstitialState(String _message, QGameState _nextState, int _verticalOffset) {
    super();
    message = _message;
    nextState = _nextState;
    verticalOffset = _verticalOffset;
  }

  QInterstitialState(String _message, QGameState _nextState, boolean _resetStateStack) {
    super();
    message = _message;
    nextState = _nextState;
    resetStateStack = _resetStateStack;
  }

  QInterstitialState(String _message, QGameState _nextState, boolean _resetStateStack, color _backgroundColor) {
    super();
    message = _message;
    nextState = _nextState;
    resetStateStack = _resetStateStack;
    backgroundColor = _backgroundColor;
  }

  void setup() {
  }

  void update() {
    if (displayLengthMs >= 0) {
      if (displayStartMs == 0) {
        displayStartMs = millis(); //Set timer
      } else {
        if((millis() - displayStartMs) > displayLengthMs) {
          //Timer's up, close this message
          goToNextState();
        }
      }
    }
  }

  void draw() {
    smooth();
    background(backgroundColor);
    textFont(helvetica48);
    textAlign(CENTER);
    fill(255);
    text(message, width/2, (height/2 + verticalOffset)); 
  }

  void mousePressed() {
    goToNextState();
  }

  void keyPressed() {
    goToNextState();
  }

  void goToNextState() {
    if (resetStateStack) {
      engineResetToState(nextState);
    } else {
      engineChangeState(nextState);
    }
  }

}

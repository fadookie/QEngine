/**
 * A simple class that represents a keypress in Processing.
 * Used to pass keypresses from the game to a QInput object,
 * and to bind abstracted controls to actual keys inside a QInput object.
 *
 * @author Eliot Lash
 * @copyright Copyright (c) 2010-2012 Eliot Lash
 */
class QKey {
  boolean coded = false;
  char myKey = 0;
  int myKeyCode = 0; 

  QKey() {
  }

  QKey(char _key, int _keyCode) {
    coded = (CODED == key);
    myKey = _key;
    myKeyCode = _keyCode;
  }

  QKey(char _key) {
    myKey = _key; 
    coded = false;
  }

  QKey(int _keyCode, boolean _coded) {
    coded = _coded;
    myKeyCode = _keyCode;
    if (!coded) {
      println("Unexpected invocation of QKey(int, boolean) with boolean set to false. Continuing.");
    }
  }


  boolean equals(QKey k) {
    if (coded && k.coded) {
      return myKeyCode == k.myKeyCode;
    } else if (!coded && !k.coded) {
      return myKey == k.myKey;
    }
    return false;
  }

  String toString() {
    return "Key : " + myKey + " KeyCode : " + myKeyCode + " Coded : " + coded;
  }
}

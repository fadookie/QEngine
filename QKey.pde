/**
 * A simple class that represents a keypress in Processing.
 * Used to pass keypresses from the game to a QInput object,
 * and to bind abstracted controls to actual keys inside a QInput object.
 *
 * @author Eliot Lash
 * @copyright Copyright (c) 2010-2012 Eliot Lash
 */
class QKey {
  boolean[] coded;
  char[] myKeys;
  int[] myKeyCodes; 
  int numKeys = 1;

  QKey() {
  }

  QKey(char _key) {
    //println("QKey = " + _key);
    myKeys = new char[1];
    coded = new boolean[1];
    myKeys[0] = _key; 
    coded[0] = false;
  }

  QKey(char... _keys) {
    //println("char... _keys = "+ _keys);
    myKeys = _keys;
    coded = new boolean[_keys.length];
    for (int i = 0; i < coded.length; i++) {
      coded[i] = false;
    }
  }

  QKey(int _keyCode, boolean _coded) {
    //println("QKey = " + _keyCode + ", coded " + _coded);
    myKeyCodes = new int[1];
    coded = new boolean[1];
    coded[0] = _coded;
    myKeyCodes[0] = _keyCode;
    if (!coded[0]) {
      println("Unexpected invocation of QKey(int, boolean) with boolean set to false. Continuing.");
    }
  }

  //WTF.. apparently java can't tell the difference betweent this constructor and the char... one???
  void init(char _key, int _keyCode) {
    //println("QKey = " + _key + ", keyCode " + _keyCode);
    myKeys = new char[1];
    myKeyCodes = new int[1];
    coded = new boolean[1];
    coded[0] = (CODED == key);
    myKeys[0] = _key;
    myKeyCodes[0] = _keyCode;
  }

  boolean equals(QKey k) {
    boolean equals = false;
    //FIXME: make this work for multi-key definitions that overlap
    if (k.numKeys == 1) {
      for (int i = 0; i < numKeys; i++) {
        if (coded[i] && k.coded[0]) {
          if(myKeyCodes[i] == k.myKeyCodes[0]) {
            equals = true;
          }
        } else if (!coded[i] && !k.coded[0]) {
          if(myKeys[i] == k.myKeys[0]) {
            equals = true;
          }
        }
      }
    }

    if (numKeys == k.numKeys) {
      for (int i = 0; i < numKeys; i++) {
        if (coded[i] && k.coded[i]) {
          if(myKeyCodes[i] == k.myKeyCodes[i]) {
            equals = true;
          }
        } else if (!coded[i] && !k.coded[i]) {
          if(myKeys[i] == k.myKeys[i]) {
            equals = true;
          }
        }
      }
    }
    return equals;
  }

  String toString() {
    String description = "";
    for (int i = 0; i < numKeys; i++) {
      description += "Key "+i+": " + myKeys[i] + " KeyCode "+i+": " + myKeyCodes[i]+ " Coded : " + coded[i] + "\n";
    }
    return description;
  }
}

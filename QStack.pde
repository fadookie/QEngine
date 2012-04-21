/**
 * A simple stack collection, hopefully usable in all flavors of Processing.
 *
 * @author Eliot Lash
 * @copyright Copyright (c) 2010-2012 Eliot Lash
 */
class QStack extends ArrayList {

  /**
   * Push an object onto the stack
   */
  void push(Object o) {
    this.add(o);
  }

  /**
   * Pop an object off the stack
   * @return Object The Object on top of the stack, or null if stack is empty. 
   */
  Object pop() {
    int lastElement = this.lastElementIndex();
    Object returnObject = null;
    if (lastElement >= 0) {
      returnObject = this.get(lastElement);
      this.remove(lastElement);
    }
    return returnObject;
  }

  /**
   * Peek at the object on the top of the stack
   * @return Object The Object on top of the stack, or null if stack is empty. 
   */
  Object peek() {
    int lastElement = this.lastElementIndex();
    Object returnObject = null;
    if (lastElement >= 0) {
      returnObject = this.get(lastElement);
    }
    return returnObject;
  }

  /**
   * Helper to get the array index of the last element on the stack
   * @return int Array index of last element. Negative values indicate that the stack is empty.
   */
  private int lastElementIndex() {
    return (this.size() - 1);
  }

}

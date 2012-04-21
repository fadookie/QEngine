/**
 * QEngine, a game template for Processing
 *
 * @author Eliot Lash
 * @copyright Copyright (c) 2010-2012 Eliot Lash
 */


/**
 * A define for whether or not to build the engine in "debug" mode.
 * This generally means more output to the console and possibly some extra stuff drawn to the screen.
 */
static final boolean DEBUG = false;

/** This property holds how much time elapsed since QGameState.update() was last called, in milliseconds.
 * Please don't modify this from your code. */
float deltaTime = -1.0;

/** Stack to hold the game states in use.
 * Please don't access this directly, use the engine state functions. */
QStack states;

//Some unit vectors that should always be the same, for calculations. Modify these on peril of your own sanity.
/** Vector facing the top of the screen */
PVector forward;
/** Vector facing the bottom of the screen */
PVector back;
/** Vector facing the left of the screen */
PVector left;
/** Vector facing the right of the screen */
PVector right;
/** 2D Cartesian point representing the center of the screen */
PVector centerOfScreen;

/** Default length of time in milliseconds that InterstitialStates will display before advancing to the next state. */
float interstitialLengthMs = 1000;

/**
 * Some reusable PVector objects which can be used instead of creating new PVectors inside tight loops to reduce garbage during calculations.
 * Assign to components of these vectors if you want to, but keep in mind there might be old data sitting in one of the unused components unless you set it to zero.
 */
PVector gWorkVectorA;
PVector gWorkVectorB;
PVector gWorkVectorC;


/**
 * If you need global resources, this might be a good place to define them.
 */
PFont helvetica48; //A default font


//What follows are engine functions. I reccommend defining logic specific to your game inside of a series of QGameState-derived classes.

void setup() {
  /** Set your size here */
  size(1024, 768);
  smooth();

  states = new QStack();
  forward = new PVector(0, 1);
  back = new PVector(0, -1);
  left = new PVector(1, 0);
  right = new PVector(-1, 0);
  centerOfScreen = new PVector(width / 2, height / 2);

  gWorkVectorA = new PVector();
  gWorkVectorB = new PVector();
  gWorkVectorC = new PVector();

  //helvetica48 = loadFont("Helvetica-48.vlw");

  //Code to add handler for mouse wheel events, commenting out for js compatibility
  /*
  addMouseWheelListener(new java.awt.event.MouseWheelListener() { 
   public void mouseWheelMoved(java.awt.event.MouseWheelEvent evt) { 
   mouseWheel(evt.getWheelRotation());
  }});
  */

  /** Begin initial game state - Replace "ExampleState" with your custom gamestate you want to run first. */
  engineChangeState(new ExampleState());
}

/**
 * Listener for Mouse wheel movement
 */
/* //Not using mouse ATM for js compatibility
 void mouseWheel(int delta) {
   println(delta); 
 }
 */

void mouseDragged() {
  engineGetState().mouseDragged();
}

void mousePressed() {
  engineGetState().mousePressed();
}

void mouseReleased() {
  engineGetState().mouseReleased();
}

void keyPressed() {
  engineGetState().keyPressed();
}

void keyReleased() {
  engineGetState().keyReleased();
}

/**
 * Return a reference to the main PApplet instance for this sketch.
 * Where in a normal Processing sketch you might initialize a library
 * from the main class like so:
 * Fisica.init(this);
 * When initializing a library from a QGameState, you need to do:
 * Fisica.init(getMainInstance());
 * */
PApplet getMainInstance() {
  return this;
}

/**
 * 
 */
void draw() {
  engineGetState().update();
  engineGetState().draw();
}

QGameState engineGetState() {
  if (!states.isEmpty()) {
    return (QGameState)states.peek();
  } 
  else {
    return null;
  }
}

void engineChangeState(QGameState state) {
  //Cleanup current state
  if (!states.isEmpty()) {
    QGameState currentState = (QGameState)states.peek();
    currentState.cleanup();
    states.pop();
  }

  //Store and setup new state
  states.push(state);
  state.setup();
}

void enginePushState(QGameState state) {
  //Cleanup current state
  if (!states.isEmpty()) {
    QGameState currentState = (QGameState)states.peek();
    currentState.pause();
  }

  //Store and setup new state
  states.push(state);
  state.setup();
}

void enginePopState() {
  QGameState previousState = null;
  //Cleanup current state
  if (!states.isEmpty()) {
    QGameState currentState = (QGameState)states.peek();
    currentState.cleanup();
    previousState = currentState;
    states.pop();
  }

  //Resume previous state
  if (!states.isEmpty()) {
    QGameState currentState = (QGameState)states.peek();
    currentState.resume(previousState);
  }
}

/**
 * Clear the state stack in reverse order, 
 */
void engineResetToState(QGameState state) {
  //Empty out current state stack, giving each state a chance to run cleanup()
  if (!states.isEmpty()) {
    for (int i = states.size(); i > 0;) {
      QGameState currentState = (QGameState)states.peek();
      currentState.cleanup();
      states.pop();
      i = states.size();
    }
  }

  engineChangeState(state);
}


/**
 * QEngine, a game template for Processing
 *
 * @author Eliot Lash
 * @copyright Copyright (c) 2010-2012 Eliot Lash
 */

import ddf.minim.*;
Minim minim;
AudioPlayer music;

//Might need these at some point...
import processing.opengl.*;
import javax.media.opengl.GL;
PGraphicsOpenGL pgl;

/**
 * A define for whether or not to build the engine in "debug" mode.
 * This generally means more output to the console and possibly some extra stuff drawn to the screen.
 */
static final boolean DEBUG = false;

/** This property holds how much time elapsed since QGameState.update() was last called, in milliseconds.
 * Please don't modify this from your code. */
float deltaTime = -1.0;
float lastUpdateTimeMs = 0;

/** Stack to hold the game states in use.
 * Please don't access this directly, use the engine state functions. */
QStack states;

ContentManager contentManager;
ConfigManager configManager;

//Some unit vectors that should always be the same, for calculations. Modify these on peril of your own sanity.
/** Vector facing the top of the screen */
PVector forward;
/** Vector facing the bottom of the screen */
PVector back;
/** Vector facing the left of the screen */
PVector left;
/** Vector facing the right of the screen */
PVector right;
/** Zero vector */
PVector zero;
/** 2D Cartesian point representing the center of the screen */
PVector centerOfScreen;

/** Default length of time in milliseconds that InterstitialStates will display before advancing to the next state. */
float interstitialLengthMs = 1000;

HashMap<String, PImage> imageRegistry; //Load a PImage once and throw it in here to prevent having to load it again
HashMap<String, PImage[]> animationFrameRegistry; //Load a PImage[] once and throw it in here to prevent having to load it again

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

ArrayList<Arc> arcs;
ArrayList<Bullet> bullets;
static PolarCoord pForward;
float fortyFiveRadians;

//Top of one ring to top of next = 308 px
float worldCoreSize = 244;
float ringDistance = 245; //Distance between main rings
float ringThickness = 62;

color[] bulletColors = new color[Bullet.numTypes];

//What follows are engine functions. I reccommend defining logic specific to your game inside of a series of QGameState-derived classes.

void setup() {
  /** Set your size here */
  size(1024, 768, OPENGL);
  //size(1280, 1024, OPENGL);
  //smooth();

  minim = new Minim(this);
  pgl = (PGraphicsOpenGL)g;

  states = new QStack();
  forward = new PVector(0, 1);
  back = new PVector(0, -1);
  left = new PVector(1, 0);
  right = new PVector(-1, 0);
  zero = new PVector(0, 0);
  centerOfScreen = new PVector(width / 2, height / 2);

  imageRegistry     = new HashMap<String,PImage>();
  animationFrameRegistry = new HashMap<String,PImage[]>(); 

  gWorkVectorA = new PVector();
  gWorkVectorB = new PVector();
  gWorkVectorC = new PVector();

  helvetica48 = loadFont("Helvetica-48.vlw");
  pForward = new PolarCoord();
  fortyFiveRadians = radians(45);

  bulletColors[Bullet.BULLET_TYPE] = color(255, 205, 56);
  bulletColors[Bullet.MISSILE_TYPE] = color(250, 250, 210);
  bulletColors[Bullet.RAYGUN_TYPE] = color(63, 244, 255);

  //Code to add handler for mouse wheel events, commenting out for js compatibility
  /*
  addMouseWheelListener(new java.awt.event.MouseWheelListener() { 
   public void mouseWheelMoved(java.awt.event.MouseWheelEvent evt) { 
   mouseWheel(evt.getWheelRotation());
  }});
  */

  /** Begin initial game state - Replace "ExampleState" with your custom gamestate you want to run first. */
  engineChangeState(new LoadScreenState());
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
  deltaTime = millis() - lastUpdateTimeMs;
  engineGetState().update();
  lastUpdateTimeMs = millis();

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

void stop() {
  //Let the states clean up
  while (engineGetState() != null) {
    enginePopState();
  }
  minim.stop();
  super.stop();
}

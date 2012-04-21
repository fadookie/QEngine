class ExampleState extends QGameState {
  boolean gameOver = false;
  int numPlayers = 1;
  PlayerController[] players;
  ArrayList<Arc> arcs;

  void setup() {
    players = new PlayerController[numPlayers];
    for (int i = 0; i < players.length; i++) {
      players[i] = new PlayerController();
    }

    arcs = new ArrayList<Arc>(); 
    {
      Arc arc = new Arc();
      arc.startAngle = radians(0);
      arc.stopAngle = radians(45);
      arc.minRadius = 100;
      arc.maxRadius = 200;
      arc.center = centerOfScreen;
      arcs.add(arc);
    }
  }

  void cleanup() {
  }

  void pause() {
  }

  void resume(QGameState previousState) {
  }

  void update() {
    //Check for win condition
    if (gameOver) {
      engineChangeState(new QInterstitialState("Game over!", new ExampleState()));
    }
  }

  void draw() {
    background(66);

    for (Arc arc : arcs) {
      arc.debugDraw();
    }
    //Debug draw
    if (DEBUG) {
    }
  }

  void mouseDragged() {
  }

  void mousePressed() {
  }

  void mouseReleased() {
  }

  void keyPressed() {
    QKey k = new QKey(key, keyCode);
    //println("Key pressed - " + k);

    for (PlayerController player : players) {
      player.input.keyPressed(k);
    }

    if (CODED == key) {
    } else {
      //DEBUG keys
      if (DEBUG) {
      } 
    }
  }

  void keyReleased() {
    QKey k = new QKey(key, keyCode);

    for (PlayerController player : players) {
      player.input.keyReleased(k);
    }
  }
}

class ExampleState extends QGameState {
  boolean gameOver = false;
  int numPlayers = 1;
  PlayerController[] players;
  PlayerController player;

  void setup() {
    players = new PlayerController[numPlayers];
    for (int i = 0; i < players.length; i++) {
      players[i] = new PlayerController();
      players[i].center = centerOfScreen;
    }

    player = players[0];

    {
      QInput input = player.input;

      input.CENTER_KEY = new QKey('/');
      input.UP_KEY = new QKey(UP, true);
      input.DOWN_KEY = new QKey(DOWN, true);
      input.LEFT_KEY = new QKey(LEFT, true);
      input.RIGHT_KEY = new QKey(RIGHT, true);
      input.SCALE_MOD_KEY = new QKey(ALT, true);
      input.SCALE_X_NEGATIVE_KEY = new QKey('j');
      input.SCALE_X_POSITIVE_KEY = new QKey('l');
      input.SCALE_Y_NEGATIVE_KEY = new QKey('k');
      input.SCALE_Y_POSITIVE_KEY = new QKey('i');
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
    {
      Arc arc = new Arc();
      arc.startAngle = radians(180);
      arc.stopAngle = radians(270);
      arc.minRadius = 200;
      arc.maxRadius = 400;
      arc.center = centerOfScreen;
      arcs.add(arc);
    }
    {
      Arc arc = new Arc();
      arc.startAngle = radians(90);
      arc.stopAngle = radians(180);
      arc.minRadius = 1;
      arc.maxRadius = 100;
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
    for (PlayerController player : players) {
      player.update();
    }

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

    for (PlayerController player : players) {
      player.debugDraw();
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

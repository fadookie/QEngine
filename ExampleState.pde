class ExampleState extends QGameState {
  boolean gameOver = false;
  int numPlayers = 1;
  PlayerController[] players;
  PlayerController player;
  Tileset background;
  Tileset foreground;

  void setup() {
    players = new PlayerController[numPlayers];
    for (int i = 0; i < players.length; i++) {
      players[i] = new PlayerController();
      players[i].center = zero;
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
      arcs.add(arc);
    }
    {
      Arc arc = new Arc();
      arc.startAngle = radians(92);
      arc.stopAngle = radians(355);
      arc.minRadius = 200;
      arc.maxRadius = 220;
      arcs.add(arc);
    }
    {
      Arc arc = new Arc();
      arc.startAngle = radians(90);
      arc.stopAngle = radians(180);
      arc.minRadius = 200;
      arc.maxRadius = 400;
      arc.sprite.setImage("temparc.png");
      arcs.add(arc);
    }
    {
      Arc arc = new Arc();
      arc.startAngle = radians(90);
      arc.stopAngle = radians(180);
      arc.minRadius = 1;
      arc.maxRadius = 100;
      arcs.add(arc);
    }

    foreground = new Tileset(6, 6);
    foreground.loadImagesFromPrefix("planetoid-fg/planetoid-fg_");

    background = new Tileset(6, 6);
    background.loadImagesFromPrefix("planetoid-bg/planetoid-bg_");
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
    pushMatrix();
    //Game camera
    translate(centerOfScreen.x, centerOfScreen.y);
    rotate(-player.position.t);
    pushMatrix();
    PVector playerPos = player.position.getCartesianCoords();
    rotate(radians(-90));
    scale(0.1);
    translate(-playerPos.x, -playerPos.y);

    background(66);
    background.draw(playerPos);

    //Draw world core for debugging
    if (DEBUG) {
      pushStyle();
      fill(99);
      ellipseMode(RADIUS);
      ellipse(zero.x, zero.y, worldCoreSize, worldCoreSize);
      popStyle();
    }

    for (Arc arc : arcs) {
      arc.draw();
      if (DEBUG) {
        arc.debugDraw();
        //arc.collidesWithDebug(player.oldPosition, player.position);
      }
    }

    for (PlayerController player : players) {
      if (DEBUG) {
        player.debugDraw();
      }
    }

    foreground.draw(playerPos);

    popMatrix();
    popMatrix();
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

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
    player.position.r = 308;

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

    //Ring 1
    //addArc(retardedAngle(211), retardedAngle(254), 554, 617);
    addArc(retardedAngle(211), retardedAngle(254), 1);

    //Ring 2
    addArc(0, retardedAngle(344), 554, 900); //Wall
    addArc(retardedAngle(6), retardedAngle(344), 2);
    addArc(retardedAngle(332), retardedAngle(77), 2);
    addArc(retardedAngle(57), retardedAngle(18), 2);

    foreground = new Tileset(6, 6);
    //foreground.pos.x = 0;
    //foreground.pos.y = 0;
    foreground.pos.x = -3072; //(1024 tile size * 6 tiles) / 2
    foreground.pos.y = -3072;
    foreground.loadImagesFromPrefix("planetoid-fg/planetoid-fg_");

    background = new Tileset(6, 6);
    background.pos.x = -3072; //(1024 tile size * 6 tiles) / 2
    background.pos.y = -3072;
    background.loadImagesFromPrefix("planetoid-bg/planetoid-bg_");
  }

  //Convert retarded counterclockwise degrees from my retarded protractor to clockwise radians
  float retardedAngle(float theta) {
    return radians(360-theta);
  }

  void addArc(float startAngle, float stopAngle, int valence) {
    //UGH I need some sleep fuck this shit
    addArc(startAngle, stopAngle, (worldCoreSize + (ringDistance * valence) + (ringThickness * valence)) - ringThickness, (worldCoreSize + (ringDistance * valence) + (ringThickness * (valence + 1))) - ringThickness);
  }

  void addArc(float startAngle, float stopAngle, float minRadius, float maxRadius) {
    if (stopAngle < startAngle) {
      //This angle crosses the axis, split into two arcs
      Arc arc1 = new Arc();
      Arc arc2 = new Arc();
      arc1.startAngle = startAngle;
      arc1.stopAngle = TWO_PI;

      arc2.startAngle = 0;
      arc2.stopAngle = stopAngle;

      arc1.minRadius = minRadius;
      arc2.minRadius = minRadius;

      arc1.maxRadius = maxRadius;
      arc2.maxRadius = maxRadius;
      
      arcs.add(arc1);
      arcs.add(arc2);
    } else {
      Arc arc = new Arc();
      arc.startAngle = startAngle;
      arc.stopAngle = stopAngle;
      arc.minRadius = minRadius;
      arc.maxRadius = maxRadius;
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
    PVector playerPos = player.position.getCartesianCoords();

    pushMatrix();
    //Game camera
    translate(centerOfScreen.x, centerOfScreen.y);
    rotate(-player.position.t);
    rotate(radians(-90));
    //scale(0.1);
    translate(-playerPos.x, -playerPos.y);

    background(66);
    //background.draw(playerPos);

    for (PlayerController player : players) {
      if (DEBUG) {
        player.debugDraw();
      }
    }

    foreground.draw(playerPos);

    //Draw world core for debugging
    if (DEBUG) {
      pushStyle();
      noFill();
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

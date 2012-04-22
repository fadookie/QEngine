class ExampleState extends QGameState {
  boolean gameOver = false;
  int numPlayers = 1;
  PlayerController[] players;
  PlayerController player;
  Tileset background;
  Tileset foreground;
  PImage starfield;

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

    int ring;

    //Ring 0
    ring = 0;
    addArc(retardedAngle(16), retardedAngle(342), ring);
    addArc(retardedAngle(287), retardedAngle(253), ring);
    addArc(retardedAngle(196), retardedAngle(162), ring);
    addArc(retardedAngle(106), retardedAngle(72), ring);

    //Ring 1
    ring = 1;
    addArc(retardedAngle(170), retardedAngle(196), ring);

    //Ring 2
    ring = 2;
    addArc(retardedAngle(327), retardedAngle(80), ring);
    addArc(retardedAngle(5), retardedAngle(343), ring);
    //Walls
    addArc(0, retardedAngle(344), 554, 900);
    
    //Etc...
    ring = 3;
    addArc(retardedAngle(228), retardedAngle(123.5), ring);
    addArc(retardedAngle(77), retardedAngle(39), ring);
    addArc(retardedAngle(23), retardedAngle(245), ring);
    
    ring = 4;
    addArc(retardedAngle(346), retardedAngle(334), ring);
    addArc(retardedAngle(272), retardedAngle(254), ring);
    addArc(retardedAngle(241), retardedAngle(148), ring);
    addArc(retardedAngle(124), retardedAngle(100), ring);
    addArc(retardedAngle(92), retardedAngle(358), ring);

    ring = 5;
    addArc(retardedAngle(287), retardedAngle(206), ring);
    addArc(retardedAngle(195), retardedAngle(135), ring);
    addArc(retardedAngle(124), retardedAngle(325), ring);

    ring = 6;
    addArc(retardedAngle(357), retardedAngle(285), ring);
    addArc(retardedAngle(262), retardedAngle(240), ring);
    addArc(retardedAngle(231), retardedAngle(167), ring);
    addArc(retardedAngle(156), retardedAngle(93), ring);
    addArc(retardedAngle(85), retardedAngle(47), ring);
    addArc(retardedAngle(41), retardedAngle(10), ring);

    ring = 7;
    addArc(retardedAngle(327), retardedAngle(258), ring);
    addArc(retardedAngle(251), retardedAngle(215), ring);
    addArc(retardedAngle(183), retardedAngle(132), ring);
    addArc(retardedAngle(125), retardedAngle(6), ring);

    ring = 8;
    addArc(retardedAngle(346), retardedAngle(303), ring);
    addArc(retardedAngle(278), retardedAngle(203), ring);
    addArc(retardedAngle(166), retardedAngle(104), ring);
    addArc(retardedAngle(84), retardedAngle(21), ring);

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

    starfield = loadImage("Stars_BG.png");
  }

  //Convert retarded counterclockwise degrees from my retarded protractor to clockwise radians
  float retardedAngle(float theta) {
    return radians(360-theta);
  }

  void addArc(float startAngle, float stopAngle, int valence) {
    float minRadius = worldCoreSize + (ringDistance * valence) + (ringThickness * valence);
    addArc(startAngle, stopAngle, minRadius, minRadius + ringThickness);
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

    //background(0);

    //Draw starfield
    if (starfield.width > 0) {
      float playerPositionRatio = player.position.t / TWO_PI;
      playerPositionRatio -= 1;//Invert it
      textureMode(NORMALIZED);
      //PTexture tex = pgl.getTexture();
      //pgl.pgl.glTexParameterf(tex.glTarget, PGL.GL_TEXTURE_WRAP_S, PGL.GL_REPEAT);
      //beginShape();
      //texture(starfield);
      //vertex(0, 0, 0, playerPositionRatio, 0);
      //vertex(width, 0, 0, playerPositionRatio + 1, 0);
      //vertex(width, height, 0, playerPositionRatio + 1, 1);
      //vertex(0, height, 0, playerPositionRatio, 1);
      //endShape();

      image(starfield, playerPositionRatio * width, 0);
      image(starfield, (playerPositionRatio * width) + width, 0);
    }


    pushMatrix();
    //Game camera
    translate(centerOfScreen.x, centerOfScreen.y);
    rotate(-player.position.t);
    rotate(radians(-90));
    //scale(0.1);
    translate(-playerPos.x, -playerPos.y);

    background.draw(playerPos);

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

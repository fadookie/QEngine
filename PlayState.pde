class PlayState extends QGameState {
  boolean gameOver = false;
  int numPlayers = 1;
  PlayerController[] players;
  PlayerController player;
  Tileset background;
  Tileset foreground;
  PImage starfield;

  int screenshotCount = 0;

  void setup() {
    //Load content specified in content.xml
    contentManager = new ContentManager();
    contentManager.loadContent();

    //Load config
    configManager = new ConfigManager(); 
    configManager.loadConfig();

    players = new PlayerController[numPlayers];
    for (int i = 0; i < players.length; i++) {
      players[i] = new PlayerController(configManager.getUnitTemplate("Player"));
      players[i].center = zero;
    }

    player = players[0];
    //Start the player near the rocket ship
    player.position.r = 2763;
    player.position.t = 5.13441;

    {
      QInput input = player.input;

      input.CENTER_KEY = new QKey('/');
      input.UP_KEY = new QKey(UP, true);
      input.DOWN_KEY = new QKey(DOWN, true);
      input.LEFT_KEY = new QKey(LEFT, true);
      input.RIGHT_KEY = new QKey(RIGHT, true);
      input.SHOOT_KEY = new QKey('x');
      input.JUMP_KEY = new QKey('z', ' ');
      input.SCALE_MOD_KEY = new QKey(ALT, true);
      input.SCALE_X_NEGATIVE_KEY = new QKey('j');
      input.SCALE_X_POSITIVE_KEY = new QKey('l');
      input.SCALE_Y_NEGATIVE_KEY = new QKey('k');
      input.SCALE_Y_POSITIVE_KEY = new QKey('i');
    }

    arcs = new ArrayList<Arc>(); 
    bullets = new ArrayList<Bullet>(); 

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

    //Walls
    //addArc(0, retardedAngle(344), 554, 900); //Old way to define a wall
    addArc(0, retardedAngle(344), 1, 2);
    addArc(retardedAngle(143), retardedAngle(125), 1, 2);

    //Ring 2
    ring = 2;
    addArc(retardedAngle(327), retardedAngle(80), ring);
    addArc(retardedAngle(5), retardedAngle(343), ring);

    addArc(retardedAngle(331), retardedAngle(325), 2, 3);
    addArc(retardedAngle(162), retardedAngle(156), 2, 3);
    addArc(retardedAngle(113), retardedAngle(104), 2, 4);
    addArc(retardedAngle(29), retardedAngle(18), 2, 4);

    //Etc...
    ring = 3;
    addArc(retardedAngle(228), retardedAngle(123.5), ring);
    addArc(retardedAngle(77), retardedAngle(39), ring);
    addArc(retardedAngle(23), retardedAngle(245), ring);

    addArc(retardedAngle(314), retardedAngle(299), 3, 5);
    addArc(retardedAngle(272), retardedAngle(264), 3, 4);
    addArc(retardedAngle(195), retardedAngle(184), 3, 4);
    addArc(retardedAngle(187), retardedAngle(180), 3, 5);
    addArc(retardedAngle(71), retardedAngle(61), 3, 4);
    
    ring = 4;
    addArc(retardedAngle(346), retardedAngle(334), ring);
    addArc(retardedAngle(272), retardedAngle(254), ring);
    addArc(retardedAngle(241), retardedAngle(148), ring);
    addArc(retardedAngle(124), retardedAngle(100), ring);
    addArc(retardedAngle(92), retardedAngle(358), ring);

    addArc(retardedAngle(344), retardedAngle(337), 4, 5);
    addArc(retardedAngle(127), retardedAngle(121), 4, 6);

    ring = 5;
    addArc(retardedAngle(287), retardedAngle(206), ring);
    addArc(retardedAngle(195), retardedAngle(135), ring);
    addArc(retardedAngle(124), retardedAngle(325), ring);

    addArc(retardedAngle(349), retardedAngle(337), 5, 6);
    addArc(retardedAngle(292), retardedAngle(285), 5, 6);
    addArc(retardedAngle(287), retardedAngle(282), 5, 7);
    addArc(retardedAngle(248), retardedAngle(240), 5, 6);
    addArc(retardedAngle(244), retardedAngle(237), 5, 7);
    addArc(retardedAngle(171), retardedAngle(163), 5, 7);

    ring = 6;
    addArc(retardedAngle(357), retardedAngle(285), ring);
    addArc(retardedAngle(262), retardedAngle(240), ring);
    addArc(retardedAngle(231), retardedAngle(167), ring);
    addArc(retardedAngle(156), retardedAngle(93), ring);
    addArc(retardedAngle(85), retardedAngle(47), ring);
    addArc(retardedAngle(41), retardedAngle(10), ring);

    addArc(retardedAngle(53), retardedAngle(48), 6, 7);
    addArc(retardedAngle(13), retardedAngle(6), 6, 7);

    ring = 7;
    addArc(retardedAngle(327), retardedAngle(258), ring);
    addArc(retardedAngle(251), retardedAngle(215), ring);
    addArc(retardedAngle(183), retardedAngle(132), ring);
    addArc(retardedAngle(125), retardedAngle(6), ring);

    addArc(retardedAngle(334), retardedAngle(320), 7, 8);
    addArc(retardedAngle(243), retardedAngle(239), 7, 8);
    addArc(retardedAngle(153), retardedAngle(145), 7, 8);
    addArc(retardedAngle(71), retardedAngle(37), 7, 8);

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

    music = minim.loadFile("daniel.wav");
    music.loop();
    //music.play();
  }

  //Convert retarded counterclockwise degrees from my retarded protractor to clockwise radians
  float retardedAngle(float theta) {
    return radians(360-theta);
  }

  void addArc(float startAngle, float stopAngle, int valence) {
    addArc(startAngle, stopAngle, radiusFromValence(valence), radiusFromValence(valence) + ringThickness);
  }

  void addArc(float startAngle, float stopAngle, int startValence, int endValence) {
    addArc(startAngle, stopAngle, radiusFromValence(startValence), radiusFromValence(endValence) + ringThickness);
  }

  float radiusFromValence(int valence) {
    return worldCoreSize + (ringDistance * valence) + (ringThickness * valence);
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
    for (PlayerController player : players) {
      player.close();
    }
    music.close();
  }

  void pause() {
  }

  void resume(QGameState previousState) {
  }

  void update() {
    for (PlayerController player : players) {
      player.update();
    }

    Iterator<Bullet> bulletsIt = bullets.iterator();
    while (bulletsIt.hasNext()) {
        Bullet bullet = bulletsIt.next();
        bullet.update();
        if (bullet.removeFromScene) {
          bulletsIt.remove();
        }
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
      playerPositionRatio *= -1;//Invert it
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
      player.draw();
      if (DEBUG) {
        player.debugDraw();
      }
    }

    for (Bullet bullet : bullets) {
        bullet.draw();
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
    QKey k = new QKey();
    k.init(key, keyCode);
    //println("Key pressed - " + k);

    for (PlayerController player : players) {
      player.input.keyPressed(k);
    }

    if (CODED == key) {
    } else {
      if (key == 's') {
        try {
          saveFrame(String.format("screenshot%02d.png", screenshotCount));
          println("screenshot " + screenshotCount);
          screenshotCount++;
        } 
        catch (Exception e) {
        }
      } else if ('D' == key) {
        DEBUG = !DEBUG;
      }
      //DEBUG keys
      if (DEBUG) {
      } 
    }
  }

  void keyReleased() {
    QKey k = new QKey();
    k.init(key, keyCode);

    for (PlayerController player : players) {
      player.input.keyReleased(k);
    }
  }
}

class IggState extends QGameState {
  boolean gameOver = false;
  int numPlayers = 1;
  int initialEnemies = 10;
  int screenTintRed = 0;
  PlayerController[] players;
  ArrayList<EnemyController> enemies = new ArrayList();
  AudioPlayer player;

  void setup() {
    println("IGG RULES!");
    players = new PlayerController[numPlayers];
    for (int i = 0; i < players.length; i++) {
      players[i] = new PlayerController();
    }
    // load a file, give the AudioPlayer buffers that are 1024 samples long
    // player = minim.loadFile("groove.mp3");
    
    // load a file, give the AudioPlayer buffers that are 2048 samples long
    player = minim.loadFile("song.mp3", 2048);
    // play the file
    player.play();
  }

  void cleanup() {
    player.close();
  }

  void pause() {
  }

  void resume(QGameState previousState) {
  }

  void update() {
    for (PlayerController player : players) {
      player.sprite.position.x = mouseX;
      player.sprite.position.y = mouseY;
      player.update();
    }

    //add enemy if needed
    if (enemies.size() < initialEnemies) {
      enemies.add(new EnemyController(players[0].sprite.position));
      println("add enemy");
    }

    Iterator<EnemyController> i = enemies.iterator();
    while (i.hasNext()) {
       EnemyController enemy = i.next(); // must be called before you can call i.remove()
          enemy.update();
          if (enemy.collidesWith(players[0])) {
            screenTintRed = 255;
            players[0].damage();

          }

          //destroy OOB enemeies
          if ((enemy.sprite.position.x < 0 || enemy.sprite.position.x > width) || (enemy.sprite.position.y < 0 || enemy.sprite.position.y > height)) {
            i.remove();
          }
    }

    //Game ends when music ends
    if (!player.isPlaying() || players[0].health < 1) {
      gameOver = true;
    }



    //Check for win condition
    if (gameOver) {
      engineChangeState(new QInterstitialState("The End.\n\nIGG Rules!\n\nClick to play again.", new IggState()));
    }
  }

  void draw() {
    background(66);


    for (PlayerController player : players) {
      player.draw();
    }
    for (EnemyController enemy : enemies) {
      enemy.draw();
    }

    //HUD
    pushStyle();
    textAlign(CENTER);
    fill(255, 0, 0);
    text(players[0].health + " <3", 0, 0); 
    popStyle();


    if (screenTintRed > 0) {
      fill(255, 0, 0, screenTintRed);
      rectMode(CORNER);
      rect(0, 0, width, height);
      screenTintRed -= 8;
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
        if ('E' == key) {
          gameOver = true;
        }
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

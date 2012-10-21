class IggState extends QGameState {
  boolean gameOver = false;
  int numPlayers = 2;
  PlayerController[] players;

  void setup() {
    println("IGG RULES!");
    players = new PlayerController[numPlayers];
    for (int i = 0; i < players.length; i++) {
      players[i] = new PlayerController();
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
      player.sprite.position.x = mouseX;
      player.sprite.position.y = mouseY;
      player.update();
    }
    //Check for win condition
    if (gameOver) {
      engineChangeState(new QInterstitialState("Game over!", new IggState()));
    }
  }

  void draw() {
    background(66);


    for (PlayerController player : players) {
      player.draw();
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

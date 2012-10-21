class IggState extends QGameState {
  boolean gameOver = false;
  int numPlayers = 1;
  int initialEnemies = 10;
  PlayerController[] players;
  ArrayList<EnemyController> enemies = new ArrayList();

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

    //add enemy if needed
    if (enemies.size() < initialEnemies) {
      enemies.add(new EnemyController(players[0].sprite.position));
      println("add enemy");
    }

    Iterator<EnemyController> i = enemies.iterator();
    while (i.hasNext()) {
       EnemyController enemy = i.next(); // must be called before you can call i.remove()
          enemy.update();

          //destroy OOB enemeies
          if ((enemy.sprite.position.x < 0 || enemy.sprite.position.x > width) || (enemy.sprite.position.y < 0 || enemy.sprite.position.y > height)) {
            i.remove();
          }
    }

    for (EnemyController enemy : enemies) {

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
    for (EnemyController enemy : enemies) {
      enemy.draw();
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

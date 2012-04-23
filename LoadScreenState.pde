class LoadScreenState extends QGameState {
  PImage loadScreen;
  boolean finished = false;
  void setup() {
    loadScreen = loadImage("LoadScreen.png");
  }

  void draw() {
    if (!finished) {
      image(loadScreen, 0, 0);
      finished = true;
    } else {
      engineChangeState(new PlayState());
    }
  }
}

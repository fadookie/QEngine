class Tileset {
  int rows;
  int columns;
  PImage[][] tiles;
  String prefix;
  PVector pos;

  Tileset(int _rows, int _columns) {
    rows = _rows;
    columns = _columns;
    tiles = new PImage[rows][columns];
    pos = centerOfScreen;
  }

  void loadImagesFromPrefix(String _prefix) {
    prefix = _prefix;

    for (int i = 0; i < tiles.length; i++) {
      PImage[] tileRow = tiles[i];
      for (int j = 0; j < tileRow.length; j++) {
        //Skip upper left, lower left, upper right, & lower right quadrants as they are just blank pngs
        if (((i == 0) && (j == 0)) ||
            ((i == 0) && (j == columns - 1)) ||
            ((i == rows - 1) && (j == 0)) ||
            ((i == rows - 1) && (j == columns - 1))) {
            continue;
        }
        String filename = prefix + (i+1) + "_" + (j+1) + ".png";
        tileRow[j] = loadImage(filename);

        if (DEBUG) {
          println("loadImage("+filename+")");
        }
      }
    }
  }

  void draw(PVector _centerPosition) {
    PVector centerPosition = PVector.add(pos, _centerPosition);
    
    imageMode(CORNER);
    pushMatrix();
    translate(pos.x, pos.y);
    ellipseMode(RADIUS);
    ellipse(_centerPosition.x, _centerPosition.y, 100, 100);
    for (int i = 0; i < tiles.length; i++) {
      PImage[] tileRow = tiles[i];
      for (int j = 0; j < tileRow.length; j++) {
        PImage tile = tileRow[j];
        if (tile instanceof PImage) {
          float myMinX = (j * tile.width) - (tile.width / 2);
          float myMaxX = myMinX + (tile.width * 3);
          float myMinY = (i * tile.height) - (tile.height / 2);
          float myMaxY = myMinY + (tile.height * 3);
          boolean collides = !(   myMinX > centerPosition.x ||
                                  myMaxX < centerPosition.x ||
                                  myMinY > centerPosition.y ||
                                  myMaxY < centerPosition.y );
          if (collides) {
            pushMatrix();
            translate(j * tile.width, i * tile.height);
            image(tile, 0, 0, tile.width, tile.height);

            if (DEBUG) {
              pushStyle();
              rectMode(CORNER);
              noFill();
              rect(0, 0, tile.width, tile.height);
              textFont(helvetica48); 
              text(i + ", " + j, 0, 0); 
              popStyle();
            }
            popMatrix();
          }
        }
      }
    }
    popMatrix();
  }

}

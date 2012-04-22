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
    pos = new PVector();
  }

  void loadImagesFromPrefix(String _prefix) {
    prefix = _prefix;

    //for (int i = 0; i < tiles.length; i++) {
    //  PImage[] tileRow = tiles[i];
    //  for (int j = 0; j < tileRow.length; j++) {
    //  }
    //}
  }

  String getFilenameForTile(int i, int j) {
        return prefix + (i+1) + "_" + (j+1) + ".png";
  }

  void draw(PVector _centerPosition) {
    PVector centerPosition = PVector.sub(_centerPosition, pos);
    println(centerPosition);
    imageMode(CORNER);
    pushMatrix();
    translate(pos.x, pos.y);
    for (int i = 0; i < tiles.length; i++) {
      PImage[] tileRow = tiles[i];
      for (int j = 0; j < tileRow.length; j++) {
        PImage tile = tileRow[j];

        //Skip upper left, lower left, upper right, & lower right quadrants as they are just blank pngs
        if (((i == 0) && (j == 0)) ||
            ((i == 0) && (j == columns - 1)) ||
            ((i == rows - 1) && (j == 0)) ||
            ((i == rows - 1) && (j == columns - 1))) {
            continue;
        }

        //Only draw this tile if it's the tile that the player is occupying, or one bordering it
        int tileWidth = 1024;
        int tileHeight = 1024;
        float myMinX = (j * tileWidth) - (tileWidth / 2);
        float myMaxX = myMinX + (tileWidth * 3);
        float myMinY = (i * tileHeight) - (tileHeight / 2);
        float myMaxY = myMinY + (tileHeight * 3);
        boolean collides = !(   myMinX > centerPosition.x ||
                                myMaxX < centerPosition.x ||
                                myMinY > centerPosition.y ||
                                myMaxY < centerPosition.y );

        if (collides) {
          if ((tile instanceof PImage) && (tile.width > 0)) {
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
          } else if (!(tile instanceof PImage)) {
            String filename = getFilenameForTile(i, j);
            tileRow[j] = requestImage(filename);

            if (DEBUG) {
              println("requestImage("+filename+")");
            }
          }
        }
      }
    }
    popMatrix();
  }

}

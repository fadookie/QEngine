class Animation {
  PImage[] images;
  String[] fileNames;
  HashMap<Integer, AnimationState> animationStates;
  int state = -999;
  int imageCount;
  int frame = 0;
  float frameDurationMs;
  float lastFrameChangeMs = 0;
  String tag;
  boolean playing = true;
  
  Animation(int _state, String[] fileNames) {
    animationStates = new HashMap<Integer, AnimationState>();

    setState(0);
  }

  Animation(AnimationTemplate template) {
    animationStates = template.animationStates;
    setState(template.defaultState);
  }

  Animation(XML xmlElement) {
    animationStates     = new HashMap<Integer, AnimationState>();
    int savedState      = xmlElement.getInt("state");

    int numFrames       = xmlElement.getChildCount();
    String[] fileNames  = new String[numFrames];

    for (int i = 0; i < numFrames; i++) {
      XML pictureFileElement = xmlElement.getChild(i);
      String className = pictureFileElement.getName();

      if (className instanceof String && className.equals("AnimationState")) { 
        int stateId = pictureFileElement.getInt("id");
        animationStates.put(stateId, new AnimationState(pictureFileElement));
      } else {
        println("[Animation(XMLElement) constructor] Warning: XML child element " + pictureFileElement.getName() + " not recognized.");
      }
    }

    setState(savedState);
  }

  /**
   * Try to get the requested frameset from the animationRegistry
   */
  boolean getFrameset(String tag) {
      if (animationFrameRegistry.containsKey(tag)) {
        this.images = animationFrameRegistry.get(tag);
        return true;
      } else {
        println ("Warning: Requested animation frameset "+tag+" not found in registry.");
        return false;
      }
  }

  PVector getCurrentSize() {
    if (animationStates.containsKey(state)) {
      return animationStates.get(state).size;
    } else {
      return new PVector(0,0);
    }
  }

  void draw() {
    AnimationState animationState = animationStates.get(state);
    if ( playing && ((millis() - lastFrameChangeMs) > animationState.frameDurationMs) ) {
      //Time to show the next frame
      lastFrameChangeMs = millis(); //Reset timer
      if (frame < (images.length - 1)) {
        frame++;
      } else if ((frame < images.length) &&  animationState.loop) {
        frame = 0;
      } else if ((frame < images.length) &&  !animationState.loop) {
        //We've finished playing a one-shot animation
        playing = false;
      }
    }

    if (images.length > 0) {
      //Min and max u coordinates for uv texture
      float uMin = 0;
      float uMax = 1;
      if (animationState.flipX) {
        uMin = 1;
        uMax = 0;
      }
      textureMode(NORMALIZED);
      pushStyle();
      noStroke();
      noFill();
      beginShape();
      texture(images[frame]);
      vertex(0, 0, 0, uMin, 0);
      vertex(animationState.size.x, 0, 0, uMax, 0);
      vertex(animationState.size.x, animationState.size.y, 0, uMax, 1);
      vertex(0, animationState.size.y, 0, uMin, 1);
      endShape();
      popStyle();
    }
  }

  void pause() {
    playing = false;
  }

  void play() {
    playing = true;
  }

  boolean isPlaying() {
    return playing;
  }

  /**
   * If this state isn't already set, and it's valid, set it.
   * Will set valid states that are missing animations, resulting in graphical but not functional oddities (I hope.)
   */
  void setState(int _state) {
    if ((state != _state) && animationStates.containsKey(_state)){
      state = _state; //Set the state regardless since there may be dependencies on the state (i.e. death animation)
      if (getFrameset(animationStates.get(state).framesetTag)){
        frame = 0;
        tag = animationStates.get(state).framesetTag;
        play();
      }
      //println(this);
    } else {
      //println("[Animation.setState] did not set state to " + _state + ". Current state = " + state);
    }
  }

  String toString() {
    return "Animation is " + (playing ? "playing" : "paused") + ". Current frameset ["+state+"]: "+animationStates.get(state);
  }
}

class AnimationState {
  int id;
  boolean loop = true;
  String framesetTag;
  float frameDurationMs = 300;
  boolean flipX = false;
  PVector size;

  AnimationState(int _id, boolean _loop, String _framesetTag, float _frameDurationMs, PVector _size, boolean _flipX) {
    id = _id;
    loop = _loop;
    framesetTag = _framesetTag;
    frameDurationMs = _frameDurationMs;
    size = _size;
    flipX = _flipX;
  }

  AnimationState(XML xmlElement) {
    id = xmlElement.getInt("id");
    loop = (xmlElement.getInt("loop") == 0) ? false : true;
    framesetTag = xmlElement.getString("framesetTag");
    frameDurationMs = xmlElement.getFloat("frameDurationMs");
    size = new PVector(0,0);
    size.x = xmlElement.getFloat("size.x");
    size.y = xmlElement.getFloat("size.y");
    flipX = (0 == xmlElement.getInt("flipX")) ? false : true;
  }

  AnimationState deepClone() {
    return new AnimationState(id, loop, framesetTag, frameDurationMs, size.get(), flipX);
  }

  String toString() {
    return "AnimationState{" + "id=" + id + ", loop=" + loop + ", framesetTag=" + framesetTag + ", frameDurationMs=" + frameDurationMs + ", size=" + size + ", flipX=" + flipX + '}';
  }
}

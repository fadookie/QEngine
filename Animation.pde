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
      if (className.equals("AnimationState")) { 
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
    if ( playing && ((millis() - lastFrameChangeMs) > animationStates.get(state).frameDurationMs) ) {
      //Time to show the next frame
      lastFrameChangeMs = millis(); //Reset timer
      if (frame < (images.length - 1)) {
        frame++;
      } else if ((frame < images.length) &&  animationStates.get(state).loop) {
        frame = 0;
      } else if ((frame < images.length) &&  !animationStates.get(state).loop) {
        //We've finished playing a one-shot animation
        playing = false;
      }
    }

    if (images.length > 0) {
      image(images[frame], 0, 0, animationStates.get(state).size.x, animationStates.get(state).size.y);
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
    }
  }
}

class AnimationState {
  int id;
  boolean loop = true;
  String framesetTag;
  float frameDurationMs = 300;
  PVector size;

  AnimationState(int _id, boolean _loop, String _framesetTag, float _frameDurationMs, PVector _size) {
    id = _id;
    loop = _loop;
    framesetTag = _framesetTag;
    frameDurationMs = _frameDurationMs;
    size = _size;
  }

  AnimationState(XML xmlElement) {
    id = xmlElement.getInt("id");
    loop = (xmlElement.getInt("loop") == 0) ? false : true;
    framesetTag = xmlElement.getString("framesetTag");
    frameDurationMs = xmlElement.getFloat("frameDurationMs");
    size = new PVector(0,0);
    size.x = xmlElement.getFloat("size.x");
    size.y = xmlElement.getFloat("size.y");
  }

  AnimationState deepClone() {
    return new AnimationState(id, loop, framesetTag, frameDurationMs, size.get());
  }

  String toString() {
    return "AnimationState{" + "id=" + id + ", loop=" + loop + ", framesetTag=" + framesetTag + ", frameDurationMs=" + frameDurationMs + ", size=" + size + '}';
  }
}

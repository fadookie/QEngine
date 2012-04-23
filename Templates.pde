class UnitTemplate {
  int unitType;
  String name;
  String description;
  float attackRange;
  int hitPoints;
  int attackPoints;
  float speed;
  float attackFrequencyMs;
  int boundingOffsetX;
  int boundingOffsetY;
  int boundingWidth;
  int boundingHeight;
  ArrayList<Integer> validTargets;
  AnimationTemplate animationTemplate;
  
  UnitTemplate(XML xmlElement) {
    validTargets = new ArrayList<Integer>();

    unitType          = xmlElement.getInt("unitType");
    name              = xmlElement.getString("name");
    attackRange       = xmlElement.getFloat("attackRange");
    hitPoints         = xmlElement.getInt("hitPoints");
    attackPoints      = xmlElement.getInt("attackPoints");
    speed             = xmlElement.getFloat("speed");
    attackFrequencyMs = xmlElement.getFloat("attackFrequencyMs"); 
    boundingOffsetX   = xmlElement.getInt("boundingOffsetX"); 
    boundingOffsetY   = xmlElement.getInt("boundingOffsetY"); 
    boundingWidth     = xmlElement.getInt("boundingWidth"); 
    boundingHeight    = xmlElement.getInt("boundingHeight"); 
  
  
    int numChildren   = xmlElement.getChildCount();
    for (int i = 0; i < numChildren; i++) {
      XML childElement = xmlElement.getChild(i);
      String className = childElement.getName();

      if (!(className instanceof String)) {
        continue;
      }

      if (className.equals("Description")) { 
        description = childElement.getContent();

      } else if (className.equals("AnimationTemplate")) { 
        animationTemplate = new AnimationTemplate(childElement);

      } else if (className.equals("ValidTargets")) { 
        int numTargets = childElement.getChildCount();
        for (int j = 0; j < numTargets; j++) {
          XML targetElement = childElement.getChild(j);
          String targetElementClassName = targetElement.getName();
          if (!(targetElementClassName instanceof String)) {
            continue;
          }
          if (targetElementClassName.equals("Target")) {
            int id = targetElement.getInt("id");
            validTargets.add(id);
          } else {
            println("[Path(XMLElement) constructor] Warning: XML child element" + targetElementClassName + "not recognized.");
          }
        }
      } else {
        println("[UnitTemplate(XMLElement) constructor] Warning: XML child element " + childElement.getName() + " not recognized.");
      }
    }
  }

  /**
   * Copy constructor
   */
  UnitTemplate(UnitTemplate otherTemplate) {
    validTargets      = (ArrayList<Integer>)otherTemplate.validTargets.clone();

    unitType          = otherTemplate.unitType;
    name              = otherTemplate.name;
    description       = otherTemplate.description;
    attackRange       = otherTemplate.attackRange;
    hitPoints         = otherTemplate.hitPoints;
    attackPoints      = otherTemplate.attackPoints;
    speed             = otherTemplate.speed;
    attackFrequencyMs = otherTemplate.attackFrequencyMs;
    boundingOffsetX   = otherTemplate.boundingOffsetX;
    boundingOffsetY   = otherTemplate.boundingOffsetY;
    boundingWidth     = otherTemplate.boundingWidth;
    boundingHeight    = otherTemplate.boundingHeight;

    animationTemplate = otherTemplate.getAnimationTemplate(); //Get a clone
  }

  AnimationTemplate getAnimationTemplate() {
    return new AnimationTemplate(animationTemplate);
  }

  String toString() {
          return "UnitTemplate{" + "unitType=" + unitType + ", name=" + name + ", attackRange=" + attackRange + ", hitPoints=" + hitPoints + ", attackPoints=" + attackPoints + ", speed=" + speed + ", attackFrequencyMs=" + attackFrequencyMs + ", boundingOffsetX=" + boundingOffsetX + ", boundingOffsetY=" + boundingOffsetY + ", boundingWidth=" + boundingWidth + ", boundingHeight=" + boundingHeight + ", validTargets=" + validTargets + ", animationTemplate=" + animationTemplate + '}';
  }
}

class AnimationTemplate {
  int defaultState;
  HashMap<Integer, AnimationState> animationStates;

  AnimationTemplate(XML xmlElement) {
    animationStates = new HashMap<Integer, AnimationState>();

    int numStates   = xmlElement.getChildCount();
    for (int i = 0; i < numStates; i++) {
      XML animationStateElement = xmlElement.getChild(i);
      String className = animationStateElement.getName();
      if (!(className instanceof String)) {
        continue;
      }
      if (className.equals("AnimationState")) { 
        int stateId = animationStateElement.getInt("id");
        animationStates.put(stateId, new AnimationState(animationStateElement));
      } else {
        println("[AnimationTemplate(XMLElement) constructor] Warning: XML child element " + animationStateElement.getName() + " not recognized.");
      }
    }
  }

  /**
   * Copy constructor
   */
  AnimationTemplate(AnimationTemplate otherAnimTemplate) {
    defaultState = otherAnimTemplate.defaultState;
    animationStates = otherAnimTemplate.getAnimationStates();
  }

  /**
   * Set the prefix used for the framesetTag, to allow for using variations (i.e. Red vs Blue) - this is a bit hacky :(
   */
  void setPrefix(String prefix) {
    for (AnimationState animState : animationStates.values()) {
      animState.framesetTag = prefix + animState.framesetTag;
    }
  }

  /**
   * Get deep copy of this animationStates hashmap
   */
  HashMap<Integer, AnimationState> getAnimationStates() {
    HashMap<Integer, AnimationState> clone = new HashMap<Integer, AnimationState>();

    Iterator i = animationStates.entrySet().iterator();  // Get an iterator
    while (i.hasNext()) {
      Map.Entry entry = (Map.Entry)i.next();
      Integer cloneKey = (Integer)entry.getKey();
      AnimationState value = (AnimationState)entry.getValue();
      AnimationState cloneValue = value.deepClone();
      clone.put(cloneKey, cloneValue);
    }

    return clone;
  }

  String toString() {
    return "AnimationTemplate{" + "defaultState=" + defaultState + ", animationStates=" + animationStates + '}';
  }
}

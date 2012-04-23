class ContentManager {
  String filename = "content.xml";

  void loadContent() {
    deserialize(new XML(getMainInstance(), this.filename));
  }

  void deserialize(XML loadedXML) {
    int numObjects = loadedXML.getChildCount();
    
    for (int i = 0; i < numObjects; i++) {
      
      XML xmlElement = loadedXML.getChild(i);
      String className = xmlElement.getName();
             
      if (className instanceof String && className.equals("AnimationFrameset")) { 
          String tag      = xmlElement.getString("tag");
          int childCount  = xmlElement.getChildCount();
          ArrayList<String> imageNames = new ArrayList<String>();

          for (int j = 0; j < childCount; j++) {
            XML childElement = xmlElement.getChild(j);
            String childClassName = childElement.getName();
            if (childClassName instanceof String && childClassName.equals("PImage")) { 
              imageNames.add(childElement.getString("fileName"));
            } else {
              println("[ContentManager.deserialize()] Warning: XML child element " + childClassName + " not recognized.");
            }
          }

          loadAnimationFrames(tag, imageNames);
      } else {
        println("[ContentManager.deserialize()] Warning: XML element " + xmlElement + " not recognized.");
      }
    }
  }

  /**
   * Check the animationRegistry to see if this PImage[] was loaded before,
   * otherwise load it and store it in the registry
   */
  void loadAnimationFrames(String tag, ArrayList<String> fileNames) {
    if (!(tag instanceof String)) {
      println("ContentManager.loadAnimationFrames was passed a null tag");
      return;
    }
    int imageCount = fileNames.size();
    if (imageCount > 0) {
      if (!animationFrameRegistry.containsKey(tag)) {
        //Load frameset and store in animationFrameRegistry
        PImage[] images = new PImage[imageCount];
        for (int i = 0; i < imageCount; i++) {
          images[i] = requestImage(fileNames.get(i)); //Load images in background thread B-)
        }
        animationFrameRegistry.put(tag, images);
        println ("Frameset "+tag+" loaded.");
      }
    } else {
      println("Warning: no images specified for Animation " + this.toString() + ", it cannot display");
    }
  }

}

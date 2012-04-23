class ConfigManager {
  String filename = "config.xml";
  HashMap<String, UnitTemplate> unitTemplates;
  TreeMap<Float, String> powerUpSpawnChances;

  //Animation state numbers
  final int deathAnimation            = -1;
  final int idleAnimation             = 0;
  final int jumpAnimation             = 1;
  final int moveRightAnimation        = 2;
  final int crouchAnimation           = 3;
  final int moveLeftAnimation         = 4;

  //The various types that a power-up can be 
  final String missilePowerup         = "Missile";
  final String raygunPowerup          = "Raygun";
  final String doubleJumpPowerup      = "Double Jump";
  final String armorPowerup           = "Armor";

  //Powerup settings - hardcode these for now
  final float chanceOfPowerupSpawning     = 0.70; //The probability of a powerup spawning at the beginning of a TacticsState

  //Movement interpolation settings
  final float pixelsPerTimeSlice = 1.875; //How many pixels to move per time slice
  final float millisPerTimeSlice = 20; //How many milliseconds make up a time slice

  ConfigManager() {
    unitTemplates = new HashMap<String, UnitTemplate>();
    powerUpSpawnChances = new TreeMap<Float, String>();
  }

  void loadConfig() {
    deserialize(new XML(getMainInstance(), this.filename));

    //Hardcode Power-up spawn chances for now

    powerUpSpawnChances.put(0.50, missilePowerup); //50%
    powerUpSpawnChances.put(1.0, armorPowerup); //50%
  }

  UnitTemplate getUnitTemplate(String name) {
    //Copy this template so it can be mutated... blaaaaghh
    return new UnitTemplate(unitTemplates.get(name));
  }

  void deserialize(XML loadedXML) {
    int numObjects = loadedXML.getChildCount();
    
    for (int i = 0; i < numObjects; i++) {
      
      XML xmlElement = loadedXML.getChild(i);
      String className = xmlElement.getName();
             
      if (className instanceof String && className.equals("UnitTemplate")) { 
        UnitTemplate unitTemplate = new UnitTemplate(xmlElement); 
        unitTemplates.put(unitTemplate.name, unitTemplate);
      } else {
        println("[ConfigManager.deserialize()] Warning: XML element " + xmlElement + " not recognized.");
      }
    }
  }
}

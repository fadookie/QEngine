class QSound {
  float sfxVolume = 1.0;
  //float defaultSfxVolume = Float.MIN_VALUE;
  float musicVolume = 1.0;
  float defaultMusicVolume = Float.MIN_VALUE;

  HashMap<String, AudioSample> samples = new HashMap<String, AudioSample>();
  HashMap<String, AudioPlayer> music = new HashMap<String, AudioPlayer>();

  /**
   * Plays a one-shot sample by name.
   */
  void playSample(String filename) {
    AudioSample sample = fetchOrLoadSample(filename);
    setVolumeOrGain(sample, sfxVolume);
    sample.trigger();
  }

  void startMusic(String filename, boolean loop) {
    AudioPlayer player = fetchOrLoadPlayer(filename, music);
    setVolumeOrGain(player, musicVolume);
    if (loop) {
      player.loop();
    } else {
      player.play();
    }
  }

  void setMusicVolume(float vol) {
    musicVolume = vol;
    for (AudioPlayer player : music.values()) {
      setVolumeOrGain(player, vol);
    }
  }

  /**
   * Fetch sample from memory, or load if not currently in memory.
   */
  AudioSample fetchOrLoadSample(String filename) {
    AudioSample sample = null;
    if (samples.containsKey(filename)) {
      sample = samples.get(filename);
    } else {
      sample = minim.loadSample(filename);
      samples.put(filename, sample);
    }
    return sample;
  }

  /**
   * Fetch player from memory, or load if not currently in memory.
   */
  AudioPlayer fetchOrLoadPlayer(String filename, HashMap<String, AudioPlayer> players) {
    AudioPlayer player = null;
    if (players.containsKey(filename)) {
      player = players.get(filename);
    } else {
      player = minim.loadFile(filename);
      players.put(filename, player);
      if (Float.MIN_VALUE == defaultMusicVolume) {
        //Keep track of the default volume from JavaSound, it's a nicer default than the maximum value of its FloatControl
        if (player.hasControl(player.GAIN)) {
          defaultMusicVolume = player.getGain();
        } else if (player.hasControl(player.VOLUME)) {
          defaultMusicVolume = player.getVolume();
        }
      }
    }
    return player;
  }

  /**
   * Tries to set gain on a sound controller, or volume if gain is not available.
   * Neither is guaranteed to be available.
   */
  void setVolumeOrGain(ddf.minim.Controller controller, float value) {
    if (controller.hasControl(controller.GAIN)) {
      setFloatControl(controller.gain(), value);
    } else if (controller.hasControl(controller.VOLUME)) {
      setFloatControl(controller.volume(), value);
    } else {
      println("[QSound] Neither volume nor gain is available for Controller: " + controller);
    }
  }
  /**
   * Takes a float value from 0 to 1 and maps it to the range of the FloatControl,
   * then sets the FloatControl
   */
  void setFloatControl(javax.sound.sampled.FloatControl control, float value) {
    float maxValue;
    if (defaultMusicVolume != Float.MAX_VALUE) {
      maxValue = defaultMusicVolume;
    } else {
      maxValue = control.getMaximum(); //On some systems this is way too loud
    }
    control.setValue(
        map(value, 0, 1, control.getMinimum(), maxValue)
    );
    //println("defaultMusicVolume " + defaultMusicVolume + ", controlMax " + control.getMaximum() + " maxValue " + maxValue);
  }

  /**
   * Call before disposing this object, please
   */
  void close() {
    for (AudioSample sample : samples.values()) {
      sample.close();
    }
    for (AudioPlayer player : music.values()) {
      player.close();
    }
  }
}

class QSound {
  float sfxVolume = 1.0;
  float musicVolume = 1.0;

  HashMap<String, AudioSample> samples = new HashMap<String, AudioSample>();

  /**
   * Plays a one-shot sample by name.
   */
  void playSample(String filename) {
    AudioSample sample = fetchOrLoadSample(filename);
    setVolumeOrGain(sample, sfxVolume);
    sample.trigger();
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
   * Tries to set gain on a sound controller, or volume if gain is not available.
   * Neither is guaranteed to be available.
   */
  void setVolumeOrGain(ddf.minim.Controller controller, float value) {
    if (controller.hasControl(controller.GAIN)) {
      setFloatControl(controller.gain(), value);
    } else if (controller.hasControl(controller.VOLUME)) {
      setFloatControl(controller.volume(), value);
    }
  }
  /**
   * Takes a float value from 0 to 1 and maps it to the range of the FloatControl,
   * then sets the FloatControl
   */
  void setFloatControl(javax.sound.sampled.FloatControl control, float value) {
    control.setValue(
        map(value, 0, 1, control.getMinimum(), control.getMaximum())
    );
  }

  /**
   * Call before disposing this object, please
   */
  void close() {
    for (AudioSample sample : samples.values()) {
      sample.close();
    }
  }
}

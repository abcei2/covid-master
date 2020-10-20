import 'dart:io';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

void audioPlayerHandler(AudioPlayerState value) => print(value);

class SoundController {
  static AudioPlayer audioPlayer = AudioPlayer();
  static AudioCache audioCache = AudioCache();

  static void play(String sound) {
    if (Platform.isIOS) {
      audioPlayer.monitorNotificationStateChanges(audioPlayerHandler);
    }
    audioCache.play(sound,
        volume: 10.0, stayAwake: true, isNotification: false);
  }
}

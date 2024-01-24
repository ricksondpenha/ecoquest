import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_lifecycle.dart';
import 'app_logger.dart';

final audioControllerProvider = Provider<AudioController>(
  (ref) {
    final controller = AudioController(logger: ref.read(logger));
    ref.onDispose(() => controller.dispose());
    return controller;
  },
  dependencies: [
    appLifecycleProvider,
    logger,
  ],
);

/// Allows playing music and sound. A facade to `package:audioplayers`.
class AudioController {
  final AudioPlayer _musicPlayer;

  /// This is a list of [AudioPlayer] instances which are rotated to play
  /// sound effects.
  final List<AudioPlayer> _sfxPlayers;

  int _currentSfxPlayer = 0;

  final Queue<Song> _playlist;

  final Random _random = Random();

  /// Whether or not the audio is on at all. This overrides both music
  /// and sounds (sfx).
  ///
  /// This is an important feature especially on mobile, where players
  /// expect to be able to quickly mute all the audio. Having this as
  /// a separate flag (as opposed to some kind of {off, sound, everything}
  /// enum) means that the player will not lose their [soundsOn] and
  /// [musicOn] preferences when they temporarily mute the game.
  bool audioOn = false;

  // whether the music is enabled or not
  bool musicOn = false;

  // whether the sound effects are enabled or not
  bool soundsOn = false;

  Stream<AppLifecycleState>? _lifecycleNotifier;
  final AppLogger _log;

  /// Creates an instance that plays music and sound.
  ///
  /// Use [polyphony] to configure the number of sound effects (SFX) that can
  /// play at the same time. A [polyphony] of `1` will always only play one
  /// sound (a new sound will stop the previous one). See discussion
  /// of [_sfxPlayers] to learn why this is the case.
  ///
  /// Background music does not count into the [polyphony] limit. Music will
  /// never be overridden by sound effects because that would be silly.
  AudioController({int polyphony = 2, required AppLogger logger})
      : assert(polyphony >= 1),
        _log = logger,
        _musicPlayer = AudioPlayer(playerId: 'musicPlayer'),
        _sfxPlayers = Iterable.generate(
                polyphony, (i) => AudioPlayer(playerId: 'sfxPlayer#$i'))
            .toList(growable: false),
        _playlist = Queue.of(List<Song>.of(songs)..shuffle()) {
    _musicPlayer.onPlayerComplete.listen(_handleSongFinished);
    unawaited(_preloadSfx());
  }

  void dispose() {
    _stopAllSound();
    _musicPlayer.dispose();
    for (final player in _sfxPlayers) {
      player.dispose();
    }
  }

  /// Plays a single sound effect, defined by [type].
  ///
  /// The controller will ignore this call when the attached settings'
  /// [SettingsController.audioOn] is `true` or if its
  /// [SettingsController.soundsOn] is `false`.
  void playSfx(SfxType type, {double volume = 1.0}) {
    if (!audioOn) {
      // _log.fine(() => 'Ignoring playing sound ($type) because audio is muted.');
      return;
    }
    if (!soundsOn) {
      // _log.fine(() =>
      //     'Ignoring playing sound ($type) because sounds are turned off.');
      return;
    }

    // _log.fine(() => 'Playing sound: $type');
    final options = soundTypeToFilename(type);
    final filename = options[_random.nextInt(options.length)];
    // _log.fine(() => '- Chosen filename: $filename');

    final currentPlayer = _sfxPlayers[_currentSfxPlayer];
    currentPlayer.play(AssetSource('sfx/$filename'), volume: volume);
    _currentSfxPlayer = (_currentSfxPlayer + 1) % _sfxPlayers.length;
  }

  void _audioOnHandler() {
    if (audioOn) {
      // All sound just got un-muted. Audio is on.
      if (musicOn) {
        _startOrResumeMusic();
      }
    } else {
      // All sound just got muted. Audio is off.
      _stopAllSound();
    }
  }

  void _handleAppLifecycle() async {
    switch (await _lifecycleNotifier!.first) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _stopAllSound();
      case AppLifecycleState.resumed:
        if (audioOn && musicOn) {
          _startOrResumeMusic();
        }
      case AppLifecycleState.inactive:
        // No need to react to this state change.
        break;
    }
  }

  void _handleSongFinished(void _) {
    // Move the song that just finished playing to the end of the playlist.
    _playlist.addLast(_playlist.removeFirst());
    // Play the song at the beginning of the playlist.
    _playCurrentSongInPlaylist();
  }

  void _musicOnHandler() {
    if (musicOn) {
      // Music got turned on.
      if (audioOn) {
        _startOrResumeMusic();
      }
    } else {
      // Music got turned off.
      _musicPlayer.pause();
    }
  }

  Future<void> _playCurrentSongInPlaylist() async {
    // _log.info(() => 'Playing ${_playlist.first} now.');
    try {
      await _musicPlayer.play(AssetSource('music/${_playlist.first.filename}'));
    } catch (e) {
      // _log.severe('Could not play song ${_playlist.first}', e);
    }

    // Settings can change while the music player is preparing
    // to play a song (i.e. during the `await` above).
    // Unfortunately, `audioplayers` has a bug which will ignore calls
    // to `pause()` before that await is finished, so we need
    // to double check here.
    // See issue: https://github.com/bluefireteam/audioplayers/issues/1687
    if (!audioOn || !musicOn) {
      try {
        // _log.fine('Settings changed while preparing to play song. '
        //     'Pausing music.');
        await _musicPlayer.pause();
      } catch (e) {
        // _log.severe('Could not pause music player', e);
      }
    }
  }

  /// Preloads all sound effects.
  Future<void> _preloadSfx() async {
    // This assumes there is only a limited number of sound effects in the game.
    // If there are hundreds of long sound effect files, it's better
    // to be more selective when preloading.
    await AudioCache.instance.loadAll(SfxType.values
        .expand(soundTypeToFilename)
        .map((path) => 'sounds/$path')
        .toList());
  }

  void _soundsOnHandler() {
    for (final player in _sfxPlayers) {
      if (player.state == PlayerState.playing) {
        player.stop();
      }
    }
  }

  void _startOrResumeMusic() async {
    if (_musicPlayer.source == null) {
      await _playCurrentSongInPlaylist();
      return;
    }

    try {
      _musicPlayer.resume();
    } catch (e) {
      // Sometimes, resuming fails with an "Unexpected" error.
      // Try starting the song from scratch.
      _playCurrentSongInPlaylist();
    }
  }

  void _stopAllSound() {
    _musicPlayer.pause();
    for (final player in _sfxPlayers) {
      player.stop();
    }
  }
}

const Set<Song> songs = {
  Song('Mr_Smith-Azul.mp3', 'Azul', artist: 'Mr Smith'),
  Song('Mr_Smith-Sonorus.mp3', 'Sonorus', artist: 'Mr Smith'),
  Song('Mr_Smith-Sunday_Solitude.mp3', 'SundaySolitude', artist: 'Mr Smith'),
};

class Song {
  final String filename;

  final String name;

  final String? artist;

  const Song(this.filename, this.name, {this.artist});

  @override
  String toString() => 'Song<$filename>';
}

List<String> soundTypeToFilename(SfxType type) {
  switch (type) {
    case SfxType.huhsh:
      return const [
        'hash1.mp3',
        'hash2.mp3',
        'hash3.mp3',
      ];
    case SfxType.wssh:
      return const [
        'wssh1.mp3',
        'wssh2.mp3',
        'dsht1.mp3',
        'ws1.mp3',
        'spsh1.mp3',
        'hh1.mp3',
        'hh2.mp3',
        'kss1.mp3',
      ];
    case SfxType.buttonTap:
      return const [
        'k1.mp3',
        'k2.mp3',
        'p1.mp3',
        'p2.mp3',
      ];
    case SfxType.congrats:
      return const [
        'yay1.mp3',
        'wehee1.mp3',
        'oo1.mp3',
      ];
    case SfxType.erase:
      return const [
        'fwfwfwfwfw1.mp3',
        'fwfwfwfw1.mp3',
      ];
    case SfxType.swishSwish:
      return const [
        'swishswish1.mp3',
      ];
  }
}

enum SfxType {
  huhsh,
  wssh,
  buttonTap,
  congrats,
  erase,
  swishSwish,
}

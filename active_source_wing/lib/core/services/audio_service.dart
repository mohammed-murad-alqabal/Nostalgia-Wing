import 'package:audioplayers/audioplayers.dart';
import '../infrastructure/wing_logger.dart';

/// Service for handling audio playback and recording.
class AudioService {
  AudioService._();
  static AudioService? _instance;

  /// Gets the singleton instance of [AudioService].
  static AudioService get instance => _instance ??= AudioService._();

  bool _isInitialized = false;
  late final AudioPlayer _audioPlayer;

  /// Initializes the audio service.
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Basic initialization
      _audioPlayer = AudioPlayer();
      _isInitialized = true;
      WingLogger.info('Audio service initialized successfully', tag: 'Audio');
    } catch (e) {
      WingLogger.error('Error initializing audio service: $e', tag: 'Audio');
      rethrow;
    }
  }

  /// Plays audio from the specified path.
  Future<void> playAudio(String path) async {
    WingLogger.info('Playing audio: $path', tag: 'Audio');
    await _audioPlayer.play(DeviceFileSource(path));
  }

  /// Stops current audio playback.
  Future<void> stopAudio() async {
    WingLogger.info('Stopping audio', tag: 'Audio');
    await _audioPlayer.stop();
  }

  /// Pauses current audio playback.
  Future<void> pauseAudio() async {
    WingLogger.info('Pausing audio', tag: 'Audio');
    await _audioPlayer.pause();
  }

  /// Resumes paused audio playback.
  Future<void> resumeAudio() async {
    WingLogger.info('Resuming audio', tag: 'Audio');
    await _audioPlayer.resume();
  }

  /// Disposes resources.
  void dispose() {
    _audioPlayer.dispose();
  }
}

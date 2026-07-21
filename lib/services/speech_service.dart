import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class SpeechService {
  final SpeechToText _speech = SpeechToText();
  bool _initialized = false;

  bool get isListening => _speech.isListening;

  Future<bool> initialize() async {
    if (_initialized) return _speech.isAvailable;
    _initialized = await _speech.initialize();
    return _initialized;
  }

  Future<void> startListening({
    required void Function(String text) onResult,
  }) async {
    final available = await initialize();
    if (!available) return;

    await _speech.listen(
      onResult: (SpeechRecognitionResult result) {
        if (result.finalResult) {
          onResult(result.recognizedWords);
        }
      },
      listenOptions: SpeechListenOptions(localeId: 'pt_BR'),
    );
  }

  Future<void> stopListening() async {
    await _speech.stop();
  }

  void dispose() {
    _speech.cancel();
  }
}

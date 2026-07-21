import 'dart:math';

import '../services/speech_service.dart';

class HomeViewModel {
  static const List<String> _imageBank = [
    'https://picsum.photos/id/28/1080/1920',
    'https://picsum.photos/id/29/1080/1920',
    'https://picsum.photos/id/40/1080/1920',
    'https://picsum.photos/id/76/1080/1920',
  ];

  final SpeechService _speechService = SpeechService();
  late final String backgroundImageUrl;

  bool isListening = false;

  HomeViewModel() {
    backgroundImageUrl = _imageBank[Random().nextInt(_imageBank.length)];
  }

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return 'Bom dia';
    } else if (hour >= 12 && hour < 18) {
      return 'Boa tarde';
    } else {
      return 'Boa noite';
    }
  }

  Future<void> toggleListening({
    required void Function(String text) onResult,
    required void Function(bool listening) onStateChange,
  }) async {
    if (isListening) {
      await _speechService.stopListening();
      isListening = false;
      onStateChange(false);
    } else {
      isListening = true;
      onStateChange(true);
      await _speechService.startListening(
        onResult: (text) {
          onResult(text);
          isListening = false;
          onStateChange(false);
        },
      );
    }
  }

  void dispose() {
    _speechService.dispose();
  }
}

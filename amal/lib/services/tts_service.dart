import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static const String _apiKey = 'YOUR_API_KEY_HERE'; // Mentor provides this
  static const String _baseUrl = 'https://texttospeech.googleapis.com/v1/text:synthesize';
  static final AudioPlayer _player = AudioPlayer();
  static final FlutterTts _fallbackTts = FlutterTts();

  static Future<void> speak(String text, String language) async {
    try {
      final langCode = language == 'ar' ? 'ar-XA' : 'en-US';
      final voiceName = language == 'ar' ? 'ar-XA-Standard-A' : 'en-US-Standard-C';
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'input': {'text': text},
          'voice': {'languageCode': langCode, 'name': voiceName},
          'audioConfig': {'audioEncoding': 'MP3'},
        }),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final audioBytes = base64Decode(data['audioContent']);
        await _player.play(BytesSource(Uint8List.fromList(audioBytes)));
        return;
      }
    } catch (e) {
      // Fall through to fallback
    }
    await _fallbackTts.setLanguage(language == 'ar' ? 'ar' : 'en-US');
    await _fallbackTts.speak(text);
  }
}

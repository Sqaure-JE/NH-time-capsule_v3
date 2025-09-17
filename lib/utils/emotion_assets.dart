import 'package:flutter/widgets.dart';

class EmotionAssets {
  static const Map<String, String> _byId = {
    'joy': 'emotion/기쁨이.png',
    'sadness': 'emotion/슬픔이.png',
    'fear': 'emotion/불안이.png',
    'disgust': 'emotion/까칠이.png',
    'anger': 'emotion/버럭이.png',
  };

  static const Map<String, String> _byName = {
    '기쁨이': 'emotion/기쁨이.png',
    '슬픔이': 'emotion/슬픔이.png',
    '불안이': 'emotion/불안이.png',
    '까칠이': 'emotion/까칠이.png',
    '버럭이': 'emotion/버럭이.png',
  };

  static const Map<String, String> _byEmoji = {
    '😊': 'emotion/기쁨이.png',
    '😢': 'emotion/슬픔이.png',
    '😰': 'emotion/불안이.png',
    '🤢': 'emotion/까칠이.png',
    '😡': 'emotion/버럭이.png',
  };

  static String? pathById(String id) => _byId[id];
  static String? pathByName(String name) => _byName[name];
  static String? pathByEmoji(String emoji) => _byEmoji[emoji];

  static Widget imageById(String id, {double size = 32}) {
    final path = pathById(id);
    if (path == null) return const SizedBox.shrink();
    return Image.asset(path, width: size, height: size, fit: BoxFit.contain);
  }

  static Widget imageByName(String name, {double size = 32}) {
    final path = pathByName(name);
    if (path == null) return const SizedBox.shrink();
    return Image.asset(path, width: size, height: size, fit: BoxFit.contain);
  }

  static Widget imageByEmoji(String emoji, {double size = 32}) {
    final path = pathByEmoji(emoji);
    if (path == null) return const SizedBox.shrink();
    return Image.asset(path, width: size, height: size, fit: BoxFit.contain);
  }
}

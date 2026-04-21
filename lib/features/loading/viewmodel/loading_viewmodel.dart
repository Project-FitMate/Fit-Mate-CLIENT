import 'dart:async';
import 'package:flutter/foundation.dart';

class LoadingViewModel extends ChangeNotifier {
  static const List<Map<String, String>> _sequences = [
    {'main': '스타일을 정밀하게 분석하고 있습니다...', 'sub': '잠시만 기다려주세요'},
    {'main': '최적의 아이템을 매칭하는 중입니다...', 'sub': '거의 다 되었습니다'},
    {'main': '완벽한 피팅 실루엣을 완성하고 있습니다...', 'sub': '마지막 단계입니다'},
  ];

  int _textIndex = 0;

  String get mainText => _sequences[_textIndex]['main']!;
  String get subText => _sequences[_textIndex]['sub']!;

  Timer? _textTimer;

  void start() {
    _textTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _textIndex = (_textIndex + 1) % _sequences.length;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _textTimer?.cancel();
    super.dispose();
  }
}

import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:fit_mate_client/features/result/model/try_on_result.dart';
import 'package:fit_mate_client/features/result/repository/fitting_repository.dart';

enum FittingStatus { loading, success, error }

class LoadingViewModel extends ChangeNotifier {
  LoadingViewModel({
    required this.userImageName,
    required this.outfitImageUrl,
    FittingRepository? repository,
  }) : _repository = repository ?? FittingRepository();

  final String userImageName;
  final String outfitImageUrl;
  final FittingRepository _repository;

  static const List<Map<String, String>> _sequences = [
    {'main': '스타일을 정밀하게 분석하고 있습니다...', 'sub': '잠시만 기다려주세요'},
    {'main': '최적의 아이템을 매칭하는 중입니다...', 'sub': '거의 다 되었습니다'},
    {'main': '완벽한 피팅 실루엣을 완성하고 있습니다...', 'sub': '마지막 단계입니다'},
  ];

  int _textIndex = 0;
  FittingStatus _status = FittingStatus.loading;
  TryOnResult? _result;
  String? _errorMessage;

  String get mainText => _sequences[_textIndex]['main']!;
  String get subText => _sequences[_textIndex]['sub']!;
  FittingStatus get status => _status;
  TryOnResult? get result => _result;
  String? get errorMessage => _errorMessage;

  Timer? _textTimer;

  void start() {
    _textTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _textIndex = (_textIndex + 1) % _sequences.length;
      notifyListeners();
    });
    _runFitting();
  }

  Future<void> _runFitting() async {
    try {
      _result = await _repository.create(
        userImageName: userImageName,
        outfitImageUrl: outfitImageUrl,
      );
      _status = FittingStatus.success;
    } catch (e) {
      _errorMessage = '가상 피팅에 실패했습니다.';
      _status = FittingStatus.error;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _textTimer?.cancel();
    super.dispose();
  }
}

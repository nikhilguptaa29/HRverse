import 'dart:async';
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Timerprovider with ChangeNotifier {
  DateTime? _time;
  final Duration _duration = const Duration(seconds: 15);
  String _leftTime = '';
  Timer? _timer;
  bool _showButton = false;

  String get leftTime => _leftTime;
  bool get showButton => _showButton;
  bool get isStart => _time != null;

  Timerprovider() {
    _loadStart();
  }

  Future<void> _loadStart() async {
    final pref = await SharedPreferences.getInstance();
    final startTimeStamp = pref.getInt('_time');

    if (startTimeStamp != null) {
      _time = DateTime.fromMillisecondsSinceEpoch(startTimeStamp);
      _startCountdown();
    }
  }

  Future<void> setTimer() async {
    _time = DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('start_time', _time!.millisecondsSinceEpoch);
    _startCountdown();
  }

  Future<void> _startCountdown() async {
    final endTime = _time!.add(_duration);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final remaining = endTime.difference(now);

      if (remaining.isNegative) {
        _showButton = true;
        _timer?.cancel();
      } else {
        _leftTime = _formatDuration(remaining);
      }
      notifyListeners();
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return '$hours:$minutes:$seconds';
  }

  void onCheckOut() {
    _showButton = false;
    _time = null;
    _leftTime = '';
    SharedPreferences.getInstance().then((value) {
      value.remove('start_time');
    });
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer?.cancel();
    super.dispose();
  }
}

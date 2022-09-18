import 'package:flutter/foundation.dart';
import 'package:unilink_flutter_app/pages/member_card_page.dart';

class FeedbackPosition extends ChangeNotifier {
  SwipingDirection _swipingDirection;
  double _dx = 0.0;
  SwipingDirection get swipingDirection => _swipingDirection;
  FeedbackPosition() {
    _swipingDirection = SwipingDirection.None;
  }
  void resetPosition() {
    _dx = 0.0;
    _swipingDirection = SwipingDirection.None;
    notifyListeners();
  }

  void updatePosition(double changeInX) {
    final minBound = 15;
    _dx = _dx + changeInX;
    if (_dx > minBound) {
      _swipingDirection = SwipingDirection.Right;
    } else if (_dx < -minBound) {
      _swipingDirection = SwipingDirection.Left;
    } else {
      _swipingDirection = SwipingDirection.None;
    }
    notifyListeners();
  }
}

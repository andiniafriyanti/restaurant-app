import 'package:flutter/foundation.dart';

class ExpandDescriptionProvider extends ChangeNotifier {
  bool _isExpanded = false;
  bool get isExpanded => _isExpanded;

  void toggle() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }
}

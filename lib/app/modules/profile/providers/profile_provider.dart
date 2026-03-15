
import 'package:flutter/material.dart';
/// Pure ChangeNotifier — zero BuildContext, zero Navigator.
/// Navigation is done via GoRouter using the routerKey set in main.dart.
class ProfileProvider extends ChangeNotifier {
  /// Set this from main.dart: HomeProvider.routerKey = _routerKey;
  static GlobalKey<NavigatorState>? routerKey;


  bool _isCurrent = false;
  bool get isCurrent => _isCurrent;
  void toggleCurrent() {
    _isCurrent = !_isCurrent;
    notifyListeners();
  }


  String? _expandedOrderId;
  String? get expandedOrderId => _expandedOrderId;

  void toggleOrderExpansion(String orderId) {
    if (_expandedOrderId == orderId) {
      _expandedOrderId = null; // Collapse if tapped again
    } else {
      _expandedOrderId = orderId; // Expand new one
    }
    notifyListeners();
  }
}
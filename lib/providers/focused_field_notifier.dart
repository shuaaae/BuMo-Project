import 'package:flutter_riverpod/flutter_riverpod.dart';

class FocusedFieldNotifier extends StateNotifier<bool> {
  FocusedFieldNotifier()
      : super(true); // Assume the pickup field is initially focused

  void updateFocusedField(bool isPickupFocused) {
    state = isPickupFocused;
  }
}

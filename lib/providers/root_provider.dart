import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../services/authentication_service.dart';

class RootProvider extends ChangeNotifier {
  final AuthenticationService _authService;

  StreamSubscription<User?>? _subscription;

  var isInitialized = false;
  var hasUser = false;

  RootProvider(this._authService) {
    _subscription = _authService.authState.listen((user) {
      hasUser = user != null;
      isInitialized = true;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

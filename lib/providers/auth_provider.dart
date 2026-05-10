import 'package:flutter/foundation.dart';

import '../services/authentication_service.dart';
import '../states/request_state.dart';

class AuthProvider extends ChangeNotifier {
  final AuthenticationService _authService;

  RequestState state = RequestState.idle;

  var errorMessage = '';
  var isPasswordVisible = true;

  AuthProvider(this._authService);

  Future<void> signIn(String email, String password) async {
    try {
      state = RequestState.loading;
      notifyListeners();

      await _authService.signInWithEmailAndPassword(email, password);

      state = RequestState.idle;
    } catch (e) {
      state = RequestState.error;
      errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      state = RequestState.loading;
      notifyListeners();

      await _authService.signUpWithEmailAndPassword(email, password);

      state = RequestState.idle;
    } catch (e) {
      state = RequestState.error;
      errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }
}

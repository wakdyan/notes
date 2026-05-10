import 'package:flutter/foundation.dart';

import '../services/authentication_service.dart';
import '../services/connectivity_service.dart';
import '../services/firestore_service.dart';
import '../states/request_state.dart';

class AddNoteProvider extends ChangeNotifier {
  final AuthenticationService authenticationService;
  final ConnectivityService connectivityService;
  final FirestoreService firestoreService;

  RequestState state = RequestState.idle;

  var errorMessage = '';

  AddNoteProvider({
    required this.authenticationService,
    required this.connectivityService,
    required this.firestoreService,
  });

  Future<void> saveNote({
    required String title,
    required String content,
  }) async {
    try {
      state = RequestState.loading;
      notifyListeners();

      final hasConnection = await connectivityService.hasConnection();

      if (!hasConnection) throw 'network-request-failed';

      await firestoreService.addNote(
        authenticationService.currentUid!,
        title,
        content,
      );

      state = RequestState.idle;
    } catch (e) {
      state = RequestState.error;
      errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }
}

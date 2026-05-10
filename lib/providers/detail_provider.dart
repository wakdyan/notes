import 'package:flutter/foundation.dart';

import '../models/note.dart';
import '../services/connectivity_service.dart';
import '../services/firestore_service.dart';
import '../states/request_state.dart';

class DetailProvider extends ChangeNotifier {
  final ConnectivityService connectivityService;
  final FirestoreService firestoreService;

  RequestState state = RequestState.idle;

  var errorMessage = '';

  DetailProvider({
    required this.connectivityService,
    required this.firestoreService,
  });

  Future<void> saveNote(Note note) async {
    try {
      state = RequestState.loading;
      notifyListeners();

      final hasConnection = await connectivityService.hasConnection();

      if (!hasConnection) throw 'network-request-failed';

      await firestoreService.updateNote(note);

      state = RequestState.idle;
    } catch (e) {
      state = RequestState.error;
      errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }
}

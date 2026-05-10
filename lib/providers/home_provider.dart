import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/note.dart';
import '../services/authentication_service.dart';
import '../services/connectivity_service.dart';
import '../services/firestore_service.dart';
import '../states/request_state.dart';

class HomeProvider extends ChangeNotifier {
  final AuthenticationService authenticationService;
  final ConnectivityService connectivityService;
  final FirestoreService firestoreService;

  RequestState state = RequestState.idle;

  var errorMessage = '';
  var hasConnection = false;
  var notes = <Note>[];

  StreamSubscription<bool>? _connectivitySubscription;

  StreamSubscription<List<Note>>? _notesSubscription;

  HomeProvider({
    required this.authenticationService,
    required this.connectivityService,
    required this.firestoreService,
  });

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _notesSubscription?.cancel();
    super.dispose();
  }

  Future<void> watchConnection() async {
    try {
      state = RequestState.loading;
      notifyListeners();

      _connectivitySubscription = connectivityService.connectionStream().listen(
        onConnectionChanged,
      );

      state = RequestState.idle;
    } catch (_) {
      state = RequestState.error;
      errorMessage = 'unknown-error';
    } finally {
      notifyListeners();
    }
  }

  Future<void> watchNotes() async {
    try {
      state = RequestState.loading;
      notifyListeners();

      _notesSubscription = firestoreService
          .watchNotes(authenticationService.currentUid!)
          .listen(onNotesChanged);
      state = RequestState.idle;
    } catch (e) {
      state = RequestState.error;
      errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  void removeNote(String id) async {
    try {
      state = RequestState.loading;
      notifyListeners();

      await firestoreService.deleteNote(id);

      state = RequestState.idle;
    } catch (e) {
      state = RequestState.error;
      errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> signOut() {
    return Future.wait<FutureOr<void>>([
      _connectivitySubscription!.cancel(),
      _notesSubscription!.cancel(),
      authenticationService.signOut(),
    ]);
  }

  void onNotesChanged(List<Note> event) {
    notes = event;
    notifyListeners();
  }

  void onConnectionChanged(bool event) {
    hasConnection = event;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../pages/add_note_page.dart';
import '../pages/detail_page.dart';
import '../pages/home_page.dart';
import '../pages/root_page.dart';
import '../pages/sign_in_page.dart';
import '../pages/sign_up_page.dart';
import '../providers/add_note_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/detail_provider.dart';
import '../providers/home_provider.dart';
import '../providers/root_provider.dart';
import '../services/authentication_service.dart';
import '../services/connectivity_service.dart';
import '../services/firestore_service.dart';

part 'app_route_generator.dart';
part 'app_routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RootProvider(AuthenticationService()),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(AuthenticationService()),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeProvider(
            authenticationService: AuthenticationService(),
            connectivityService: ConnectivityService(),
            firestoreService: FirestoreService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => DetailProvider(
            connectivityService: ConnectivityService(),
            firestoreService: FirestoreService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => AddNoteProvider(
            authenticationService: AuthenticationService(),
            connectivityService: ConnectivityService(),
            firestoreService: FirestoreService(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff3B82F6)),
        ),
        initialRoute: AppRoutes.root,
        onGenerateRoute: AppRouteGenerator.route,
      ),
    );
  }
}

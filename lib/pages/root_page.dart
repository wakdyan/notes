import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/sign_in_page.dart';
import '../providers/root_provider.dart';
import '../widgets/loading_view.dart';
import 'home_page.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RootProvider>(
      builder: (_, provider, _) {
        if (!provider.isInitialized) return const LoadingView();

        if (provider.hasUser) {
          return HomePage();
        } else {
          return SignInPage();
        }
      },
    );
  }
}

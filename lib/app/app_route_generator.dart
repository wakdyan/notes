part of 'app_page.dart';

class AppRouteGenerator {
  static Route? route(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case AppRoutes.root:
        return MaterialPageRoute(builder: (_) => RootPage());
      case AppRoutes.signIn:
        return MaterialPageRoute(builder: (_) => SignInPage());
      case AppRoutes.signUp:
        return MaterialPageRoute(builder: (_) => SignUpPage());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => HomePage());
      case AppRoutes.addNote:
        return MaterialPageRoute(builder: (_) => AddNotePage());
      case AppRoutes.detail:
        final note = routeSettings.arguments as Note;
        return MaterialPageRoute(builder: (_) => DetailPage(note: note));
      default:
        return MaterialPageRoute(builder: (_) => Placeholder());
    }
  }
}

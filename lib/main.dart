import 'package:bachbracket/screens/setup/welcome.dart';
import 'package:flutter/material.dart';
import 'screens/home/home.dart';
import 'screens/setup/sign_up.dart';
import 'screens/setup/sign_in.dart';
import 'style.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return MaterialApp(
      initialRoute: '/',
      onGenerateRoute: _routes(),
      theme: _theme(),
    );
  }

  RouteFactory _routes() {
    return (settings) {
      final Map<String, dynamic> arguments = settings.arguments;
      Widget screen;
      switch (settings.name) {
        case '/':
          screen = WelcomePage();
          break;
        case '/signup':
          screen = SignUp();
          break;
        case '/signin':
          screen = SignIn();
          break;
        case '/home':
          screen = Home(arguments['user'], arguments['user_deets'], arguments['admin']);
          break;
        default:
          return null;
      }
      return MaterialPageRoute(builder: (BuildContext context) => screen);
    };
  }

  ThemeData _theme() {
    return ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.pink,
          textTheme: TextTheme(title: AppBarTextStyle),
        ),
        textTheme: TextTheme(
          title: TitleTextStyle,
          body1: Body1TextStyle,
        ));
  }
}

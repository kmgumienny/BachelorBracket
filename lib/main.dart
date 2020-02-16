import 'package:bachbracket/screens/setup/welcome.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'models/Name.dart';
import 'screens/locations/locations.dart';
import 'screens/home/home.dart';
import 'screens/setup/sign_up.dart';
import 'screens/locationDetail/LocationDetail.dart';
import 'screens/detailDescription/DetailDescription.dart';
import 'screens/setup/sign_in.dart';
import 'style.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final NameModel _model = NameModel();

    return ScopedModel<NameModel>(
      model: _model,
      child:
      MaterialApp(
      initialRoute: '/',
      onGenerateRoute: _routes(),
      theme: _theme(),
    ),
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
          screen = Home(arguments['user']);
          break;
        case '/cleaningDetails':
          screen = LocationDetail(arguments['id']);
          break;
        case '/detailDescription':
          screen = DetailDescription(arguments['locationID'], arguments['cleaningID']);
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
          textTheme: TextTheme(title: AppBarTextStyle),
        ),
        textTheme: TextTheme(
          title: TitleTextStyle,
          body1: Body1TextStyle,
        ));
  }
}

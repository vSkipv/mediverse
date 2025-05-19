import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediverse/core/utililes/cached_sp.dart';

import 'bloc_observer.dart';
import 'constants.dart';
import 'features/Login/di/login_di.dart';
import 'features/Login/presentaion/views/LoginScreen.dart';
import 'features/MainScreen/presentaion/views/MainScreen_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CachedData.init();
  Bloc.observer = Observe();

  runApp(const Mediverse());
}

class Mediverse extends StatelessWidget {
  const Mediverse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        ...LoginDI.getProviders(),
      ],
      child: MaterialApp(
        title: 'Mediverse',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'GT Sectra Fine',
        ),
        home:  MainScreen(),
        debugShowCheckedModeBanner: false,
        routes: {
          '/login': (context) =>  LoginScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/login') {
            return MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            );
          }
          return null;
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              body: Center(
                child: Text('No route defined for ${settings.name}'),
              ),
            ),
          );
        },
      ),
    );
  }
}

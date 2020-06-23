import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sublin/models/provider_user.dart';
import 'package:sublin/models/routing.dart';
import 'package:sublin/models/user.dart';
import 'package:sublin/screens/authenticate/authenticate_screen.dart';
import 'package:sublin/screens/home_screen.dart';
import 'package:sublin/screens/user/user_home_screen.dart';
import 'package:sublin/screens/provider/provider_home_screen.dart';
import 'package:sublin/screens/user/user_routing_screen.dart';
import 'package:sublin/services/provider_service.dart';
import 'package:sublin/services/routing_service.dart';
import 'package:sublin/services/user_service.dart';
import 'package:sublin/theme/theme.dart';

import '../models/auth.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/wrapper';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context);

    if (user == null) {
      // If user is not logged in show Authentication screen
      return MaterialApp(
        theme: themeData(context),
        home: AuthenticateScreen(),
      );
    } else {
      return MultiProvider(
          providers: [
            StreamProvider<Routing>.value(
              initialData: Routing.initialData(),
              value: RoutingService().streamRouting(user.uid),
              lazy: true,
            ),
            StreamProvider<User>.value(
              initialData: User.initialData(),
              value: UserService().streamUser(user.uid),
              lazy: true,
            ),
            StreamProvider<ProviderUser>.value(
              initialData: ProviderUser.initialData(),
              value: ProviderService().streamProvider(user.uid),
              lazy: true,
            )
          ],
          child: MaterialApp(
            title: 'Sublin',
            theme: themeData(context),
            home: HomeScreen(),
            routes: {
              HomeScreen.routeName: (context) => HomeScreen(),
              UserHomeScreen.routeName: (context) => UserHomeScreen(),
              RoutingScreen.routeName: (context) => RoutingScreen(),
              ProviderHomeScreen.routeName: (context) => ProviderHomeScreen()
            },
          ));
    }
  }
}
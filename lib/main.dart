import 'package:Sublin/models/versioning_class.dart';
import 'package:Sublin/screens/waiting_screen.dart';
import 'package:Sublin/services/versioning_service.dart';
import 'package:Sublin/utils/app_info.dart';
import 'package:flutter/material.dart';
import 'package:Sublin/stream_providers.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:Sublin/services/auth_service.dart';
import 'models/auth_class.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FutureBuilder<AppInfo>(
      future: AppInfo.init(),
      builder: (BuildContext context, AsyncSnapshot<AppInfo> packageInfo) {
        return packageInfo.data != null
            ? MyApp(packageInfo: packageInfo.data)
            : WaitingScreen(
                title: 'Sublin, auf geht\'s',
              );
      },
    ),
  ));
}

class MyApp extends StatelessWidget {
  final AppInfo packageInfo;
  MyApp({this.packageInfo});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          StreamProvider<Auth>.value(initialData: null, value: AuthService().userStream),
          StreamProvider<Versioning>.value(
              initialData: null, value: VersioningService().streamVersioning()),
        ],
        child: StreamProviders(
          packageInfo: packageInfo,
        ));
  }
}

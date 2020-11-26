import 'package:bitbox_moviedb/net/api.dart';
import 'package:bitbox_moviedb/screens/home_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';


void main() {
  _setupLogging();
  runApp(MyApp());
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
        create: (_) => ApiService.create(),
        dispose: (_, ApiService service) => service.client.dispose(),
        child: MaterialApp(
          initialRoute: '/',
          routes: {
            '/': (_) => HomePage(),
          },
        )
    );
  }
}


import 'package:flutter/material.dart';
import 'package:furnitureshopping/app/root_page.dart';
import 'package:furnitureshopping/app/utils/seassion_manager.dart';
import 'package:furnitureshopping/service/ApiService.dart';
import 'package:furnitureshopping/service/api.dart';
import 'package:furnitureshopping/service/database_service.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(
          create: (_) => ApiService(Api.instance()),
        ),
        Provider<SessionManager>(
          create: (_) => SessionManager(),
        ),
        Provider<DatabaseService>(
          create: (_) => DatabaseService(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: RootPage(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:furnitureshopping/app/auth/login_page.dart';
import 'package:furnitureshopping/app/ui/main/main_page.dart';
import 'package:furnitureshopping/app/utils/seassion_manager.dart';
import 'package:provider/provider.dart';

enum AuthStatus {
  notDetermined,
  notSignedIn,
  signedIn,
}

class RootPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notDetermined;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final sessionManager = Provider.of<SessionManager>(context, listen: false);
    sessionManager.isLoggedIn().then((onValue) {
      setState(() {
        if (onValue)
          authStatus = AuthStatus.signedIn;
        else
          authStatus = AuthStatus.notSignedIn;
      });
    });
  }

  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notDetermined:
        return _buildWaitingScreen();
      case AuthStatus.notSignedIn:
        return LoginPage(onSignedIn: _signedIn);
      case AuthStatus.signedIn:
        return MainPage(onSignedOut: _signedOut);
    }
    return null;
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }
}

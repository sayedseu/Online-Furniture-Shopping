import 'package:flutter/material.dart';
import 'package:furnitureshopping/app/ui/profile/update_profile.dart';
import 'package:furnitureshopping/app/utils/seassion_manager.dart';
import 'package:furnitureshopping/model/user.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  final VoidCallback onSignOut;

  Profile(this.onSignOut);

  @override
  Widget build(BuildContext context) {
    final sessionManager = Provider.of<SessionManager>(context, listen: false);

    return Scaffold(
        body: FutureBuilder<User>(
      future: sessionManager.getUserDetails(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 24,
              ),
              CircleAvatar(
                radius: 30,
                child: Text(
                  snapshot.data.fullName[0].toUpperCase(),
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.person,
                    color: Colors.blue,
                  ),
                  Text(" " + snapshot.data.fullName,
                      style: TextStyle(fontSize: 15, color: Colors.blue))
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.phone_iphone, color: Colors.blue),
                  Text(" " + snapshot.data.contactNumber,
                      style: TextStyle(fontSize: 15, color: Colors.blue))
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.email, color: Colors.blue),
                  Text(" " + snapshot.data.email,
                      style: TextStyle(fontSize: 15, color: Colors.blue))
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Divider(
                color: Colors.blue,
              ),
              SizedBox(
                height: 32,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.edit,
                      size: 18,
                      color: Colors.blue,
                    ),
                    FlatButton(
                      child: const Text('Update Profile',
                          style: TextStyle(color: Colors.blue)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdateProfile()));
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.exit_to_app,
                      size: 18,
                      color: Colors.blue,
                    ),
                    FlatButton(
                      child: const Text('Logout',
                          style: TextStyle(color: Colors.blue)),
                      onPressed: () {
                        sessionManager.logoutUser();
                        onSignOut();
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    ));
  }
}

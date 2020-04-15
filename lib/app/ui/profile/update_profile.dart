import 'dart:io';

import 'package:flutter/material.dart';
import 'package:furnitureshopping/app/utils/seassion_manager.dart';
import 'package:furnitureshopping/app/utils/show_dialog.dart';
import 'package:furnitureshopping/app/utils/validator.dart';
import 'package:furnitureshopping/model/user.dart';
import 'package:furnitureshopping/service/ApiService.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class UpdateProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _formKey = GlobalKey<FormState>();
  String _name, _email, _address, _number;
  static ProgressDialog _progressDialog;
  static SessionManager _sessionManager;

  @override
  void initState() {
    _sessionManager = Provider.of<SessionManager>(context, listen: false);
    _progressDialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    _progressDialog.style(message: "Please wait...");
    super.initState();
  }

  bool validateAndSave() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> update(String username, String password) async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    if (validateAndSave()) {
      User user = User(
          address: _address,
          contactNumber: _number,
          email: _email,
          fullName: _name,
          role: "user",
          userName: username,
          userPassword: password);
      try {
        await _progressDialog.show();
        var response = await apiService.update(username, password, user);
        if (response.userName == username) {
          _sessionManager.createLoginSession(response);
          _progressDialog.hide().whenComplete(() {
            showAlertDialog(
              context: context,
              title: 'Successful',
              content: 'Successfuly updated profile.',
              defaultActionText: 'OK',
            );
          });
          setState(() {});
        }
      } on SocketException catch (_) {
        if (_progressDialog.isShowing()) {
          _progressDialog.hide().whenComplete(() {
            showAlertDialog(
              context: context,
              title: 'Connection Error',
              content: 'Could not retrieve data. Please try again later.',
              defaultActionText: 'OK',
            );
          });
        }
      } catch (_) {
        if (_progressDialog.isShowing()) {
          _progressDialog.hide().whenComplete(() {
            showAlertDialog(
              context: context,
              title: 'Unknown Error',
              content: 'Please contact support or try again later.',
              defaultActionText: 'OK',
            );
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Profile"),
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: Container(
              margin: const EdgeInsets.only(top: 32, left: 16, right: 16),
              child: FutureBuilder<User>(
                future: _sessionManager.getUserDetails(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 40,
                          child: Center(
                            child: Text(
                              snapshot.data.fullName[0].toUpperCase() +
                                  snapshot.data.fullName[1].toUpperCase(),
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                key: Key('name'),
                                keyboardType: TextInputType.text,
                                initialValue: snapshot.data.fullName,
                                decoration: InputDecoration(
                                    labelText: 'Name',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.person_pin)),
                                validator: Validator.validateName,
                                onSaved: (String value) => _name = value,
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              TextFormField(
                                key: Key('address'),
                                initialValue: snapshot.data.address,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    labelText: 'Address',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.location_on)),
                                validator: Validator.validateAddress,
                                onSaved: (String value) => _address = value,
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              TextFormField(
                                key: Key('email'),
                                initialValue: snapshot.data.email,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    labelText: 'Email',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.email)),
                                validator: Validator.validateEmail,
                                onSaved: (String value) => _email = value,
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              TextFormField(
                                key: Key('phone'),
                                initialValue: snapshot.data.contactNumber,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    labelText: 'Phone',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.phone_iphone)),
                                validator: Validator.validatePhoneNumber,
                                onSaved: (String value) => _number = value,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        RaisedButton.icon(
                            onPressed: () {
                              update(snapshot.data.userName,
                                  snapshot.data.userPassword);
                            },
                            color: Colors.blue,
                            icon: Icon(Icons.update),
                            label: Text("Update"))
                      ],
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}

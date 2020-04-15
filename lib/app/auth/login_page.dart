import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:furnitureshopping/app/utils/seassion_manager.dart';
import 'package:furnitureshopping/app/utils/show_dialog.dart';
import 'package:furnitureshopping/app/utils/stack_icon.dart';
import 'package:furnitureshopping/app/utils/validator.dart';
import 'package:furnitureshopping/model/user.dart';
import 'package:furnitureshopping/service/ApiService.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

enum FormType {
  login,
  register,
}

class LoginPage extends StatefulWidget {
  const LoginPage({this.onSignedIn});

  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String _loginUsername, _loginPassword;
  String _username, _name, _email, _password, _address, _number;
  FormType _formType = FormType.login;
  ProgressDialog _progressDialog;

  @override
  void initState() {
    _progressDialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    _progressDialog.style(message: "Please wait...");
    super.initState();
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  bool validateAndSave() {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> validateAndSubmit() async {
    if (validateAndSave()) {
      await _progressDialog.show();
      final apiService = Provider.of<ApiService>(context, listen: false);
      final sessionManager =
          Provider.of<SessionManager>(context, listen: false);
      try {
        if (_formType == FormType.login) {
          final response =
              await apiService.authenticate(_loginUsername, _loginPassword);
          if (response.userName != null) {
            _progressDialog.hide().whenComplete(() {
              sessionManager.createLoginSession(response);
              widget.onSignedIn();
            });
          } else {
            _progressDialog.hide().whenComplete(() {
              showAlertDialog(
                context: context,
                title: 'Authentication Error',
                content:
                    'Invalid username or password. Please enter correct username or password and try again.',
                defaultActionText: 'OK',
              );
            });
          }
        } else {
          User user = User(
              address: _address,
              contactNumber: _number,
              email: _email,
              fullName: _name,
              role: "user",
              userName: _username,
              userPassword: _password);
          final response = await apiService.register(user);
          if (response.userName != null) {
            _progressDialog.hide().whenComplete(() {
              sessionManager.createLoginSession(response);
              widget.onSignedIn();
            });
          } else {
            _progressDialog.hide().whenComplete(() {
              showAlertDialog(
                context: context,
                title: 'Authentication Error',
                content:
                    'Username already exist. Please try with other username.',
                defaultActionText: 'OK',
              );
            });
          }
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
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
            child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: viewportConstraints.maxHeight,
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: buildInputs() + buildSubmitButtons()),
            ),
          ),
        ));
      }),
    );
  }

  List<Widget> buildInputs() {
    if (_formType == FormType.login) {
      return <Widget>[
        StakedIcons(),
        SizedBox(
          height: 32.0,
        ),
        TextFormField(
          key: Key('username'),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person)),
          validator: Validator.validateUsername,
          onSaved: (String value) => _loginUsername = value,
        ),
        SizedBox(
          height: 8.0,
        ),
        TextFormField(
          key: Key('password'),
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock)),
          obscureText: true,
          validator: Validator.validatePassword,
          onSaved: (String value) => _loginPassword = value,
        ),
        SizedBox(
          height: 16.0,
        ),
      ];
    } else {
      return <Widget>[
        StakedIcons(),
        SizedBox(
          height: 32.0,
        ),
        TextFormField(
          key: Key('username'),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person)),
          validator: Validator.validateUsername,
          onSaved: (String value) => _username = value,
        ),
        SizedBox(
          height: 8.0,
        ),
        TextFormField(
          key: Key('name'),
          keyboardType: TextInputType.text,
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
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              labelText: 'Phone',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone_iphone)),
          validator: Validator.validatePhoneNumber,
          onSaved: (String value) => _number = value,
        ),
        SizedBox(
          height: 8.0,
        ),
        TextFormField(
          key: Key('password'),
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock)),
          obscureText: true,
          validator: Validator.validatePassword,
          onSaved: (String value) => _password = value,
        ),
        SizedBox(
          height: 8.0,
        ),
      ];
    }
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return <Widget>[
        RaisedButton(
          key: Key('signIn'),
          color: Colors.green,
          textColor: Colors.white,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          child: const Text('Login', style: TextStyle(fontSize: 17)),
          onPressed: validateAndSubmit,
        ),
        FlatButton(
          child: const Text('Have\'t an account? Signup',
              style: TextStyle(color: Colors.green, fontSize: 17)),
          onPressed: moveToRegister,
        ),
      ];
    } else {
      return <Widget>[
        RaisedButton(
          key: Key("signup"),
          color: Colors.green,
          textColor: Colors.white,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          child:
              const Text('Create an account', style: TextStyle(fontSize: 17)),
          onPressed: validateAndSubmit,
        ),
        FlatButton(
          child: const Text('Have an account? Login',
              style: TextStyle(color: Colors.green, fontSize: 17)),
          onPressed: moveToLogin,
        ),
      ];
    }
  }
}

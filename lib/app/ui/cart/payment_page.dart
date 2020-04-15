import 'dart:io';

import 'package:flutter/material.dart';
import 'package:furnitureshopping/app/utils/show_dialog.dart';
import 'package:furnitureshopping/model/order.dart';
import 'package:furnitureshopping/service/ApiService.dart';
import 'package:furnitureshopping/service/database_service.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatefulWidget {
  final Order _order;

  PaymentPage(this._order);

  @override
  State<StatefulWidget> createState() => _PaymentPageState();
}

enum PaymentMethod { credit, debit }

class _PaymentPageState extends State<PaymentPage> {
  PaymentMethod _paymentMethod = PaymentMethod.credit;
  ProgressDialog _progressDialog;

  @override
  void initState() {
    _progressDialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    _progressDialog.style(message: "Please wait...");
    super.initState();
  }

  void placedOrder() async {
    if (widget._order != null) {
      await _progressDialog.show();
      final apiService = Provider.of<ApiService>(context, listen: false);
      final databaseService =
          Provider.of<DatabaseService>(context, listen: false);
      try {
        final response = await apiService.insertOrder(widget._order);
        if (response.orderID > 0) {
          final result =
              databaseService.deleteAllByUserId(widget._order.userID);
          result.then((value) {
            if (value > 0) {
              if (_progressDialog.isShowing()) {
                _progressDialog.hide().whenComplete(() {
                  showAlertDialog(
                    context: context,
                    title: 'Successful',
                    content: 'Your payment successfuly recieved.',
                    defaultActionText: 'OK',
                  );
                });
              }
            }
          });
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
    print(widget._order.orderList.length);
    return Scaffold(
      appBar: AppBar(title: Text("Payment")),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
            child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: viewportConstraints.maxHeight,
          ),
          child: Container(
            margin: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ListTile(
                  title: const Text(
                    "Credit Card",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  leading: Radio(
                    value: PaymentMethod.credit,
                    groupValue: _paymentMethod,
                    onChanged: (PaymentMethod value) {
                      setState(() {
                        _paymentMethod = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text(
                    "Debit Card",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  leading: Radio(
                    value: PaymentMethod.debit,
                    groupValue: _paymentMethod,
                    onChanged: (PaymentMethod value) {
                      setState(() {
                        _paymentMethod = value;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  child: TextField(
                    decoration: InputDecoration(hintText: 'Card Number'),
                  ),
                ),
                SizedBox(
                  height: 32,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  child: RaisedButton.icon(
                      onPressed: placedOrder,
                      color: Colors.blue,
                      icon: Icon(Icons.payment),
                      label: Text("Pay")),
                )
              ],
            ),
          ),
        ));
      }),
    );
  }
}

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:furnitureshopping/app/ui/home/product_details.dart';
import 'package:furnitureshopping/app/utils/show_dialog.dart';
import 'package:furnitureshopping/model/product.dart';
import 'package:furnitureshopping/service/ApiService.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class _SearchPageState extends State<SearchPage> {
  final _debouncer = Debouncer(milliseconds: 300);
  List<Product> products = List();
  List<Product> filteredProducts = List();
  bool isShow = true;

  @override
  void initState() {
    super.initState();
    final apiService = Provider.of<ApiService>(context, listen: false);
    try {
      apiService.getAllProduct().then((value) {
        setState(() {
          isShow = false;
          products = value;
          filteredProducts = products;
        });
      });
    } on SocketException catch (_) {
      showAlertDialog(
        context: context,
        title: 'Connection Error',
        content: 'Could not retrieve data. Please try again later.',
        defaultActionText: 'OK',
      );
    } catch (_) {
      showAlertDialog(
        context: context,
        title: 'Unknown Error',
        content: 'Please contact support or try again later.',
        defaultActionText: 'OK',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Product"),
      ),
      body: Container(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              onChanged: (string) {
                _debouncer.run(() {
                  setState(() {
                    filteredProducts = products
                        .where((product) => product.productName
                            .toLowerCase()
                            .trim()
                            .contains(string.toLowerCase().trim()))
                        .toList();
                  });
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            Center(child: isShow ? CircularProgressIndicator() : null),
            Expanded(
              child: ListView.builder(
                  itemCount:
                      filteredProducts.isEmpty ? 0 : filteredProducts.length,
                  itemBuilder: _getListItemUI,
                  padding: EdgeInsets.all(0.0)),
            )
          ],
        ),
      ),
    );
  }

  Widget _getListItemUI(BuildContext context, int index) {
    return Card(
        child: Column(children: <Widget>[
      ListTile(
        leading: Image.network(
          filteredProducts[index].linkList[0],
          fit: BoxFit.fitHeight,
          width: 80,
        ),
        title: Text(
          filteredProducts[index].productName,
          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "৳ " + filteredProducts[index].productPrice + "/-",
          style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ProductDetails(filteredProducts[index])));
        },
      )
    ]));
  }
}

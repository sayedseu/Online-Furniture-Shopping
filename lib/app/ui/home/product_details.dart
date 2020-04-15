import 'package:flutter/material.dart';
import 'package:furnitureshopping/app/utils/seassion_manager.dart';
import 'package:furnitureshopping/app/utils/show_dialog.dart';
import 'package:furnitureshopping/model/cart_entity.dart';
import 'package:furnitureshopping/model/product.dart';
import 'package:furnitureshopping/service/database_service.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  final Product _product;

  ProductDetails(this._product);

  @override
  State<StatefulWidget> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  GlobalKey<PageContainerState> key = GlobalKey();
  static String _userId;
  static DatabaseService _databaseService;
  int _quantity = 1;

  @override
  void initState() {
    final sessionManager = Provider.of<SessionManager>(context, listen: false);
    _databaseService = Provider.of<DatabaseService>(context, listen: false);
    sessionManager.getUserDetails().then((value) {
      _userId = value.userName;
    });
    super.initState();
  }

  void add() {
    setState(() {
      _quantity += 1;
    });
  }

  void minus() {
    if (_quantity <= 1) return;
    setState(() {
      _quantity -= 1;
    });
  }

  void addToCart(BuildContext context) {
    CartItem cartItem = CartItem(
        userID: _userId,
        productID: widget._product.productId,
        productName: widget._product.productName,
        productPrice: widget._product.productPrice,
        quantity: _quantity,
        url: widget._product.linkList[0]);
    _databaseService.insert(cartItem).then((value) {
      if (value > 0) {
        showAlertDialog(
          context: context,
          title: 'Successful',
          content:
              'This item successfuly added to cart. You can see all item in cart.',
          defaultActionText: 'OK',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Product Info"),
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _pageIndicatorContainer(context),
                      Container(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              widget._product.productName,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "‎৳ " + widget._product.productPrice + "/-",
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              widget._product.productDescription,
                              style: TextStyle(
                                fontSize: 15,
                                fontStyle: FontStyle.normal,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            _getQuantity(context),
                            SizedBox(
                              height: 60,
                            ),
                            RaisedButton.icon(
                              onPressed: () {
                                addToCart(context);
                              },
                              icon: Icon(Icons.shopping_cart),
                              label: Text("Add to Cart"),
                              color: Colors.blue,
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
            );
          },
        ));
  }

  Widget _getQuantity(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          "Quantity:",
          style: TextStyle(fontSize: 20, fontStyle: FontStyle.normal),
          textAlign: TextAlign.start,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 8),
              height: 32,
              width: 32,
              child: FloatingActionButton(
                heroTag: "add",
                onPressed: add,
                child: new Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                backgroundColor: Colors.white,
              ),
            ),
            Text('$_quantity', style: new TextStyle(fontSize: 30.0)),
            Container(
              margin: const EdgeInsets.only(left: 8),
              height: 32,
              width: 32,
              child: FloatingActionButton(
                heroTag: "minus",
                onPressed: minus,
                child: new Icon(
                    const IconData(0xe15b, fontFamily: 'MaterialIcons'),
                    color: Colors.black),
                backgroundColor: Colors.white,
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _pageIndicatorContainer(BuildContext context) {
    return Container(
      height: 300,
      child: PageIndicatorContainer(
        key: key,
        child: PageView(
          children: <Widget>[
            _getImageView(widget._product.linkList[0]),
            _getImageView(widget._product.linkList[1])
          ],
        ),
        align: IndicatorAlign.bottom,
        length: 2,
        indicatorSpace: 10.0,
        indicatorColor: Colors.deepOrange,
        indicatorSelectorColor: Colors.blue,
        shape: IndicatorShape.circle(size: 12),
      ),
    );
  }

  Widget _getImageView(String url) {
    return Image.network(url, fit: BoxFit.fill, loadingBuilder:
        (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
      if (loadingProgress == null) return child;
      return Center(
        child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes
              : null,
        ),
      );
    });
  }
}

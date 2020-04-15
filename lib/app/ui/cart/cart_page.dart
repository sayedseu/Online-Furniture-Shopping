import 'package:flutter/material.dart';
import 'package:furnitureshopping/app/ui/cart/payment_page.dart';
import 'package:furnitureshopping/app/utils/seassion_manager.dart';
import 'package:furnitureshopping/model/cart_entity.dart';
import 'package:furnitureshopping/model/order.dart';
import 'package:furnitureshopping/model/order_list.dart';
import 'package:furnitureshopping/service/database_service.dart';
import 'package:provider/provider.dart';

class Cart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CartSate();
}

class _CartSate extends State<Cart> {
  static DatabaseService _databaseService;
  static SessionManager _sessionManager;
  String userId;
  Future<List<CartItem>> list;
  double totalPrice;
  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    _databaseService = Provider.of<DatabaseService>(context, listen: false);
    _sessionManager = Provider.of<SessionManager>(context, listen: false);
    super.initState();
  }

  Future<List<CartItem>> retrieve() async {
    await _sessionManager.getUserDetails().then((value) {
      userId = value.userName;
      list = _databaseService.retrieve(value.userName);
    });
    return list;
  }

  void deleteItem(int id) {
    _databaseService.delete(id).then((value) {
      if (value == 1) {
        setState(() {});
      }
    });
  }

  void gotoPaymentPage() {
    list.then((value) {
      if (value.isNotEmpty && userId.isNotEmpty) {
        List<OrderList> orderList = new List();
        for (CartItem cartItem in value) {
          OrderList order = OrderList(
            productID: cartItem.productID,
            productName: cartItem.productName,
            productPrice: cartItem.productPrice,
            quantity: cartItem.quantity,
          );
          orderList.add(order);
        }
        Order order = Order(
          orderDate: _dateTime.year.toString() +
              "/" +
              _dateTime.month.toString() +
              "/" +
              _dateTime.day.toString(),
          orderList: orderList,
          orderState: "Order Placed",
          totalAmount: totalPrice.toString(),
          userID: userId,
        );
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PaymentPage(order)));
      }
    });
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
              margin: EdgeInsets.all(8.0),
              child: FutureBuilder<List<CartItem>>(
                future: retrieve(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.isEmpty) {
                      return _getNoItemView();
                    }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: _getCartItems(snapshot.data) +
                          _getTotalAmount(snapshot.data),
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

  List<Widget> _getCartItems(List<CartItem> list) {
    List<Widget> allWidgets = List<Widget>();
    for (final value in list) {
      allWidgets.add(_getCartItemUi(value));
    }
    return allWidgets;
  }

  Widget _getCartItemUi(CartItem cartItem) {
    return Container(
        height: 150,
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.network(
                cartItem.url,
                width: 100,
                fit: BoxFit.fill,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 150,
                    child: Text(
                      cartItem.productName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text("‎৳ " + cartItem.productPrice + "/-",
                      style: TextStyle(color: Colors.deepOrange)),
                  SizedBox(
                    height: 4,
                  ),
                  Text("Q:" + cartItem.quantity.toString()),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(right: 8, bottom: 8),
                    height: 32,
                    width: 32,
                    child: FloatingActionButton(
                      heroTag: cartItem.productName,
                      onPressed: () {
                        deleteItem(cartItem.id);
                      },
                      child: Icon(
                        Icons.clear,
                        color: Colors.black,
                      ),
                      backgroundColor: Colors.white,
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }

  List<Widget> _getTotalAmount(List<CartItem> list) {
    List<Widget> allWidgets = List<Widget>();
    Column column = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 50, left: 8, bottom: 8),
          child: Text("Price Descriptions:",
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Divider(color: Colors.blue),
        Column(
          children: _getPriceByItem(list),
        ),
        SizedBox(
          height: 12,
        ),
        RaisedButton.icon(
            onPressed: gotoPaymentPage,
            color: Colors.blue,
            icon: Icon(Icons.arrow_forward_ios),
            label: Text("Continue"))
      ],
    );
    allWidgets.add(column);
    return allWidgets;
  }

  List<Widget> _getPriceByItem(List<CartItem> list) {
    List<Widget> allWidgets = List<Widget>();
    double count = 0;
    for (int i = 0; i < list.length; i++) {
      int actualPrice = int.parse(list[i].productPrice);
      double totalPrice = (actualPrice * list[i].quantity).toDouble();
      count += totalPrice;
      allWidgets
          .add(_getPriceByTemView(i, list[i].productPrice, list[i].quantity));
    }
    totalPrice = count;
    Column column = Column(
      children: <Widget>[
        Divider(color: Colors.blue),
        Container(
          margin: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Amount Payable"),
              Text("‎৳ " + count.toString() + "/-"),
            ],
          ),
        ),
      ],
    );
    allWidgets.add(column);
    return allWidgets;
  }

  Widget _getPriceByTemView(int index, String price, int quantity) {
    String localPrice = price;
    int actualPrice = int.parse(localPrice);
    double totalPrice = (actualPrice * quantity).toDouble();
    return Container(
      margin: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Items(" + (index + 1).toString() + ")"),
          Text("‎৳ " + totalPrice.toString() + "/-"),
        ],
      ),
    );
  }

  Widget _getNoItemView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 200,
            width: 200,
            child: Image.asset(
              "assets/images/cart.png",
              fit: BoxFit.fill,
            ),
          ),
          Text(
            "No Items in Cart",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.lightBlue),
          )
        ],
      ),
    );
  }
}

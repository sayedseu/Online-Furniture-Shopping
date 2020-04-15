import 'package:flutter/material.dart';
import 'package:furnitureshopping/app/ui/cart/cart_page.dart';
import 'package:furnitureshopping/app/ui/home/home_page.dart';
import 'package:furnitureshopping/app/ui/main/search_page.dart';
import 'package:furnitureshopping/app/ui/order/order_page.dart';
import 'package:furnitureshopping/app/ui/profile/profile_page.dart';
import 'package:furnitureshopping/app/utils/seassion_manager.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  final VoidCallback onSignedOut;

  MainPage({this.onSignedOut});

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

enum MenuItem { logout }

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  String _title = "Home";

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          _title = "Home";
          break;
        case 1:
          _title = "Profile";
          break;
        case 2:
          _title = "Cart";
          break;
        case 3:
          _title = "Order";
          break;
      }
    });
  }

  void _onSearchIconTapped() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SearchPage()));
  }

  void _onMenuItemTapped(MenuItem menuItem) {
    final sessionManager = Provider.of<SessionManager>(context, listen: false);
    switch (menuItem) {
      case MenuItem.logout:
        sessionManager.logoutUser();
        widget.onSignedOut();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      HomePage(),
      Profile(widget.onSignedOut),
      Cart(),
      OrderPage()
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(_title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _onSearchIconTapped,
          ),
          PopupMenuButton<MenuItem>(
            onSelected: _onMenuItemTapped,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuItem>>[
              const PopupMenuItem(
                child: Text("Logout"),
                value: MenuItem.logout,
              )
            ],
          )
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        unselectedItemColor: Colors.blue,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text('Cart'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.reorder),
            title: Text('Order'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:furnitureshopping/app/ui/home/category_page.dart';
import 'package:furnitureshopping/app/ui/home/horizontal%20_list_view.dart';
import 'package:furnitureshopping/model/product.dart';
import 'package:furnitureshopping/service/ApiService.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _press(String category) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CategoryDetails(category)));
  }

  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context, listen: false);
    return Scaffold(
        body: ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 8.0,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: new Text("Dining",
                          style: new TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold))),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _press('Dining');
                      },
                      child: Text("View All",
                          style: new TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Container(
                height: 200,
                child: FutureBuilder<List<Product>>(
                  future: apiService.getProductByCategory('Dining'),
                  builder: (context, snapshot) {
                    if (snapshot.hasData)
                      return HorizontalListView(snapshot.data);
                    else if (snapshot.hasError)
                      return Text("Empty List", textAlign: TextAlign.center);
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 8.0,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: new Text("Sofa",
                          style: new TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold))),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _press('Sofa');
                      },
                      child: Text("View All",
                          style: new TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Container(
                height: 200,
                child: FutureBuilder<List<Product>>(
                  future: apiService.getProductByCategory('Sofa'),
                  builder: (context, snapshot) {
                    if (snapshot.hasData)
                      return HorizontalListView(snapshot.data);
                    else if (snapshot.hasError)
                      return Text("Empty List", textAlign: TextAlign.center);
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 8.0,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: new Text("Chair",
                          style: new TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold))),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _press('Chair');
                      },
                      child: Text("View All",
                          style: new TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Container(
                height: 200,
                child: FutureBuilder<List<Product>>(
                  future: apiService.getProductByCategory('Chair'),
                  builder: (context, snapshot) {
                    if (snapshot.hasData)
                      return HorizontalListView(snapshot.data);
                    else if (snapshot.hasError)
                      return Text("Empty List", textAlign: TextAlign.center);
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 8.0,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: new Text("Bed",
                          style: new TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold))),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _press('Bed');
                      },
                      child: Text("View All",
                          style: new TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Container(
                height: 200,
                child: FutureBuilder<List<Product>>(
                  future: apiService.getProductByCategory('Bed'),
                  builder: (context, snapshot) {
                    if (snapshot.hasData)
                      return HorizontalListView(snapshot.data);
                    else if (snapshot.hasError)
                      return Text("Empty List", textAlign: TextAlign.center);
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 8.0,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: new Text("Wardrobe",
                          style: new TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold))),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _press('Wardrobe');
                      },
                      child: Text("View All",
                          style: new TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Container(
                height: 200,
                child: FutureBuilder<List<Product>>(
                  future: apiService.getProductByCategory('Wardrobe'),
                  builder: (context, snapshot) {
                    if (snapshot.hasData)
                      return HorizontalListView(snapshot.data);
                    else if (snapshot.hasError)
                      return Text("Empty List", textAlign: TextAlign.center);
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ],
    ));
  }
}

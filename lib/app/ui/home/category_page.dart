import 'package:flutter/material.dart';
import 'package:furnitureshopping/app/ui/home/grid_view.dart';
import 'package:furnitureshopping/model/product.dart';
import 'package:furnitureshopping/service/ApiService.dart';
import 'package:provider/provider.dart';

class CategoryDetails extends StatefulWidget {
  final String category;

  CategoryDetails(this.category);

  @override
  State<StatefulWidget> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  @override
  void initState() {
    assert(widget.category.isNotEmpty);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.category),
        ),
        body: Center(
          child: FutureBuilder<List<Product>>(
            future: apiService.getProductByCategory(widget.category),
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return GridListView(snapshot.data);
              else if (snapshot.hasError) return Text("Empty List");
              return CircularProgressIndicator();
            },
          ),
        ));
  }
}

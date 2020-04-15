import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:furnitureshopping/app/ui/home/product_details.dart';
import 'package:furnitureshopping/model/product.dart';

class GridListView extends StatelessWidget {
  final List<Product> productList;

  GridListView(this.productList);

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: productList.length,
      itemBuilder: (BuildContext context, int index) {
        return _getListItemUi(context, productList[index]);
      },
      staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }

  Widget _getListItemUi(BuildContext context, Product product) {
    return InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ProductDetails(product)));
        },
        child: Container(
          height: 200,
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 100,
                  width: 154,
                  margin: const EdgeInsets.only(
                      top: 8, right: 4, left: 4, bottom: 8),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(5.0),
                  ),
                  child: Image.network(product.linkList[0], fit: BoxFit.fill,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes
                            : null,
                      ),
                    );
                  }),
                ),
                SizedBox(
                  width: 150,
                  child: Text(
                    product.productName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                SizedBox(
                  width: 150,
                  child: Text("‎৳ " + product.productPrice + "/-",
                      textAlign: TextAlign.center),
                )
              ],
            ),
          ),
        ));
  }
}

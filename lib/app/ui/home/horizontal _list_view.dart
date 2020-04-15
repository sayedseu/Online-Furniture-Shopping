import 'package:flutter/material.dart';
import 'package:furnitureshopping/app/ui/home/product_details.dart';
import 'package:furnitureshopping/model/product.dart';

class HorizontalListView extends StatelessWidget {
  final List<Product> productList;

  HorizontalListView(this.productList);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: _getListItemUI,
      itemCount: 5,
    );
  }

  Widget _getListItemUI(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetails(productList[index])));
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 100.0,
              width: 154,
              margin:
                  const EdgeInsets.only(top: 8, right: 4, left: 4, bottom: 8),
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(5.0),
              ),
              child: Image.network(productList[index].linkList[0],
                  fit: BoxFit.fill, loadingBuilder: (BuildContext context,
                      Widget child, ImageChunkEvent loadingProgress) {
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
                productList[index].productName,
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
              child: Text("‎৳ " + productList[index].productPrice + "/-",
                  textAlign: TextAlign.center),
            )
          ],
        ),
      ),
    );
  }
}

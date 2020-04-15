import 'dart:convert';

import 'package:furnitureshopping/model/order.dart';
import 'package:furnitureshopping/model/product.dart';
import 'package:furnitureshopping/model/user.dart';
import 'package:furnitureshopping/service/api.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final Api api;

  ApiService(this.api);

  static final Map headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8'
  };

  Future<User> register(User user) async {
    final response = await http.post(api.registerUserApi(),
        headers: headers, body: json.encode(user.toJson()));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      User user = User.fromJson(data);
      return user;
    } else if (response.statusCode == 409) {
      User user = User(userName: null);
      return user;
    } else {
      print(response.statusCode);
      print(response.reasonPhrase);
      throw response;
    }
  }

  Future<User> authenticate(String username, String password) async {
    final response = await http.post(
      api.authenticationUserApi(username, password),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      User user = User.fromJson(data);
      return user;
    } else if (response.statusCode == 404) {
      User user = User(userName: null);
      return user;
    } else
      throw response;
  }

  Future<User> update(String username, String password, User user) async {
    final response = await http.put(api.updateUserApi(username, password),
        headers: headers, body: json.encode(user.toJson()));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      User user = User.fromJson(data);
      return user;
    } else {
      print(response.statusCode);
      print(response.reasonPhrase);
      throw response;
    }
  }

  Future<List<Product>> getProductByCategory(String category) async {
    final response = await http.get(
      api.getProductByCategoryApi(category),
      headers: headers,
    );
    if (response.statusCode == 200) {
      Iterable data = json.decode(response.body) as List;
      List<Product> product = data.map((i) => Product.fromJson(i)).toList();
      return product;
    } else {
      print(response.statusCode);
      print(response.reasonPhrase);
      throw response;
    }
  }

  Future<List<Product>> getAllProduct() async {
    final response = await http.get(
      api.getAllProductApi(),
      headers: headers,
    );
    if (response.statusCode == 200) {
      Iterable data = json.decode(response.body) as List;
      List<Product> product = data.map((i) => Product.fromJson(i)).toList();
      return product;
    } else {
      print(response.statusCode);
      print(response.reasonPhrase);
      throw response;
    }
  }

  Future<Order> insertOrder(Order order) async {
    final response = await http.post(api.insertOrderAPi(),
        headers: headers, body: json.encode(order.toJson()));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      Order responseOrder = Order.fromJson(data);
      return responseOrder;
    } else {
      print(response.statusCode);
      print(response.reasonPhrase);
      throw response;
    }
  }

  Future<List<Order>> retrieveAllOrderById(String userId) async {
    final response = await http.get(
      api.retrieveOrderAPi(),
      headers: headers,
    );
    if (response.statusCode == 200) {
      Iterable data = json.decode(response.body) as List;
      List<Order> orderList = data
          .map((value) => Order.fromJson(value))
          .toList()
          .where((value) => value.userID == userId)
          .toList();
      return orderList;
    } else {
      print(response.statusCode);
      print(response.reasonPhrase);
      throw response;
    }
  }
}

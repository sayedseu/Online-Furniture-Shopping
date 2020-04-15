class Api {
  Api();

  factory Api.instance() => Api();

  static final String host = 'furniture-shopping-backend.herokuapp.com';
  static final String scheme = 'https';

  String registerUserApi() {
    Uri uri = Uri(scheme: scheme, host: host, path: 'api/v1/auth/new');
    return uri.toString();
  }

  String authenticationUserApi(String username, String password) {
    var param = <String, String>{
      'username': '$username',
      'password': '$password'
    };
    Uri uri = Uri(
        scheme: scheme,
        host: host,
        path: 'api/v1/auth',
        queryParameters: param);
    return uri.toString();
  }

  String updateUserApi(String username, String password) {
    Uri uri = Uri(
        scheme: scheme,
        host: host,
        path: 'api/v1/auth/update/$username/$password');
    return uri.toString();
  }

  String getProductByCategoryApi(String category) {
    Uri uri = Uri(
        scheme: scheme,
        host: host,
        path: 'api/v1/product-management/products/$category');
    return uri.toString();
  }

  String getAllProductApi() {
    Uri uri = Uri(
        scheme: scheme, host: host, path: 'api/v1/product-management/products');
    return uri.toString();
  }

  String insertOrderAPi() {
    Uri uri =
        Uri(scheme: scheme, host: host, path: 'api/v1/order-management/new');
    return uri.toString();
  }

  String retrieveOrderAPi() {
    Uri uri =
        Uri(scheme: scheme, host: host, path: 'api/v1/order-management/orders');
    return uri.toString();
  }
}

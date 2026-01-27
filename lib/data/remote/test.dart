import 'package:maneger/class/crud.dart';
import 'package:maneger/core/constants/api_constants.dart';

class TestData {
  Crud crud;
  TestData(this.crud);

  Future<Object> getdata() async {
    var respo = await crud.postData(ApiConstants.products, {});
    // print(respo);
    return respo.fold((l) => l, (r) => r);
  }

  Future<Object> getCatt() async {
    var respo = await crud.postData(ApiConstants.categories, {});
    return respo.fold((l) => l, (r) => r);
  }

  Future<Object> addUser(
    String name,
    String price,
    String image,
    int proCat,
  ) async {
    var respo = await crud.postData(ApiConstants.signup, {
      'username': name,
      'email': price,
      'password': image,
      'phone': proCat,
    });
    return respo.fold((l) => l, (r) => r);
  }
}

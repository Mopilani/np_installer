import 'package:get/get.dart';

class JsonViewModefierController extends GetxController {
  final RxMap<String, dynamic> map = <String, dynamic>{}.obs;

  void addAll(other) => map.addAll(other);

  void remove(key) => map.remove(key);
  
  void clear(key) => map.clear();
}

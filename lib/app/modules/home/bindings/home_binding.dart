import 'package:get/get.dart';
import 'package:berita_daffa/controllers/news_controllers.dart';
// 1. Class Binding harus implements interface Bindings dari GetX
class HomeBinding implements Bindings {
  
  // 2. Method dependencies() dipanggil saat route ke HomeView dibuka
  @override
  void dependencies() {
    // 3. Get.lazyPut artinya:
    //    - Controller hanya dibuat saat pertama kali dibutuhkan (lazy)
    //    - Controller akan otomatis didestroy saat HomeView ditutup
    Get.lazyPut<NewsController>(() => NewsController());
  }
}


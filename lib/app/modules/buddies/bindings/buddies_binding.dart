import 'package:get/get.dart';

import '../controllers/buddies_controller.dart';

class BuddiesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuddiesController>(
      () => BuddiesController(),
    );
  }
}

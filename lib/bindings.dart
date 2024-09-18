import 'package:get/get.dart';
import 'package:tes_bni/controllers/watchlist/controller_watchlist.dart';

class WatchListBindings extends Bindings{
@override
  void dependencies() {
    Get.lazyPut(()=>ControllerWatchList());
  }
}

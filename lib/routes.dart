import 'package:get/get.dart';
import 'package:tes_bni/bindings.dart';
import 'package:tes_bni/views/watchlist/main.dart';
final List<GetPage<dynamic>> route = [
  GetPage(name: '/watchlist', page: ()=> const WatchListPage(),binding: WatchListBindings())
];
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tes_bni/controllers/watchlist/controller_watchlist.dart';
import 'package:tes_bni/views/watchlist/grafik.dart';
import 'package:tes_bni/views/watchlist/watch_list.dart';

class WatchListPage extends StatelessWidget {
  const WatchListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ControllerWatchList>();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Watchlist',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.black,
      ),
      body:  Padding(
        padding: const EdgeInsets.all(8.0),
        child:
        Obx((){
          if(!controller.isLoadingWatchList.value){
            return const Column(
              children: [
                WatchListView(),
                SizedBox(height: 20,),
                Expanded(child: GrafikView())
              ],
            );
          }else{
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        })
      ),
    );
  }
}




import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tes_bni/controllers/watchlist/controller_watchlist.dart';
import 'package:tes_bni/helpers/helper.dart';


class WatchListView extends StatelessWidget {
  const WatchListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ControllerWatchList>();
    return Obx(()=>Column(
        children: [
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(3),
              2: FlexColumnWidth(2),
              3: FlexColumnWidth(2),
            },
            children:const [
              TableRow(
                decoration: BoxDecoration(color: Colors.grey),
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Symbol', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Last', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Chg', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Chg%', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('#', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),

                ],
              ),
            ],
          ),
          Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(2),
              },
              children:List.generate(controller.watchList.length, (i){
                final data = controller.watchList[i];
                return TableRow(
                  decoration: BoxDecoration(
                    color: controller.kode.value== data['kode']?Colors.green:Colors.grey
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(data['kode'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(formateMoney(data['price'].toStringAsFixed(2),'en_US'), style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(data['diffPrice'].toStringAsFixed(2).toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(data['diffPercent'].toStringAsFixed(2).toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Center(
                      child: IconButton(
                        onPressed: (){
                          if(controller.kode.value != data['kode']){
                            controller.channel2.sink.close();
                            controller.isLoadingGrafik.value = true;
                            controller.detailWatchList(data['kode']);
                            controller.kode.value = data['kode'];
                          }
                        },
                        icon: Icon(controller.kode.value== data['kode']?Icons.check_circle:Icons.add_circle,color: Colors.white,),
                      ),
                    ),
                  ],
                );
              })
          )
        ],
      ),
    );
  }
}
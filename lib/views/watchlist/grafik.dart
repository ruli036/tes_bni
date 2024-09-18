import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tes_bni/controllers/watchlist/controller_watchlist.dart';
import 'package:tes_bni/helpers/helper.dart';


class GrafikView extends StatelessWidget {
  const GrafikView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ControllerWatchList>();
    return Obx(() {
      if(controller.isLoadingGrafik.value){
        return const Center(
          child: CircularProgressIndicator(),
        );
      }else{
        var lastprice = controller.grafik.isNotEmpty?controller.grafik.first['y']:0.0;
        var grafikData = controller.grafik.map((data) => double.parse(data['y'].toString())).toList();
        var maxDataY = grafikData.isNotEmpty ? grafikData.reduce((a, b) => a > b ? a : b) : 0.0;
        var minDataY = grafikData.isNotEmpty ? grafikData.reduce((a, b) => a < b ? a : b) : 0.0;
        var margin = (maxDataY - minDataY) * 0.2;
        var maxY = maxDataY + margin;
        var minY = minDataY - margin;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(controller.symbols.value,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),),
                Text(formateDate(controller.times.value.toString(), 'HH:mm:ss'),style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color: Colors.grey.shade400),),
              ],
            ),
            Text(r'$'+formateMoney(controller.prices.value.toStringAsFixed(2), 'en_US'), style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.yellow),),
            Row(
              children: [
                Icon(lastprice < controller.prices.value?Icons.arrow_circle_up_rounded:Icons.arrow_circle_down_rounded,color: lastprice > controller.prices.value?Colors.red:Colors.green,),
                Text('${controller.percents.value.toStringAsFixed(2)} %',style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.green),),
              ],
            ),
            const SizedBox(height: 30,),
            SizedBox(
              height: MediaQuery.of(context).size.width,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                      show: true,
                   topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                   rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                   bottomTitles: AxisTitles(
                     sideTitles: SideTitles(
                       showTitles: true,
                       maxIncluded: false,
                       minIncluded: false,
                       reservedSize: 40,
                       getTitlesWidget: (value, meta) {
                         String time = value.toString().split('.')[0].toString();
                         String formattedTime = formateDate(time,'mm:ss');
                         return SideTitleWidget(
                           axisSide: meta.axisSide,
                           child: Text(
                             formattedTime,
                             style:   const TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.white),
                           ),
                         );
                       },

                     ),
                   ),
                   leftTitles: AxisTitles(
                     sideTitles: SideTitles(
                       showTitles: true,
                       reservedSize: 40,
                       maxIncluded: false,
                       minIncluded: false,
                       getTitlesWidget: (value, meta) {
                         int integerValue = value.toInt();
                         var formattedTime = formateMoney(integerValue.toString(), 'en_US');
                         return SideTitleWidget(
                           axisSide: meta.axisSide,
                           space: 0,
                           child: Text(
                             formattedTime.toString(),
                             maxLines: 1,
                             style:   const TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.white),
                           ),
                         );
                       },
                     ),
                   ),
                  ),
                  borderData: FlBorderData(show: false,),
                  maxY: maxY,
                  minY: minY,
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(controller.grafik.length, (i){
                        final data = controller.grafik[i];
                        double x = double.parse(data['x'].toString()); //time
                        double y = double.parse(data['y'].toString()); // price
                        return FlSpot(x, y);
                      }),
                      isCurved: true,
                      barWidth: 2,
                      isStrokeCapRound: false,
                      belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
                      dotData: const FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }
    }

    );
  }
}

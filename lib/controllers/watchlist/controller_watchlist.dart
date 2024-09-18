import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:tes_bni/helpers/helper.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ControllerWatchList extends GetxController {
  late WebSocketChannel channel;
  late WebSocketChannel channel2;
  RxBool isLoadingWatchList = true.obs;
  RxBool isLoadingGrafik = true.obs;
  RxBool isConnectedWatchList = false.obs;
  RxBool isConnectedGrafik = false.obs;
  RxList grafik = [].obs;
  var maxPoints = 15;
  RxList watchList = [].obs;
  RxString kode = "BTC-USD".obs;
  RxString symbols = "".obs;
  RxInt times = 0.obs;
  RxDouble prices = 0.0.obs;
  RxDouble percents = 0.0.obs;
  var cek;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getToWatchlist().then((value) {
      detailWatchList(kode.value);
    });
  }

   Future<dynamic> getToWatchlist()async {
    channel = WebSocketChannel.connect(
      Uri.parse('wss://ws.eodhistoricaldata.com/ws/crypto?api_token=demo'),
    );
    channel.sink.add('{"action": "subscribe", "symbols": "ETH-USD,BTC-USD"}');
    channel.stream.listen((message) {
        var res = jsonDecode(message);
        String symbol = res['s'] ?? '';
        double price = double.tryParse(res['p']?.toString() ?? '0') ?? 0;
        double diffPrice = double.tryParse(res['dd']?.toString() ?? '0') ?? 0;
        double diffPercent = double.tryParse(res['dc']?.toString() ?? '0') ?? 0;

        if (symbol != '') {
          if(kode.value == ""){
            kode.value = symbol;
          }
          var data = {
            'kode': symbol,
            'price': price,
            'diffPrice': diffPrice,
            'diffPercent': diffPercent,
          };

          int index = watchList.indexWhere((item) => item['kode'] == symbol);

          if (index != -1) {
            watchList[index] = data;
          } else {
            watchList.add(data);
          }
        }
        isLoadingWatchList.value = false;
      },
      onError: (error) {
        isConnectedWatchList.value = false;
        isLoadingWatchList.value = false;
      },
      onDone: () {
        isConnectedWatchList.value = false;
        isLoadingWatchList.value = false;
      },
    );

    isConnectedWatchList.value = true;
  }

  void detailWatchList(symbol) {
    grafik.clear();
    channel2 = WebSocketChannel.connect(
      Uri.parse('wss://ws.eodhistoricaldata.com/ws/crypto?api_token=demo'),
    );

    channel2.sink.add('{"action": "subscribe", "symbols": "$symbol"}');
    channel2.stream.listen((message) {
        var res = jsonDecode(message);
        double price = double.tryParse(res['p']?.toString() ?? '0') ?? 0;
        double diffPercent = double.tryParse(res['dc']?.toString() ?? '0') ?? 0;
        var time = res['t']?? 0.0;
        if (grafik.length >= maxPoints) {
          grafik.removeAt(0);
        }
        if(price != 0.0){
          symbols.value = res['s'];
          times.value = time;
          prices.value = price;
          percents.value = diffPercent;
         var data = {
            'x' : time,
            'y' : price,
          };

         if(formateDate(time.toString(),'mm:ss') != cek){
           grafik.addAll({data});
           cek = formateDate(time.toString(),'mm:ss');
         }

        }
        isLoadingGrafik.value = false;
      },
      onError: (error) {
        isConnectedGrafik.value = false;
        isLoadingGrafik.value = false;
      },
      onDone: () {
        isConnectedGrafik.value = false;
        isLoadingGrafik.value = false;
      },
    );

    isConnectedGrafik.value = true;
  }

  void disconnectWebSocket() {
    channel.sink.close();
    channel2.sink.close();
    isConnectedWatchList.value = false;
    isConnectedGrafik.value = false;
  }

  @override
  void onClose() {
    disconnectWebSocket();
    super.onClose();
  }
}

import 'dart:async';
import 'package:notification_listener_service/notification_event.dart';
import 'package:notification_listener_service/notification_listener_service.dart';
import 'dart:convert';
import 'package:nlp/nlp.dart';
import 'package:http/http.dart' as http;
import 'package:wibot/backend/reply.dart';
import 'package:wibot/backend/reply_custom.dart';
import 'package:wibot/database/database_barang.dart';
import 'package:wibot/database/database_chatbot.dart';

class OnOff {
  StreamSubscription<ServiceNotificationEvent>? _subscription;
  List<ServiceNotificationEvent> events = [];
  final statusPerijinan = NotificationListenerService.isPermissionGranted();
  Reply reply = Reply();
  DatabaseBarang dataChatbotCustom = DatabaseBarang();

  cekOnOff(bool statusChatbot, DatabaseBarang? barang, DatabaseChatbot? chatbot) async {
    if (statusChatbot) {
      if (await NotificationListenerService.isPermissionGranted() == false) {
        NotificationListenerService.requestPermission();
      }
      chatbotStart(statusChatbot, barang, chatbot);
    } else {
      chatbotStop(statusChatbot);
    }
  }

  dynamic konversiData(var url) async {
    try {
      var dataset = await http.get(url).timeout(Duration(seconds: 3));
      return jsonDecode(dataset.body);
    } catch (e) {
      return {"error": e.toString()};
    }
  }

  chatbotStart(bool statusChatbot, DatabaseBarang? barang, DatabaseChatbot? chatbot) async {
    int balas = 1;

    var url = Uri.parse("https://lagawayu.com/dataset-wibot");
    var dataset = await konversiData(url);
    List<dynamic> dataNormalization = dataset["normalization"];
    List<dynamic> dataSlangWord = dataset["slangword"];
    List<dynamic> dataStopWord = dataset["stopword"];

    Stages stages = Stages();
    Tree dataTree = Tree(dataNormalization, dataSlangWord, dataStopWord);

    _subscription = NotificationListenerService.notificationsStream.listen((event) async {
      events.add(event);
      stages.setAndNormalization(await stages.stemming(events.last.content.toString()), dataTree.normalization);
      var ambilDataBarang = await barang?.all();
      var dataBarang = ambilDataBarang.toString();
      List<dynamic> data = json.decode(dataBarang);
      var ambilChatbotCustom = await chatbot?.allChatbot();
      var dataChatbotCustom = ambilChatbotCustom.toString();
      List<dynamic> chatbotCustom = json.decode(dataChatbotCustom);

      if (balas == 1) {
        events.last.canReply = true;
        if (ReplayCustom.cekKesesuaianKata(chatbotCustom, events.last.content.toString())) {
          events.last.sendReply(ReplayCustom.pesanBalasan);
        } else {
          if (ReplayCustom.cekKataKunci(events.last.content.toString(), dataTree, chatbotCustom)) {
            events.last.sendReply(ReplayCustom.pesanBalasan);
          } else {
            events.last.sendReply(reply.balasan(stages, dataTree, data, events));
          }
        }
        balas++;
      } else if (balas == 4) {
        balas = 1;
      } else {
        balas++;
      }
    });
    statusChatbot = true;
  }

  chatbotStop(bool statusChatbot) async {
    _subscription?.cancel();
    statusChatbot = false;
  }
}

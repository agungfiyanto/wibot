import 'package:nlp/nlp.dart';

class ReplayCustom {
  static String pesanBalasan = "";

  static bool cekKesesuaianKata(List<dynamic> kataKunci, String pesan) {
    for (int i = 0; i < kataKunci.length; i++) {
      if (kataKunci[i]['kesesuaian'] == "1") {
        if (kataKunci[i]['kataKunci'].toString().toLowerCase() == pesan.toLowerCase()) {
          pesanBalasan = kataKunci[i]['balasan'];
          return true;
        }
      }
    }
    return false;
  }

  static bool cekKataKunci(String pesan, Tree dataTree, List<dynamic> kataKunci) {
    String lowerCasePesan = pesan.toLowerCase();

    if (pesan.contains(' ')) {
      List<dynamic> pesanHasilPecahan = lowerCasePesan.split(' ');
      for (int i = 0; i < kataKunci.length; i++) {
        if (pesanHasilPecahan.contains(kataKunci[i]['kataKunci'].toString().toLowerCase())) {
          pesanBalasan = kataKunci[i]['balasan'];
          return true;
        }
      }
    } else {
      for (int i = 0; i < kataKunci.length; i++) {
        if (lowerCasePesan.contains(kataKunci[i]['kataKunci'].toString().toLowerCase())) {
          pesanBalasan = kataKunci[i]['balasan'];
          return true;
        }
      }
    }
    return false;
  }
}

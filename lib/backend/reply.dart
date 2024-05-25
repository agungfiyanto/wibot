import 'package:nlp/nlp.dart';
import 'package:notification_listener_service/notification_event.dart';
import 'package:wibot/backend/data_deskripsi_toko.dart';

class Reply {
  DataDeskripsiToko informasiToko = DataDeskripsiToko();
  List<dynamic> pesanHasilNLP = [];
  List<String> _hasilPecahNamaBarang = [];
  int _jumlahKesesuaianKata = 0;
  String kata = "";
  int kodePesanKe = 0;
  static List<Map> riwayatPemesan = [];

  String balasan(Stages stages, Tree dataTree, List<dynamic> barang, List<ServiceNotificationEvent> events) {
    stages.slangWord(dataTree.slangWord);
    stages.filtering(dataTree.stopWord);
    pesanHasilNLP = stages.kalimat;

    if (pesanHasilNLP.contains("beli") || pesanHasilNLP.contains("pesan")) {
      setKata("beli", "pesan");
      return memesan(barang, events);
    } else if (pesanHasilNLP.contains("order")) {
      setKata("order");
      return memesan(barang, events);
    } else if (pesanHasilNLP.contains("stok") ||
        pesanHasilNLP.contains("ready") ||
        pesanHasilNLP.contains("sedia") ||
        pesanHasilNLP.contains("produk")) {
      return stok(barang);
    } else if (pesanHasilNLP.contains("harga")) {
      return harga(barang);
    } else if (pesanHasilNLP.contains("buka") || pesanHasilNLP.contains("tutup") || pesanHasilNLP.contains("2")) {
      return "Kami buka dari jam ${informasiToko.getWaktuBuka()} sampai jam ${informasiToko.getWaktuTutup()} kak";
    } else if (pesanHasilNLP.contains("terima kasih")) {
      return "iya kak, sama-sama";
    } else if (pesanHasilNLP.contains("qna")) {
      return "Pilih nomer berikut untuk melihat informasi lebih lanjut :\n1. Kesediaan barang yang dijual\n2. Jam buka dan tutup\n3. Cara untuk membeli barang\n4. Pertanyaan yang bisa dijawab\n5. Informasi toko";
    } else if (pesanHasilNLP.contains('assalamualaikum') ||
        pesanHasilNLP.contains('selamat') ||
        pesanHasilNLP.contains('halo')) {
      if (!pesanHasilNLP.contains('selamat')) {
        setKata("assalamualaikum", "halo");
        if (kata == 'assalamualaikum') {
          kata = "wa'alaikumussalam";
        }
        return "$kata kak, ada yang bisa dibantu. Untuk melihat informasi toko kami ketikan *qna*";
      } else {
        kata = 'iya';
        return "$kata kak, ada yang bisa dibantu. Untuk melihat informasi toko kami ketikan *qna*";
      }
    } else if (pesanHasilNLP.contains('bagus') || pesanHasilNLP.contains('enak')) {
      return "Terimakasih kak atas pujiannya, jangan lupa untuk pesan lagi ya";
    } else if (pesanHasilNLP.contains('buruk') || pesanHasilNLP.contains('jelek')) {
      return "Mohon maaf atas ketidak nyaman dari pelayanan kami kak, kami akan memperbaikinya.";
    } else if (pesanHasilNLP.contains("1")) {
      return stok(barang);
    } else if (pesanHasilNLP.contains("3")) {
      return "Anda bisa ketikan *beli* lalu sebutkan nama barang yang ingin dibeli.\n\nContoh : beli meja";
    } else if (pesanHasilNLP.contains("4")) {
      return "Kami bisa menjawab pertanyaan yang terdapat kata kunci *beli*, *stok*, *harga* dan *buka*";
    } else if (pesanHasilNLP.contains("5")) {
      return "Nama toko kami ${informasiToko.getNamaToko()}.\n${informasiToko.getDeskripsiToko()}";
    } else {
      if (kodePesanKe == 1) {
        return memesan(barang, events);
      } else if (kodePesanKe == 2) {
        return harga(barang);
      } else {
        return "Untuk melihat informasi toko kami ketikan *qna*.";
      }
    }
  }

  void setKata(String kataPertama, [String? kataKedua]) {
    if (kataKedua != null) {
      kata = pesanHasilNLP[
          pesanHasilNLP.contains(kataPertama) ? pesanHasilNLP.indexOf(kataPertama) : pesanHasilNLP.indexOf(kataKedua)];
    } else {
      if (pesanHasilNLP.contains(kataPertama)) {
        kata = pesanHasilNLP[pesanHasilNLP.indexOf(kataPertama)];
      }
    }
    pesanHasilNLP.remove(kata);
  }

  bool cekBarangDuaKataLebih(String barang) {
    _jumlahKesesuaianKata = 0;
    _hasilPecahNamaBarang = barang.split(' ');
    if (barang.contains(' ')) {
      for (int i = 0; i < _hasilPecahNamaBarang.length; i++) {
        if (pesanHasilNLP.contains(_hasilPecahNamaBarang[i])) {
          _jumlahKesesuaianKata += 1;
        }
      }
      return _jumlahKesesuaianKata == _hasilPecahNamaBarang.length ? true : false;
    } else if (pesanHasilNLP.contains(barang)) {
      return true;
    } else {
      return false;
    }
  }

  String memesan(List<dynamic> barang, List<ServiceNotificationEvent> events) {
    for (int i = 0; i < barang.length; i++) {
      if (cekBarangDuaKataLebih(barang[i]["namaBarang"])) {
        if (barang[i]['stokBarang'] != "0") {
          kodePesanKe = 0;
          riwayatPemesan.add({
            'nama': events.last.title.toString(),
            'barang': barang[i]['namaBarang'].toString(),
            'waktu': DateTime.now()
          });
          return "Baik kak, kami akan proses pemesanan ${barang[i]["namaBarang"]}-nya";
        } else {
          kodePesanKe = 0;
          return "Mohon maaf kak, untuk ${barang[i]["namaBarang"]} stok kosong";
        }
      }
    }
    if (kodePesanKe == 1) {
      kodePesanKe = 0;
      return "Maaf kami tidak tidak jualan yang kakak maksud\nUntuk melihat informasi lebih lanjut ketikan *qna*";
    }
    kodePesanKe = 1;
    return "Mau $kata apa kak ?";
  }

  String stok(List<dynamic> barang) {
    for (int i = 0; i < barang.length; i++) {
      if (cekBarangDuaKataLebih(barang[i]["namaBarang"]) && barang[i]["stokBarang"] != "0") {
        return "${barang[i]['namaBarang']} ready, silahkan bisa di order";
      } else if (cekBarangDuaKataLebih(barang[i]["namaBarang"])) {
        return "Mohon maaf, untuk ${barang[i]['namaBarang']} stoknya habis";
      }
    }
    if (barang.isEmpty) {
      return "Mohon maaf kak, semua stok habis";
    } else {
      kata = "Saat ini, kami ready\n";
      for (var dataBarang in barang) {
        if (dataBarang['stokBarang'] != "0") {
          kata += "${dataBarang['namaBarang']} : ${dataBarang['stokBarang']}\n";
        }
      }
      return kata;
    }
  }

  String harga(List<dynamic> barang) {
    for (int i = 0; i < barang.length; i++) {
      if (cekBarangDuaKataLebih(barang[i]["namaBarang"])) {
        kodePesanKe = 0;
        return "Untuk ${barang[i]['namaBarang']} harganya ${barang[i]['hargaBarang']} kak";
      }
    }
    if (kodePesanKe == 2) {
      kodePesanKe = 0;
      return "Maaf, kami tidak menjual yang kakak sebutkan.\nketik qna untuk mencari tau info lebih lanjut";
    } else {
      kodePesanKe = 2;
      return "Maaf, harga yang mana kak";
    }
  }
}

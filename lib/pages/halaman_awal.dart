import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:wibot/backend/reply.dart';

import 'package:wibot/database/database_barang.dart';
import 'package:wibot/database/database_chatbot.dart';
import 'package:wibot/model/barang_model.dart';
import 'package:wibot/pages/deskripsi_toko.dart';
import 'package:wibot/pages/kelola_barang.dart';
import 'package:wibot/pages/membuat_chatbot.dart';
import 'package:wibot/pages/pesanan.dart';
import 'package:wibot/style_umum/icon.dart';
import 'package:wibot/style_umum/warna.dart';
import 'package:wibot/style_umum/font.dart';
import 'package:wibot/backend/on_off.dart';
import 'package:wibot/pages/komponen/kom_box_pesanan.dart';

class HalamanAwal extends StatefulWidget {
  const HalamanAwal({super.key});

  @override
  State<HalamanAwal> createState() => _HalamanAwalState();
}

class _HalamanAwalState extends State<HalamanAwal> {
  bool statusChatbot = false;
  DatabaseBarang? databaseBarang;
  DatabaseChatbot? databaseChatbot;
  OnOff onOff = OnOff();

  final MaterialStateProperty<Icon?> thumbIcon = MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  Future _refresh() async {
    setState(() {});
  }

  Future initDatabase() async {
    await databaseBarang!.cekDatabase();
    await databaseChatbot!.cekDatabase();
    setState(() {});
  }

  @override
  void initState() {
    databaseBarang = DatabaseBarang();
    databaseChatbot = DatabaseChatbot();
    initDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "CHATBOT",
          style: Font.judulH1(Warna.biruKehijauan(1)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: tombolSwitchUtama(context, databaseBarang, databaseChatbot),
          )
        ],
      ),
      body: RefreshIndicator(onRefresh: _refresh, child: TampilanBody()),
    );
  }

  Widget tombolSwitchUtama(BuildContext context, DatabaseBarang? barang, DatabaseChatbot? chatbot) {
    return Switch(
        value: statusChatbot,
        activeColor: Warna.kuning(1),
        thumbIcon: thumbIcon,
        activeTrackColor: Warna.biruKehijauan(1),
        onChanged: (bool value) {
          setState(() {
            statusChatbot = value;
          });
          onOff.cekOnOff(statusChatbot, barang, chatbot);
        });
  }
}

class TampilanBody extends StatefulWidget {
  @override
  State<TampilanBody> createState() => _TampilanBodyState();
}

class _TampilanBodyState extends State<TampilanBody> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            FittedBox(
              child: Text(
                '! Lengkapi deskripsi toko, supaya chatbot semakin pintar',
                style: Font.keterangan(Warna.merah(1)),
              ),
            ),
            const SizedBox(height: 7),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Warna.biruKehijauan(1)),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => DeskripsiToko()));
              },
              child: Container(
                padding: const EdgeInsets.all(7),
                alignment: Alignment.centerLeft,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  'Deskripsi Toko',
                  style: Font.judulH2(Warna.putih(1)),
                ),
              ),
            ),
            Divider(
              height: 40,
              thickness: 0.5,
              indent: 10,
              endIndent: 10,
              color: Warna.biruKehijauan(0.2),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Iconify(
                        IconCustom.boxOpen,
                        size: 15,
                        color: Warna.biruKehijauan(1),
                      ),
                    ),
                    Text(
                      'Chatbot Barang',
                      style: Font.judulH2(Warna.biruKehijauan(1)),
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Warna.biruKehijauan(1)),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return KelolaBarang();
                })).then((value) {
                  setState(() {});
                });
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                alignment: Alignment.centerLeft,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Kelola Barang', style: Font.judulH2(Warna.putih(1))),
                    Iconify(
                      IconCustom.listEdit,
                      size: 24,
                      color: Warna.kuning(1),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Iconify(
                    IconCustom.list,
                    size: 20,
                    color: Warna.biruKehijauan(1),
                  ),
                ),
                Text(
                  'Stok Barang',
                  style: Font.judulH2(Warna.biruKehijauan(1)),
                )
              ],
            ),
            const SizedBox(
              height: 7,
            ),
            DaftarBarang(),
            Divider(
              height: 40,
              thickness: 0.5,
              indent: 10,
              endIndent: 10,
              color: Warna.biruKehijauan(0.2),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Iconify(
                    IconCustom.newMessage,
                    color: Warna.biruKehijauan(1),
                    size: 17,
                  ),
                ),
                Text(
                  'Pesanan Terbaru',
                  style: Font.judulH2(Warna.biruKehijauan(1)),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: Reply.riwayatPemesan.isEmpty
                  ? 1
                  : Reply.riwayatPemesan.length <= 3
                      ? Reply.riwayatPemesan.length
                      : 3,
              itemBuilder: (BuildContext context, int index) {
                return Reply.riwayatPemesan.isEmpty
                    ? Center(
                        child: Text(
                          'Belum ada pesanan',
                          style: Font.judulH2(Warna.merah(1)),
                        ),
                      )
                    : KomBoxPesanan.box(
                        Text(
                          '${Reply.riwayatPemesan[index]['barang']}, pesanan dari ${Reply.riwayatPemesan[index]['nama']}',
                          style: Font.keterangan(Warna.biruKehijauan(1)),
                        ),
                        10);
              },
              separatorBuilder: (context, index) => const SizedBox(
                height: 10,
              ),
            ),
            Divider(
              height: 40,
              thickness: 0.5,
              indent: 10,
              endIndent: 10,
              color: Warna.biruKehijauan(0.2),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Iconify(
                    IconCustom.more,
                    size: 35,
                    color: Warna.biruKehijauan(1),
                  ),
                ),
                Text(
                  'Lainnya',
                  style: Font.judulH2(Warna.biruKehijauan(1)),
                )
              ],
            ),
            const SizedBox(height: 7),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return const MembuatChatbot();
                  })).then((value) {
                    setState(() {});
                  });
                },
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      height: 40,
                      width: double.infinity,
                      margin: const EdgeInsets.only(left: 20),
                      padding: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          color: Warna.biruKehijauan(1),
                          borderRadius: const BorderRadius.horizontal(right: Radius.circular(5))),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Membuat Chatbot',
                          style: Font.judulH2(Warna.putih(1)),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 100),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Warna.kuning(1),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(color: Colors.black38, blurRadius: 5, spreadRadius: 1, offset: Offset(4, 0))
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Iconify(
                          IconCustom.editMessage,
                          color: Warna.biruKehijauan(1),
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return KelolaBarang();
                  })).then((value) {
                    setState(() {});
                  });
                },
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      height: 40,
                      width: double.infinity,
                      margin: const EdgeInsets.only(left: 20),
                      padding: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          color: Warna.biruKehijauan(1),
                          borderRadius: const BorderRadius.horizontal(right: Radius.circular(5))),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Kelola Barang',
                          style: Font.judulH2(Warna.putih(1)),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 100),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Warna.kuning(1),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(color: Colors.black38, blurRadius: 5, spreadRadius: 1, offset: Offset(4, 0))
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Iconify(
                          IconCustom.goods,
                          color: Warna.biruKehijauan(1),
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return const Pesanan();
                  })).then((value) {
                    setState(() {});
                  });
                },
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      height: 40,
                      width: double.infinity,
                      margin: const EdgeInsets.only(left: 20),
                      padding: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          color: Warna.biruKehijauan(1),
                          borderRadius: const BorderRadius.horizontal(right: Radius.circular(5))),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Pesanan',
                          style: Font.judulH2(Warna.putih(1)),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 100),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Warna.kuning(1),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(color: Colors.black38, blurRadius: 5, spreadRadius: 1, offset: Offset(4, 0))
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Iconify(
                          IconCustom.order,
                          color: Warna.biruKehijauan(1),
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DaftarBarang extends StatefulWidget {
  const DaftarBarang({
    super.key,
  });

  @override
  State<DaftarBarang> createState() => _DaftarBarangState();
}

class _DaftarBarangState extends State<DaftarBarang> {
  DatabaseBarang? databaseBarang;

  Future initDatabase() async {
    await databaseBarang!.cekDatabase();
    setState(() {});
  }

  @override
  void initState() {
    databaseBarang = DatabaseBarang();
    initDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return databaseBarang != null
        ? FutureBuilder<List<BarangModel>>(
            future: databaseBarang!.all(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.length == 0) {
                  return const Text(
                    ' Data Masih Kosong',
                    style: TextStyle(color: Colors.red),
                  );
                }
                return SizedBox(
                  height: 100,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Container(
                            width: 100,
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
                                  child: Container(
                                    color: Warna.biruKehijauan(1),
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                    width: double.infinity,
                                    height: 60,
                                    child: Center(
                                      child: Text(
                                        snapshot.data![index].namaBarang ?? '',
                                        textAlign: TextAlign.center,
                                        style: Font.judulH2(Warna.putih(1)),
                                      ),
                                    ),
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(5)),
                                  child: Container(
                                    color: Warna.kuning(1),
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    width: double.infinity,
                                    height: 40,
                                    child: Center(
                                      child: Text(
                                        snapshot.data![index].stokBarang.toString(),
                                        textAlign: TextAlign.center,
                                        style: Font.judulH2(Warna.biruKehijauan(1)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                );
              } else {
                return const Center(
                  child: Text('Terdapat kesalahan kode'),
                );
              }
            })
        : Center(
            child: CircularProgressIndicator(color: Warna.biruKehijauan(1)),
          );
  }
}

import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:intl/intl.dart';
import 'package:wibot/pages/komponen/kom_background.dart';
import 'package:wibot/style_umum/font.dart';
import 'package:wibot/style_umum/icon.dart';
import 'package:wibot/style_umum/warna.dart';

import '../backend/reply.dart';

class Pesanan extends StatefulWidget {
  const Pesanan({super.key});

  @override
  State<Pesanan> createState() => _PesananState();
}

class _PesananState extends State<Pesanan> {
  Future _refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.kuning(1),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Stack(
          children: [KomBackground.background(IconCustom.order, 'PESANAN', context), const Foreground()],
        ),
      ),
    );
  }
}

class Foreground extends StatefulWidget {
  const Foreground({super.key});

  @override
  State<Foreground> createState() => _ForegroundState();
}

class _ForegroundState extends State<Foreground> {
  @override
  Widget build(BuildContext context) {
    double heightBody = MediaQuery.of(context).size.height;
    double bodyAtas = heightBody / 2.5;
    double bodyBawah = heightBody - bodyAtas;

    return SingleChildScrollView(
        child: Column(
      children: [
        SizedBox(
          height: bodyAtas,
          width: double.infinity,
        ),
        ConstrainedBox(
            constraints: BoxConstraints(minHeight: bodyBawah, minWidth: double.infinity),
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 40),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 17, offset: Offset(0, -4)),
                    ]),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Iconify(
                                IconCustom.HistoryMessage,
                              ),
                            ),
                            Text('Riwayat Pesanan', style: Font.judulH2(Warna.biruKehijauan(1)))
                          ],
                        ),
                        TextButton(
                            onPressed: () => showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: const Text('Peringatan'),
                                      content: const Text('Apakah anda yakin, semua riwayat pesan akan dihapus ?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, 'Batal'),
                                          child: const Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Reply.riwayatPemesan.clear();
                                            setState(() {});
                                            Navigator.pop(context, 'Iya');
                                          },
                                          child: const Text('Iya'),
                                        ),
                                      ],
                                    )),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(color: Warna.merah(1), borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                "Hapus semua",
                                style: Font.judulH2(Warna.putih(1)),
                              ),
                            )),
                      ],
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: Reply.riwayatPemesan.isEmpty ? 1 : Reply.riwayatPemesan.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Reply.riwayatPemesan.isEmpty
                            ? Center(
                                child: Text('Belum ada pesanan', style: Font.judulH2(Warna.merah(1))),
                              )
                            : Container(
                                padding: EdgeInsets.symmetric(vertical: 11, horizontal: 10),
                                decoration: BoxDecoration(
                                    color: Warna.biruKehijauan(1), borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: Text(
                                          '${Reply.riwayatPemesan[index]['barang']}, pesanan dari ${Reply.riwayatPemesan[index]['nama']}',
                                          style: Font.keterangan(Warna.putih(1)),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${DateFormat("d MMM yyyy").format(Reply.riwayatPemesan[index]['waktu'])}',
                                              style: Font.judulH2(Warna.putih(1)),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              '${DateFormat("HH:mm").format(Reply.riwayatPemesan[index]['waktu'])}',
                                              style: Font.keterangan(Warna.putih(1)),
                                            )
                                          ]),
                                    )
                                  ],
                                ),
                              );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                    )
                  ],
                )))
      ],
    ));
  }
}

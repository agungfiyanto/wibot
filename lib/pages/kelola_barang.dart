import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:wibot/database/database_barang.dart';
import 'package:wibot/model/barang_model.dart';
import 'package:wibot/pages/komponen/kom_background.dart';
import 'package:wibot/style_umum/font.dart';
import 'package:wibot/style_umum/icon.dart';
import 'package:wibot/style_umum/warna.dart';

class KelolaBarang extends StatefulWidget {
  @override
  State<KelolaBarang> createState() => _KelolaBarangState();
}

class _KelolaBarangState extends State<KelolaBarang> {
  TextEditingController inputNamaBarang = TextEditingController();
  TextEditingController inputHargaBarang = TextEditingController();
  TextEditingController inputStokBarang = TextEditingController();
  DatabaseBarang databaseBarang = DatabaseBarang();

  @override
  void initState() {
    databaseBarang.cekDatabase();
    super.initState();
  }

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
          children: [KomBackground.background(IconCustom.threeBox, 'KELOLA BARANG', context), Foreground()],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Iconify(IconCustom.boxAdd),
        backgroundColor: Warna.biruKehijauan(1),
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            barrierColor: Warna.kuning(0.9),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
            context: context,
            builder: (context) {
              return TampilanBottomSheet(
                  inputNamaBarang: inputNamaBarang,
                  inputHargaBarang: inputHargaBarang,
                  inputStokBarang: inputStokBarang,
                  databaseBarang: databaseBarang);
            },
          ).then((value) {
            setState(() {});
          });
        },
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
  TextEditingController inputNamaBarang = TextEditingController();
  TextEditingController inputHargaBarang = TextEditingController();
  TextEditingController inputStokBarang = TextEditingController();
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

  Future delete(int id) async {
    await databaseBarang!.delete(id);
    setState(() {});
  }

  Future _refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double heightBody = MediaQuery.of(context).size.height;
    double bodyAtas = heightBody / 2.5;
    double bodyBawah = heightBody - bodyAtas;

    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(children: [
        SizedBox(
          height: bodyAtas,
          width: double.infinity,
        ),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: bodyBawah, minWidth: double.infinity),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
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
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Iconify(
                        IconCustom.bar,
                        color: Warna.biruKehijauan(1),
                        size: 24,
                      ),
                    ),
                    Text(
                      'Stok Barang',
                      style: Font.judulH2(Warna.biruKehijauan(1)),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                databaseBarang != null
                    ? FutureBuilder<List<BarangModel>>(
                        future: databaseBarang!.all(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.length == 0) {
                              return Text('Data Masih Kosong');
                            }
                            return GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data!.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 1.9,
                                    mainAxisSpacing: 15,
                                    crossAxisSpacing: 10),
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black12,
                                            offset: Offset(
                                              0,
                                              4.0,
                                            ),
                                            blurRadius: 4,
                                          )
                                        ],
                                        color: Colors.white),
                                    child: Column(children: [
                                      Text(snapshot.data![index].namaBarang ?? '',
                                          style: Font.judulH2(
                                            Warna.biruKehijauan(1),
                                          )),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          TextButton(
                                              onPressed: () async {
                                                if (snapshot.data![index].stokBarang != null &&
                                                    snapshot.data![index].stokBarang! > 0) {
                                                  int minSatuStokBarang = snapshot.data![index].stokBarang! - 1;
                                                  databaseBarang!.update(index + 1, {"stok_barang": minSatuStokBarang});
                                                }
                                                setState(() {});
                                              },
                                              child: Iconify(IconCustom.minRounded)),
                                          Text(
                                            snapshot.data![index].stokBarang.toString(),
                                            style: Font.keterangan(Warna.biruKehijauan(1)),
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                if (snapshot.data![index].stokBarang != null) {
                                                  int minSatuStokBarang = snapshot.data![index].stokBarang! + 1;
                                                  databaseBarang!.update(index + 1, {"stok_barang": minSatuStokBarang});
                                                }
                                                setState(() {});
                                              },
                                              child: Iconify(IconCustom.plusRounded))
                                        ],
                                      ),
                                    ]),
                                  );
                                });
                          } else {
                            return const Center(
                              child: Text('Terdapat kesalahan kode'),
                            );
                          }
                        })
                    : Center(
                        child: CircularProgressIndicator(color: Warna.biruKehijauan(1)),
                      ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Iconify(
                        IconCustom.boxEdit,
                        size: 24,
                      ),
                    ),
                    Text(
                      'Edit Barang',
                      style: Font.judulH2(Warna.biruKehijauan(1)),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                FutureBuilder<List<BarangModel>>(
                    future: databaseBarang!.all(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.length == 0) {
                          return Text('Data Masih Kosong');
                        }
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: Container(
                                  decoration:
                                      BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(5)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(left: 20),
                                        width: 150,
                                        child: Text(
                                          snapshot.data![index].namaBarang ?? '',
                                          style: Font.judulH2(Warna.biruKehijauan(1)),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          TextButton(
                                            child: Iconify(
                                              IconCustom.pencil,
                                              size: 18,
                                            ),
                                            onPressed: () {
                                              showModalBottomSheet(
                                                isScrollControlled: true,
                                                barrierColor: Warna.kuning(0.9),
                                                shape: const RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
                                                context: context,
                                                builder: (context) {
                                                  return TampilanBottomSheet(
                                                    inputNamaBarang: inputNamaBarang,
                                                    inputHargaBarang: inputHargaBarang,
                                                    inputStokBarang: inputStokBarang,
                                                    databaseBarang: databaseBarang!,
                                                    barangmodel: snapshot.data![index],
                                                  );
                                                },
                                              ).then((value) {
                                                setState(() {});
                                              });
                                            },
                                          ),
                                          TextButton(
                                              onPressed: () => showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) => AlertDialog(
                                                        title: const Text('Peringatan'),
                                                        content: const Text('Data barang ini akan dihapus ?'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () => Navigator.pop(context, 'Batal'),
                                                            child: const Text('Batal'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              delete(snapshot.data![index].id!);
                                                              Navigator.pop(context, 'Iya');
                                                            },
                                                            child: const Text('Iya'),
                                                          ),
                                                        ],
                                                      )),
                                              child: Iconify(
                                                IconCustom.delete,
                                                size: 18,
                                                color: Warna.merah(1),
                                              )),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                      } else {
                        return const Center(
                          child: Text('Terdapat kesalahan kode'),
                        );
                      }
                    }),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        )
      ]),
    );
  }
}

class TampilanBottomSheet extends StatefulWidget {
  const TampilanBottomSheet({
    super.key,
    required this.inputNamaBarang,
    required this.inputHargaBarang,
    required this.inputStokBarang,
    required this.databaseBarang,
    this.barangmodel,
  });

  final TextEditingController inputNamaBarang;
  final TextEditingController inputHargaBarang;
  final TextEditingController inputStokBarang;
  final DatabaseBarang databaseBarang;
  final BarangModel? barangmodel;

  @override
  State<TampilanBottomSheet> createState() => _TampilanBottomSheetState();
}

class _TampilanBottomSheetState extends State<TampilanBottomSheet> {
  int? cekStatusPerubahan;
  @override
  void initState() {
    widget.databaseBarang.cekDatabase();
    if (widget.barangmodel != null) {
      widget.inputNamaBarang.text = widget.barangmodel!.namaBarang ?? '';
      widget.inputHargaBarang.text = widget.barangmodel!.hargaBarang.toString();
      widget.inputStokBarang.text = widget.barangmodel!.stokBarang.toString();
    } else {
      widget.inputNamaBarang.text = '';
      widget.inputHargaBarang.text = '';
      widget.inputStokBarang.text = '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        decoration:
            BoxDecoration(color: Warna.biruKehijauan(1), borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nama Barang',
              style: Font.judulH2(Warna.putih(1)),
            ),
            const SizedBox(height: 7),
            TextField(
              controller: widget.inputNamaBarang,
              decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: Warna.putih(1),
                  contentPadding: const EdgeInsets.only(bottom: 20, right: 10, left: 10),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
            ),
            const SizedBox(height: 17),
            Text(
              'Harga',
              style: Font.judulH2(Warna.putih(1)),
            ),
            const SizedBox(height: 7),
            TextField(
              keyboardType: TextInputType.number,
              controller: widget.inputHargaBarang,
              decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: Warna.putih(1),
                  contentPadding: const EdgeInsets.only(bottom: 20, right: 10, left: 10),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
            ),
            const SizedBox(height: 17),
            Text(
              'stok',
              style: Font.judulH2(Warna.putih(1)),
            ),
            const SizedBox(height: 7),
            TextField(
              keyboardType: TextInputType.number,
              controller: widget.inputStokBarang,
              decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: Warna.putih(1),
                  contentPadding: const EdgeInsets.only(bottom: 20, right: 10, left: 10),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
            ),
            const SizedBox(height: 39),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 100,
                decoration: BoxDecoration(color: Warna.kuning(1), borderRadius: BorderRadius.circular(100)),
                child: TextButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Iconify(
                        IconCustom.boxAdd2,
                        size: 24,
                        color: Warna.biruKehijauan(1),
                      ),
                      Text(
                        'Simpan',
                        style: Font.keterangan(Warna.biruKehijauan(1)),
                      )
                    ],
                  ),
                  onPressed: () async {
                    if (widget.barangmodel != null) {
                      await widget.databaseBarang.update(widget.barangmodel!.id!, {
                        'nama_barang': widget.inputNamaBarang.text,
                        'stok_barang': int.parse(widget.inputStokBarang.text),
                        'harga_barang': int.parse(widget.inputHargaBarang.text)
                      });
                    } else {
                      await widget.databaseBarang.insert({
                        'nama_barang': widget.inputNamaBarang.text,
                        'stok_barang': int.parse(widget.inputStokBarang.text),
                        'harga_barang': int.parse(widget.inputHargaBarang.text)
                      });
                    }
                    Navigator.pop(context);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

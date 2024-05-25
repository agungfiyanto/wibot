import 'package:flutter/material.dart';
import 'package:wibot/backend/data_deskripsi_toko.dart';
import 'package:wibot/backend/on_off.dart';
import 'package:wibot/pages/komponen/kom_background.dart';
import 'package:wibot/style_umum/font.dart';
import 'package:wibot/style_umum/icon.dart';
import 'package:wibot/style_umum/warna.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class DeskripsiToko extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.kuning(1),
      body: Stack(
        children: [
          KomBackground.background(
              IconCustom.storeEdit, 'DESKRIPSI TOKO', context),
          const Foreground()
        ],
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
  Time _waktuBuka = Time(hour: 11, minute: 00);
  Time _waktuTutup = Time(hour: 12, minute: 00);
  DataDeskripsiToko deskripsiToko = DataDeskripsiToko();
  TextEditingController _controllerNamaToko = TextEditingController();
  TextEditingController _controllerDeskripsiToko = TextEditingController();
  OnOff restartChatbot = OnOff();

  // Variabel sementara;
  dynamic tes = true;

  @override
  void initState() {
    if (deskripsiToko.getNamaToko() != null) {
      _controllerNamaToko =
          TextEditingController(text: deskripsiToko.getNamaToko());
    }
    if (deskripsiToko.getDeskripsiToko() != null) {
      _controllerDeskripsiToko =
          TextEditingController(text: deskripsiToko.getDeskripsiToko());
    }
    if (deskripsiToko.getWaktuBuka() != null) {
      _waktuBuka = Time(
          hour: int.parse(deskripsiToko.getWaktuBuka()[0]),
          minute: int.parse(deskripsiToko.getWaktuBuka()[1]));
    }
    if (deskripsiToko.getWaktuTutup() != null) {
      _waktuTutup = Time(
          hour: int.parse(deskripsiToko.getWaktuTutup()[0]),
          minute: int.parse(deskripsiToko.getWaktuTutup()[1]));
    }
  }

  void aturWaktuBuka(Time newTime) {
    setState(() {
      _waktuBuka = newTime;
    });
  }

  void aturWaktuTutup(Time newTime) {
    setState(() {
      _waktuTutup = newTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    double heightBody = MediaQuery.of(context).size.height;
    double bodyAtas = heightBody / 2.5;
    double bodyBawah = heightBody - bodyAtas;

    DataDeskripsiToko informasiToko = DataDeskripsiToko();

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: bodyAtas,
            width: double.infinity,
          ),
          ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: bodyBawah, minWidth: double.infinity),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 17,
                        offset: Offset(0, -4)),
                  ]),
              child: Column(children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 90,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Warna.biruKehijauan(1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Iconify(
                            IconCustom.save,
                            color: Warna.putih(1),
                            size: 15,
                          ),
                          Text(
                            'Simpan',
                            style: Font.judulH2(Warna.putih(1)),
                          )
                        ],
                      ),
                      onPressed: () {
                        if (_controllerNamaToko.text != "") {
                          deskripsiToko.setNamaToko(_controllerNamaToko.text);
                        }
                        if (_controllerDeskripsiToko.text != "") {
                          deskripsiToko
                              .setDeskripsiToko(_controllerDeskripsiToko.text);
                        }
                        if (_controllerDeskripsiToko.text != "" &&
                            _controllerNamaToko.text != "") {
                          showTopSnackBar(
                            displayDuration: Duration(milliseconds: 300),
                            Overlay.of(context),
                            const CustomSnackBar.success(
                              message: 'Data berhasil disimpan',
                            ),
                          );
                        } else {
                          showTopSnackBar(
                            displayDuration: Duration(milliseconds: 300),
                            Overlay.of(context),
                            const CustomSnackBar.info(
                              message: "Ada data yang tidak di isi",
                            ),
                          );
                        }
                        deskripsiToko.setWaktu(
                            waktuBuka: konversiWaktu(
                                _waktuBuka.hour, _waktuBuka.minute),
                            waktuTutup: konversiWaktu(
                                _waktuTutup.hour, _waktuTutup.minute));
                      },
                    ),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Iconify(
                        IconCustom.store,
                        color: Warna.biruKehijauan(1),
                        size: 25,
                      ),
                    ),
                    Text(
                      'Nama Toko',
                      style: Font.judulH2(Warna.biruKehijauan(1)),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _controllerNamaToko,
                  style: TextStyle(fontSize: 17, height: 1.2),
                  decoration: InputDecoration(
                      isDense: true,
                      contentPadding:
                          EdgeInsets.only(bottom: 20, right: 10, left: 10),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1.5, color: Warna.biruKehijauan(1)),
                          borderRadius: BorderRadius.circular(5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1.5, color: Colors.blue),
                          borderRadius: BorderRadius.circular(5))),
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Iconify(
                        IconCustom.storeSettings,
                        color: Warna.biruKehijauan(1),
                        size: 25,
                      ),
                    ),
                    Text('Deskripsi Toko',
                        style: Font.judulH2(Warna.biruKehijauan(1))),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  maxLength: 100,
                  maxLines: 5,
                  minLines: 1,
                  controller: _controllerDeskripsiToko,
                  style: const TextStyle(fontSize: 17, height: 1.2),
                  decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.only(
                          bottom: 20, right: 10, left: 10),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1.5, color: Warna.biruKehijauan(1)),
                          borderRadius: BorderRadius.circular(5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1.5, color: Colors.blue),
                          borderRadius: BorderRadius.circular(5))),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Iconify(
                          IconCustom.storeClock,
                          color: Warna.biruKehijauan(1),
                          size: 25,
                        )),
                    Text(
                      'Jam Kerja',
                      style: Font.judulH2(Warna.biruKehijauan(1)),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 100,
                      width: 130,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Warna.mint(1)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            konversiWaktu(_waktuBuka.hour, _waktuBuka.minute)
                                .toUpperCase(),
                            style: Font.judulH1(Warna.biruKehijauan(1)),
                          ),
                          TextButton(
                              style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  backgroundColor: Warna.biruKehijauan(1),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              onPressed: () {
                                Navigator.of(context).push(
                                  showPicker(
                                      context: context,
                                      value: _waktuBuka,
                                      onChange: aturWaktuBuka,
                                      iosStylePicker: true,
                                      is24HrFormat: true),
                                );
                              },
                              child: Text(
                                'Jam Buka',
                                style: Font.judulH2(Warna.putih(1)),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      height: 100,
                      width: 130,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Warna.merah(0.5)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            konversiWaktu(_waktuTutup.hour, _waktuTutup.minute)
                                .toUpperCase(),
                            style: Font.judulH1(Warna.biruKehijauan(1)),
                          ),
                          TextButton(
                              style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  backgroundColor: Warna.biruKehijauan(1),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              onPressed: () {
                                Navigator.of(context).push(
                                  showPicker(
                                      context: context,
                                      value: _waktuTutup,
                                      onChange: aturWaktuTutup,
                                      iosStylePicker: true,
                                      is24HrFormat: true),
                                );
                              },
                              child: Text(
                                'Jam Tutup',
                                style: Font.judulH2(Warna.putih(1)),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                /* Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Iconify(
                        IconCustom.category,
                        size: 30,
                        color: Warna.biruKehijauan(1),
                      ),
                    ),
                    Text(
                      'Kategori Barang',
                      style: Font.judulH2(Warna.biruKehijauan(1)),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: Warna.biruKehijauan(1), width: 2),
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              tes = !tes;
                            });
                          },
                          child: tes
                              ? Icon(
                                  Icons.check_rounded,
                                  color: Warna.biruKehijauan(1),
                                )
                              : Icon(
                                  Icons.check_rounded,
                                  color: Warna.putih(0),
                                ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(5)),
                              color: Warna.biruKehijauan(1)),
                          child: Text(
                            'Minuman',
                            style: Font.judulH2(Warna.putih(1)),
                          ),
                        ),
                      )
                    ],
                  ),
                ), */
              ]),
            ),
          ),
        ],
      ),
    );
  }

  String konversiWaktu(int jam, int menit) {
    List<String> satuanWaktu = ['0', '0'];
    String waktu = '';

    if (jam < 10) {
      satuanWaktu[0] = '0' + jam.toString();
    } else {
      satuanWaktu[0] = jam.toString();
    }

    if (menit < 10) {
      satuanWaktu[1] = '0' + menit.toString();
    } else {
      satuanWaktu[1] = menit.toString();
    }

    waktu = satuanWaktu[0] + ':' + satuanWaktu[1];
    return waktu;
  }
}

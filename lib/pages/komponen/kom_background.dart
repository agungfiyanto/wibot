import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:wibot/style_umum/font.dart';
import 'package:wibot/style_umum/warna.dart';

class KomBackground {
  static Widget background(String icon, String text, BuildContext context) {
    double tinggiMargin = MediaQuery.of(context).size.height * 0.15;

    return Container(
      margin: EdgeInsets.only(top: tinggiMargin),
      width: double.infinity,
      child: Column(
        children: [
          Iconify(
            icon,
            size: 80,
            color: Warna.biruKehijauan(1),
          ),
          Text(
            text,
            style: Font.judulH1(Warna.biruKehijauan(1)),
          )
        ],
      ),
    );
  }
}

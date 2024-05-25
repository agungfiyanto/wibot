import 'package:flutter/material.dart';

class Font {
  static TextStyle judulH1(Color warna) {
    return TextStyle(fontFamily: "Bebas", fontSize: 30, color: warna);
  }

  static TextStyle keterangan(Color warna) {
    return TextStyle(fontFamily: "FiraSans", fontSize: 15, color: warna);
  }

  static TextStyle judulH2(Color warna) {
    return TextStyle(
        fontFamily: "FiraSans",
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: warna);
  }
}

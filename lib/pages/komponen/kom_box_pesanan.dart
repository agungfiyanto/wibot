import 'package:flutter/material.dart';

class KomBoxPesanan {
  static Widget box(Widget widget, [int? margin]) {
    return Container(
      margin: margin != null
          ? EdgeInsets.symmetric(horizontal: 10)
          : EdgeInsets.zero,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(55, 0, 0, 0),
            blurRadius: 5,
            offset: Offset(2, 2),
            spreadRadius: -2,
          )
        ],
      ),
      child: widget,
    );
  }
}

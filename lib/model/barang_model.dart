class BarangModel {
  int? id, hargaBarang, stokBarang;
  String? namaBarang;

  BarangModel({this.id, this.hargaBarang, this.namaBarang, this.stokBarang});

  factory BarangModel.fromJson(Map<String, dynamic> json) {
    return BarangModel(
        id: json['id'],
        namaBarang: json['nama_barang'],
        hargaBarang: json['harga_barang'],
        stokBarang: json['stok_barang']);
  }

  @override
  String toString() {
    return '{"id": "$id", "hargaBarang": "$hargaBarang", "stokBarang": "$stokBarang", "namaBarang": "$namaBarang"}';
  }
}

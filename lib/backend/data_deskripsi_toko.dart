class DataDeskripsiToko {
  static String? _namaToko, _deskripsiToko, _waktuBuka, _waktuTutup;

  setNamaToko([String? isiNamaToko]) {
    if (isiNamaToko != null) _namaToko = isiNamaToko;
  }

  setDeskripsiToko([String? isiDeskripsiToko]) {
    if (isiDeskripsiToko != null) _deskripsiToko = isiDeskripsiToko;
  }

  setWaktu({String? waktuBuka = "11:00", String? waktuTutup = "12:00"}) {
    if (waktuBuka != null) _waktuBuka = waktuBuka;
    if (waktuTutup != null) _waktuTutup = waktuTutup;
  }

  getNamaToko() {
    return _namaToko;
  }

  getDeskripsiToko() {
    return _deskripsiToko;
  }

  getWaktuBuka() {
    if (_waktuBuka != null) return _waktuBuka;
  }

  getWaktuTutup() {
    if (_waktuTutup != null) return _waktuTutup;
  }
}

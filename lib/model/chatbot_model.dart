class ChatbotModel {
  int? id, kesesuaian;
  String? kataKunci, balasan;

  ChatbotModel({this.id, this.kataKunci, this.balasan, this.kesesuaian});

  factory ChatbotModel.fromJson(Map<String, dynamic> json) {
    return ChatbotModel(
        id: json['id'],
        kataKunci: json['kata_kunci'],
        balasan: json['balasan'],
        kesesuaian: json['kesesuaian']);
  }

  @override
  String toString() {
    return '{"id": "$id", "kataKunci": "$kataKunci", "balasan": "$balasan", "kesesuaian": "$kesesuaian"}';
  }
}

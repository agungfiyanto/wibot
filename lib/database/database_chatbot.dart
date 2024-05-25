import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/chatbot_model.dart';

class DatabaseChatbot {
  final String _databaseName = "chatbot_bisnis";
  final int _databaseVersion = 1;

  final namaTabel = "barang";
  final String id = "id";
  final String namaBarang = "nama_barang";
  final String stokBarang = "stok_barang";
  final String hargaBarang = "harga_barang";

  final namaTabel2 = "chatbot";
  final String idChatbot = "id";
  final String kataKunci = "kata_kunci";
  final String balasan = "balasan";
  final String kesesuaian = "kesesuaian";

  Database? _database;
  Future<Database> cekDatabase() async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    String path = join(databasePath, _databaseName);
    return openDatabase(path,
        version: _databaseVersion, onCreate: _onCreateDatabase);
  }

  Future _onCreateDatabase(Database path, int version) async {
    await path.execute(
        'CREATE TABLE $namaTabel ($id INTEGER PRIMARY KEY, $namaBarang TEXT NULL, $stokBarang INTEGER NULL, $hargaBarang INTEGER NULL)');
    await path.execute(
        'CREATE TABLE $namaTabel2 ($idChatbot INTEGER PRIMARY KEY, $kataKunci TEXT NULL, $balasan TEXT NULL, $kesesuaian INTEGER NULL)');
  }

  Future<List<ChatbotModel>> allChatbot() async {
    final data = await _database!.query("chatbot");
    List<ChatbotModel> hasil =
        data.map((e) => ChatbotModel.fromJson(e)).toList();
    return hasil;
  }

  Future<int> insertChatbot(Map<String, dynamic> row) async {
    final query = await _database!.insert("chatbot", row);
    return query;
  }

  Future<int> updateChatbot(int id, Map<String, dynamic> row) async {
    final query = await _database!
        .update("chatbot", row, where: '${this.id} = ?', whereArgs: [id]);
    return query;
  }

  Future<int> deleteChatbot(int id) async {
    final query = await _database!
        .delete("chatbot", where: '${this.id} = ?', whereArgs: [id]);
    return query;
  }
}

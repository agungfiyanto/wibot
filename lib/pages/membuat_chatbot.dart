import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:wibot/database/database_chatbot.dart';
import 'package:wibot/model/chatbot_model.dart';
import 'package:wibot/pages/komponen/kom_background.dart';
import 'package:wibot/style_umum/font.dart';
import 'package:wibot/style_umum/icon.dart';
import 'package:wibot/style_umum/warna.dart';

class MembuatChatbot extends StatefulWidget {
  const MembuatChatbot({super.key});

  @override
  State<MembuatChatbot> createState() => _MembuatChatbotState();
}

class _MembuatChatbotState extends State<MembuatChatbot> {
  DatabaseChatbot databaseChatbot = DatabaseChatbot();

  @override
  void initState() {
    databaseChatbot.cekDatabase();
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
          children: [KomBackground.background(IconCustom.editMessage, 'MEMBUAT CHATBOT', context), const Foreground()],
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
  InputData inputData = InputData();
  DatabaseChatbot? databaseChatbot;

  Future initDatabase() async {
    await databaseChatbot!.cekDatabase();
    setState(() {});
  }

  @override
  void initState() {
    databaseChatbot = DatabaseChatbot();
    initDatabase();
    super.initState();
  }

  Future delete(int id) async {
    await databaseChatbot!.deleteChatbot(id);
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

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 5),
                          child: Text(
                            'Kata Kunci',
                            style: Font.judulH2(Warna.biruKehijauan(1)),
                          ),
                        ),
                        TextFormField(
                          controller: inputData.inputKataKunci,
                          style: TextStyle(fontSize: 17, height: 1.2),
                          decoration: InputDecoration(
                              isDense: true,
                              hintText: "Contoh : Hallo, apakah stoknya masih ada",
                              hintStyle: TextStyle(color: Colors.black26, fontSize: 12),
                              contentPadding: EdgeInsets.only(bottom: 20, right: 10, left: 10),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1.5, color: Warna.biruKehijauan(1)),
                                  borderRadius: BorderRadius.circular(5)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1.5, color: Colors.blue),
                                  borderRadius: BorderRadius.circular(5))),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 5),
                          child: Text(
                            'Pesan Balasan',
                            style: Font.judulH2(Warna.biruKehijauan(1)),
                          ),
                        ),
                        TextFormField(
                          controller: inputData.inputBalasan,
                          style: TextStyle(fontSize: 17, height: 1.2),
                          decoration: InputDecoration(
                              isDense: true,
                              hintText: "Contoh : Masih ada kak, silahkan di order",
                              hintStyle: TextStyle(color: Colors.black26, fontSize: 12),
                              contentPadding: EdgeInsets.only(bottom: 20, right: 10, left: 10),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1.5, color: Warna.biruKehijauan(1)),
                                  borderRadius: BorderRadius.circular(5)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1.5, color: Colors.blue),
                                  borderRadius: BorderRadius.circular(5))),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 5),
                          child: Text(
                            'Kesesuaian',
                            style: Font.judulH2(Warna.biruKehijauan(1)),
                          ),
                        ),
                        RadioListTile(
                          dense: true,
                          visualDensity: VisualDensity(horizontal: 0, vertical: -3),
                          contentPadding: EdgeInsets.zero,
                          title: Text('Harus sama persis dengan kata kunci',
                              style: Font.keterangan(Warna.biruKehijauan(1))),
                          value: 1,
                          groupValue: inputData.valueKesesuain,
                          onChanged: (int? value) {
                            setState(() {
                              inputData.valueKesesuain = value;
                            });
                          },
                        ),
                        RadioListTile(
                          dense: true,
                          visualDensity: VisualDensity(horizontal: 0, vertical: -3),
                          contentPadding: EdgeInsets.zero,
                          title: Text('Mengandung kata kunci', style: Font.keterangan(Warna.biruKehijauan(1))),
                          value: 0,
                          groupValue: inputData.valueKesesuain,
                          onChanged: (int? value) {
                            setState(() {
                              inputData.valueKesesuain = value;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                          ElevatedButton(
                            onPressed: () async {
                              if (inputData.inputKataKunci.text != "" && inputData.inputBalasan.text != "") {
                                await databaseChatbot!.insertChatbot({
                                  'kata_kunci': inputData.inputKataKunci.text,
                                  'balasan': inputData.inputBalasan.text,
                                  'kesesuaian': inputData.valueKesesuain
                                });
                                setState(() {});
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) => AlertDialog(
                                          title: const Text("Peringatan"),
                                          content:
                                              const Text("Pastikan kata kunci dan balasan di isi, tidak boleh kosong"),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ));
                              }
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Warna.biruKehijauan(1)),
                            child: Text(
                              'Buat Baru',
                              style: Font.judulH2(Warna.putih(1)),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (inputData.inputKataKunci.text != "" && inputData.inputBalasan.text != "") {
                                if (inputData.id != null && inputData.id != 0) {
                                  await databaseChatbot!.updateChatbot(inputData.id, {
                                    'kata_kunci': inputData.inputKataKunci.text,
                                    'balasan': inputData.inputBalasan.text,
                                    'kesesuaian': inputData.valueKesesuain
                                  });
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) => AlertDialog(
                                            title: const Text("Perhatian"),
                                            content: const Text("Anda harus buat baru"),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          ));
                                }
                                setState(() {});
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) => AlertDialog(
                                          title: const Text("Peringatan"),
                                          content:
                                              const Text("Pastikan kata kunci dan balasan di isi, tidak boleh kosong"),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ));
                              }
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Warna.mint(1)),
                            child: Text(
                              'Simpan',
                              style: Font.judulH2(Warna.biruKehijauan(1)),
                            ),
                          ),
                        ]),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Daftar Chatbot yang Dibuat',
                          style: Font.judulH2(Warna.biruKehijauan(1)),
                        ),
                        databaseChatbot != null
                            ? FutureBuilder<List<ChatbotModel>>(
                                future: databaseChatbot!.allChatbot(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data!.length == 0) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: Center(
                                          child: Text(
                                            'Belum ada pesanan',
                                            style: Font.judulH2(Warna.merah(1)),
                                          ),
                                        ),
                                      );
                                    }
                                    return GridView.builder(
                                        physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: snapshot.data!.length,
                                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 1,
                                          childAspectRatio: 7,
                                          mainAxisSpacing: 10,
                                        ),
                                        itemBuilder: (context, index) {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            decoration: BoxDecoration(
                                                color: Warna.mint(1), borderRadius: BorderRadius.circular(5)),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text("${snapshot.data![index].kataKunci}"),
                                                Row(
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {
                                                          showDialog(
                                                              context: context,
                                                              builder: (BuildContext context) => AlertDialog(
                                                                    title: const Text("Peringatan"),
                                                                    content: const Text(
                                                                        "Apakah anda yakin untuk melakukan hapus ?"),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed: () {
                                                                          databaseChatbot!.deleteChatbot(int.parse(
                                                                              snapshot.data![index].id.toString()));
                                                                          setState(() {});
                                                                          Navigator.pop(context);
                                                                        },
                                                                        child: const Text('Iya'),
                                                                      ),
                                                                    ],
                                                                  ));
                                                        },
                                                        icon: Iconify(
                                                          IconCustom.delete,
                                                          color: Warna.merah(1),
                                                          size: 18,
                                                        )),
                                                    IconButton(
                                                        onPressed: () {
                                                          inputData.updateInpuData(
                                                              int.parse(snapshot.data![index].id.toString()),
                                                              int.parse(snapshot.data![index].kesesuaian.toString()),
                                                              snapshot.data![index].kataKunci.toString(),
                                                              snapshot.data![index].balasan.toString());
                                                          setState(() {});
                                                        },
                                                        icon: Iconify(
                                                          IconCustom.pencil,
                                                          color: Warna.biruKehijauan(1),
                                                          size: 18,
                                                        ))
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                  } else {
                                    return const Center(
                                      child: Text('Terdapat kesalahan kode'),
                                    );
                                  }
                                },
                              )
                            : Center(
                                child: CircularProgressIndicator(color: Warna.biruKehijauan(1)),
                              )
                      ],
                    ),
                  ))
            ],
          )),
    );
  }
}

class InputData {
  int id = 0;
  int? valueKesesuain = 1;
  final TextEditingController inputKataKunci = TextEditingController();
  final TextEditingController inputBalasan = TextEditingController();

  void updateInpuData(int id, int value, String kataKunci, String balasan) {
    this.id = id;
    valueKesesuain = value;
    inputKataKunci.text = kataKunci;
    inputBalasan.text = balasan;
  }
}

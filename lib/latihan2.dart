import 'package:flutter/material.dart'; // Mengimpor library Flutter untuk membuat UI
import 'package:http/http.dart' as http; // Mengimpor library http untuk melakukan HTTP requests
import 'dart:convert'; // Mengimpor library untuk mengonversi JSON

void main() {
  runApp(const MyApp()); // Memulai aplikasi Flutter
}

// Kelas untuk menampung data hasil pemanggilan API
class Activity {
  String aktivitas; // Attribut untuk menampung aktivitas
  String jenis; // Attribut untuk menampung jenis aktivitas

  // Konstruktor untuk kelas Activity
  Activity({required this.aktivitas, required this.jenis});

  // Factory method untuk mengonversi JSON menjadi objek Activity
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      aktivitas: json['activity'], // Mendapatkan nilai aktivitas dari JSON
      jenis: json['type'], // Mendapatkan nilai jenis dari JSON
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyAppState(); // Membuat state MyApp
  }
}

class MyAppState extends State<MyApp> {
  late Future<Activity> futureActivity; // Variabel untuk menampung hasil pemanggilan API
  String url = "https://www.boredapi.com/api/activity"; // URL untuk pemanggilan API

  // Metode untuk menginisialisasi objek Activity
  Future<Activity> init() async {
    return Activity(aktivitas: "", jenis: ""); // Mengembalikan objek Activity kosong
  }

  // Metode untuk mengambil data dari API
  Future<Activity> fetchData() async {
    final response = await http.get(Uri.parse(url)); // Mengirim request HTTP ke API

    if (response.statusCode == 200) {
      // Jika respons dari server adalah 200 OK,
      // parse JSON dan kembalikan objek Activity
      return Activity.fromJson(jsonDecode(response.body));
    } else {
      // Jika gagal, lempar exception
      throw Exception('Gagal load');
    }
  }

  @override
  void initState() {
    super.initState();
    futureActivity = init(); // Menginisialisasi futureActivity
  }

  @override
  Widget build(Object context) {
    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  futureActivity = fetchData(); // Memanggil metode fetchData saat tombol ditekan
                });
              },
              child: Text("Saya bosan ..."), // Teks pada tombol
            ),
          ),
          FutureBuilder<Activity>(
            future: futureActivity, // Menggunakan futureActivity sebagai sumber data
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Jika data tersedia, tampilkan aktivitas dan jenis
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text(snapshot.data!.aktivitas), // Tampilkan aktivitas
                      Text("Jenis: ${snapshot.data!.jenis}") // Tampilkan jenis aktivitas
                    ]));
              } else if (snapshot.hasError) {
                // Jika terjadi error, tampilkan pesan error
                return Text('${snapshot.error}');
              }
              // Tampilkan loading spinner sebagai default
              return const CircularProgressIndicator();
            },
          ),
        ]),
      ),
    ));
  }
}

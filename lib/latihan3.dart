import 'dart:convert'; // Mengimpor library untuk mengonversi JSON
import 'package:flutter/material.dart'; // Mengimpor library Flutter untuk membuat UI
import 'package:http/http.dart' as http; // Mengimpor library http untuk melakukan HTTP requests

void main() {
  runApp(MyApp()); // Memulai aplikasi Flutter
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Universitas Indonesia',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Menentukan warna tema
      ),
      home: UniversitasList(), // Menetapkan UniversitasList sebagai home screen
    );
  }
}

class UniversitasList extends StatefulWidget {
  @override
  _UniversitasListState createState() => _UniversitasListState(); // Membuat state UniversitasList
}

class _UniversitasListState extends State<UniversitasList> {
  List<dynamic> universitas = []; // Menampung data universitas

  @override
  void initState() {
    super.initState();
    fetchData(); // Memanggil metode untuk mengambil data universitas dari API
  }

  // Metode untuk mengambil data dari API
  Future<void> fetchData() async {
    final response = await http.get(
        Uri.parse('http://universities.hipolabs.com/search?country=Indonesia'));

    if (response.statusCode == 200) {
      // Jika respons dari server adalah 200 OK,
      // parse JSON dan simpan dalam variabel universitas
      setState(() {
        universitas = json.decode(response.body);
      });
    } else {
      // Jika gagal, lempar exception
      throw Exception('Failed to load universities');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Universitas Indonesia'), // Menampilkan judul aplikasi
      ),
      body: universitas.isEmpty
          ? Center(child: CircularProgressIndicator()) // Menampilkan loading spinner jika data kosong
          : ListView.builder(
              itemCount: universitas.length,
              itemBuilder: (BuildContext context, int index) {
                // Membuat item dalam ListView
                return ListTile(
                  title: Text(universitas[index]['name']), // Menampilkan nama universitas
                  subtitle: Text(universitas[index]['web_pages'][0]), // Menampilkan situs web universitas
                );
              },
            ),
    );
  }
}

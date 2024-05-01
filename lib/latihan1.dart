// Main function untuk menjalankan program
import 'dart:convert';

void main() {
  // Data transkrip mahasiswa dalam bentuk JSON
  String transkripJson = '''
  {
    "nama": "Adam Idhofi R",
    "npm": "22082010026",
    "transkrip": [
      {
        "kode": "IF101",
        "nama": "Pemrograman Dasar",
        "sks": 3,
        "nilai": "A"
      },
      {
        "kode": "IF102",
        "nama": "Pemograman Mobile",
        "sks": 4,
        "nilai": "A"
      },
      {
        "kode": "IF103",
        "nama": "Pemrograman Web",
        "sks": 3,
        "nilai": "A"
      },
      {
        "kode": "IF104",
        "nama": "Basis Data",
        "sks": 3,
        "nilai": "A"
      }
    ]
  }
  ''';

  // Konversi JSON menjadi objek Dart
  Map<String, dynamic> dataMahasiswa = json.decode(transkripJson);

  // Dapatkan nama, NPM, dan transkrip nilai dari data mahasiswa
  String nama = dataMahasiswa['nama'];
  String npm = dataMahasiswa['npm'];
  List<dynamic> transkrip = dataMahasiswa['transkrip'];

  // Hitung IPK
  double ipk = hitungIPK(transkrip);
  
  // Tampilkan informasi
  print('Nama: $nama'); // Menampilkan nama mahasiswa
  print('NPM: $npm'); // Menampilkan NPM mahasiswa
  print('Transkrip Nilai:'); // Menampilkan transkrip nilai
  for (var matkul in transkrip) {
    print('  - ${matkul['nama']} (${matkul['kode']}): ${matkul['nilai']}');
  }
  print('IPK: ${ipk.toStringAsFixed(2)}'); // Menampilkan IPK dengan dua angka di belakang koma
}

// Fungsi untuk menghitung bobot nilai berdasarkan skala yang diberikan
double hitungBobotNilai(String nilai) {
  switch (nilai) {
    case 'A':
      return 4.0;
    case 'A-':
      return 3.75;
    case 'B+':
      return 3.5;
    case 'B':
      return 3.0;
    case 'B-':
      return 2.75;
    case 'C+':
      return 2.5;
    case 'C':
      return 2.0;
    case 'D':
      return 1.0;
    default:
      return 0.0;
  }
}

// Fungsi untuk menghitung IPK berdasarkan data transkrip nilai
double hitungIPK(List<dynamic> transkrip) {
  double totalSKS = 0;
  double totalBobot = 0;

  for (var matkul in transkrip) {
    int sks = matkul['sks'];
    String nilai = matkul['nilai'];
    double bobot = hitungBobotNilai(nilai);

    totalSKS += sks;
    totalBobot += sks * bobot;
  }

  return totalSKS == 0 ? 0 : totalBobot / totalSKS; // Mengembalikan nilai IPK
}

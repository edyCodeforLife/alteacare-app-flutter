const List<Map<String, dynamic>> docs = [
  {
    "id": 537,
    "file_id": "60e4192d79359f00124e9802",
    "url": "https://cms-bucket-alteacare.s3.ap-southeast-1.amazonaws.com/Screen_Shot_2021_07_06_at_15_45_53_38bab54c68.png",
    "original_name": "Screen Shot 2021-07-06 at 15.45.53.png",
    "size": "37.25 KB",
    "date_raw": "2021-07-23T02:53:16.612Z",
    "date": "Jumat, 23 Juli 2021 pukul 09.53",
    "upload_by_user": 0
  },
  {
    "id": 537,
    "file_id": "60e4192d79359f00124e9802",
    "url": "https://cms-bucket-alteacare.s3.ap-southeast-1.amazonaws.com/Screen_Shot_2021_07_06_at_15_45_53_38bab54c68.png",
    "original_name": "Screen Shot 2021-07-06 at 15.45.53.png",
    "size": "37.25 KB",
    "date_raw": "2021-07-23T02:53:16.612Z",
    "date": "Jumat, 23 Juli 2021 pukul 09.53",
    "upload_by_user": 1
  },
  {
    "id": 537,
    "file_id": "60e4192d79359f00124e9802",
    "url": "https://cms-bucket-alteacare.s3.ap-southeast-1.amazonaws.com/Screen_Shot_2021_07_06_at_15_45_53_38bab54c68.png",
    "original_name": "Screen Shot 2021-07-06 at 15.45.53.png",
    "size": "37.25 KB",
    "date_raw": "2021-07-23T02:53:16.612Z",
    "date": "Jumat, 23 Juli 2021 pukul 09.53",
    "upload_by_user": 0
  },
  {
    "id": 537,
    "file_id": "60e4192d79359f00124e9802",
    "url": "https://cms-bucket-alteacare.s3.ap-southeast-1.amazonaws.com/Screen_Shot_2021_07_06_at_15_45_53_38bab54c68.png",
    "original_name": "Screen Shot 2021-07-06 at 15.45.53.png",
    "size": "37.25 KB",
    "date_raw": "2021-07-23T02:53:16.612Z",
    "date": "Jumat, 23 Juli 2021 pukul 09.53",
    "upload_by_user": 1
  },
  {
    "id": 537,
    "file_id": "60e4192d79359f00124e9802",
    "url": "https://cms-bucket-alteacare.s3.ap-southeast-1.amazonaws.com/Screen_Shot_2021_07_06_at_15_45_53_38bab54c68.png",
    "original_name": "Screen Shot 2021-07-06 at 15.45.53.png",
    "size": "37.25 KB",
    "date_raw": "2021-07-23T02:53:16.612Z",
    "date": "Jumat, 23 Juli 2021 pukul 09.53",
    "upload_by_user": 0
  }
];

Map<String, dynamic> memoAltea = {
  "symptom_note": "mual, pusing, gatel",
  "diagnosis": "note",
  "drug_resume": [
    "Analsik 500gr",
    "Omeprazole",
    "Sucrafalt",
    "Becom",
  ],
  "doctor_note": [
    "Makan enak",
    "Tidur lelap",
    "Cuci kaki cuci tangan sebelum tidur",
  ],
  "memo": memos.toList(),
  "additional_resume": "Jika Anda melihat ini, berarti data note kosong, ini merupakan data mockup ",
};

const List<Map<String, dynamic>> memos = [
  {
    "title": "Keluhan",
    "summary":
        "Sakit kepala kiri sejak 3 hari, berdenyut disertai muntah sejak 1 hari ini. Sakit kepala dirasakan memberat saat beraktivitas, berkurang saat istirahat. Tidak ada trauma kepala. Tidak ada kelemahan anggota gerak, nyeri ulu hati sejak 2 hari, riwayat terlambat makan, badan lemas."
  },
  {"title": "Diagnosis", "summary": "Migrain, Dispepsia"},
  {
    "title": "Resep Obat",
    "summary": '''- Analsik 500mg, 15 tablet 3x1 tablet setelah makan
   (bila sakit kepala). 
- Omeprazole 20mg, 10 tablet 2x1 tablet sebelum
   makan. 
- Sucralfat Susp, 100ml, 4x1 sendok makan sebelum
   makan.
- Becom-c, 10 tablet, 1x1 tablet setelah makan (pagi)'''
  },
  {
    "title": "Rekomendasi Dokter",
    "summary": '''- Pola makan secara teratur
- Hindari makanan pedas, minum kopi, soda, alcohol
- Istirahata teratur'''
  },
  {
    "title": "Catatan Lain",
    "summary": '''- Bila sakit kepala tidak berkurang / bertambah berat 
   lakukan CT Scan di Mitra Keluarga kelapa gading 23 
   Desember 2020
- Bila Nyeri ulu hati tidak berkurang disarankan untuk 
   melakukan endoscopy di mitra keluarga
   kelapa gading tanggal 4 Januari 2021 '''
  },
];

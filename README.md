# altea

Project WebRTC dari Sprout menggunakan firebase. Untuk menyambungkannya dengan app harus dilakukan setup firebase dulu. 

## Set Environment

#### API URL

![settings.dart](res/ss_settings.png?raw=true "settings.dart")
Di file lib/app/core/utils/settings.dart, pilih env mana yang ingin digunakan. Uncomment satu environment saja

#### (WEB) Index.html
![index.html](res/ss_index.png?raw=true "index.html")
Di file web/index.html, pilih salah satu configurasi firebase yang sesuai dengan environment

#### (ANDROID) google-services.json 
![google-services-json](res/ss_googleservices.png?raw=true "google-services-json")
Di /android/app/src/ , pilih / rename environment yang sesuai menjadi google-services.json

#### main.dart
![main.dart](res/ss_main.png?raw=true "main.dart")
Di main.dart, jika ingin build ke web, pakai runApp() yang tidak di-wrap dengan runZoneGuarded, karena di
web tidak ada crashlytics. 




## Setup Project Firebase

Buat project firebase baru, sesuaikan nama project, region dengan yang diperlukan

## Setup Firestore

1. Pada panel Firestore Database, klik "Create Database" untuk menginisiasi database firestore baru
2. Sesuaikan firestore rules dengan yang diperlukan
3. Firestore siap digunakan dari aplikasi

## Tambah Aplikasi

1. Pada halaman utama Firebase(Project Overview), di bagian atas di bawah nama project ada tombol untuk menambah aplikasi, pilih Android untuk menambah aplikasi Android, begitu juga untuk IOS dan Web
    
    ![image(2).png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/784a4a4f-f4ee-415f-8533-dcbba9e5b360/image(2).png)
    
2. Ikuti langkah yang diperlukan untuk tiap platform
3. Download google-service.json untuk Android, dan google-service.plist untuk ios, dan tempatkan di directory sesuai platform-nya
4. Taruh google-services.json di dir : /android/app/ 

![untuk Android](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/b2eb8023-c0dc-44f0-8e3f-2ecfddcc8406/Screen_Shot_2021-12-03_at_10.04.24.png)

untuk Android

1. Taruh GoogleService-Info.plist di /ios/Runner/ 

![untuk IOS](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/aa4e8af7-0768-4a82-aed1-2c8970991c45/Screen_Shot_2021-12-03_at_10.04.37.png)

untuk IOS

1. tambahkan firebase config sesuai yang tertera di bagian platform Web. Taruh config tersebut di /web/index.html 

![Lokasi index.html ](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/819bfcbc-84e9-49bb-b776-649d05daad94/Screen_Shot_2021-12-03_at_10.17.05.png)

Lokasi index.html 

![isi config-nya](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/8267b42d-d8ed-4d7f-a33f-801197d85cd8/Screen_Shot_2021-12-03_at_10.15.14.png)

isi config-nya

1. Jika terjadi error saat build / debug, silakan cek di dokumentasi resmi firebase flutter : [https://firebase.flutter.dev/docs/installation/web/](https://firebase.flutter.dev/docs/installation/web/)

# Flutter

## Instalasi

Silakan lihat dokumentasi resmi : [https://docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install)

## Package firebase

**firebase_core: ^1.3.0 :** [https://firebase.flutter.dev/docs/overview](https://firebase.flutter.dev/docs/overview)
**cloud_firestore: ^2.4.0  :** [https://firebase.flutter.dev/docs/firestore/usage/](https://firebase.flutter.dev/docs/firestore/usage/)
**firebase_storage: ^10.0.3 :** [https://firebase.flutter.dev/docs/storage/overview](https://firebase.flutter.dev/docs/storage/overview)

## Key(s) untuk build

### Android

Untuk Android, perlu [key.properties](http://key.properties) dan key.jks untuk men-sign aplikasinya. Silakan mengikuti dokumentasi dari ini : 
[https://docs.flutter.dev/deployment/android#signing-the-app](https://docs.flutter.dev/deployment/android#signing-the-app)

### IOS

Untuk IOS, perlu signing certificate dari apple dev team. Silakan mengikuti dokumentasi dari ini : [https://docs.flutter.dev/deployment/ios](https://docs.flutter.dev/deployment/ios)
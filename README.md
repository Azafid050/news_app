Jadi disini saya membuat news app dengan menggunakan framework flutter berbahasa dart, disini saya pertama-tama membuat. projectnya terlebih dahulu
mendownload sdk dart, flutter, android sdk(untuk running android) dan cli.
1. pertama saya buat splashview untuk tampilan opening ketika membuka app dengan menggunakan SingleTickerProviderStateMixin dan animation.
2. Mengatur homeview untuk tampilan banyak beritanya.
3. Membuat constant di utils untuk membaca ada category apa aja dan category_chip untuk logika fungsi category ketika di klik dia active
4. Terus membuat model, news article untuk mengubah data yang dari api berbentuk json ke dart dan news response untuk membaca article atau news yang masuk.
5. Membuat news_service untuk mengambil data api kemudian diterukan ke models.
6. Membuat news_controller untuk membuat logika fungsi pada article seperti berita terbaru dan sebagainya kemudian diteruskan ke homeview.
7. Membuat binding sebagai penghubung controller dan View untuk memisahkan fungsi dengan ui.
8. Membuat app_pages dan app_route untuk jalur pengarahan tampilan.
9. Membuat newsdetailview (detail berita).
10. Membuat Webview (semua isi berita).
11. app_color (warna yang sudah didefault).
12. widgets loading shimmer (tampilan loading).
13. Widgets newscard (untuk tampilan news di homeview)
14. Default main dart kita tambahkan env dan route dan binding.

dependencies:
  flutter:
    sdk: flutter
  flutter_dotenv: ^6.0.0
  url_launcher: ^6.3.2
  http: ^1.6.0
  cached_network_image: ^3.4.1
  timeago: ^3.7.1
  share_plus: ^12.0.1
  webview_flutter: ^4.13.1

  cupertino_icons: ^1.0.8
  get: ^4.7.3

  uses-material-design: true

  assets:
    - .env

  ini dependencies yang digunakan dalam news_app ini.



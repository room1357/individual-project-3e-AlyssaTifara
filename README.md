# 🛒 Pemrograman Mobile – Checkout App

Aplikasi **Checkout App** ini dibuat sebagai proyek tugas mata kuliah **Pemrograman Mobile**.

---

## 👩‍🎓 Identitas Mahasiswa
**Nama:** Alyssa Tifara Yuwono  
**NIM:** 2341760164  
**Kelas:** SIB-3E  

---

## 📖 Deskripsi Project

**Checkout App** merupakan aplikasi mobile berbasis **Flutter** yang dirancang untuk membantu pengguna dalam **mengelola data item barang berdasarkan kategori** serta **mengatur proses checkout secara efisien**.  
Aplikasi ini memiliki fitur manajemen barang, pengelompokan kategori, ekspor data ke format **CSV dan PDF**, serta tampilan **statistik pengeluaran per kategori** untuk memudahkan analisis data secara visual.  

Selain itu, sistem juga mendukung **pengelolaan pengguna (User Management)** yang memungkinkan login, registrasi, serta penyimpanan data profil secara lokal.  
Aplikasi ini sangat cocok sebagai latihan untuk memahami konsep-konsep Flutter seperti:  
- **State Management**  
- **CRUD (Create, Read, Update, Delete)**  
- **Navigasi antarhalaman**  
- **Penyimpanan lokal (Shared Preferences / Local Storage)**  
- **Export file (CSV & PDF)**  

---

## ✨ Fitur Aplikasi

| Fitur / Screen | Screenshot | Penjelasan |
|----------------|-----------|-------------|
| **Login Screen** | Login | Halaman login untuk pengguna masuk ke aplikasi. Validasi email & password, diarahkan ke HomeScreen jika berhasil. |
| **Register Screen** | Register | Halaman pembuatan akun baru. Data disimpan melalui `UserManager.addUser`. |
| **Home Screen** | Home | Halaman utama setelah login, pusat navigasi ke semua fitur, termasuk Drawer profil & logout. |
| **Item Screen** | Item | Menampilkan daftar item barang. Bisa menambah, mengedit, atau menghapus item. |
| **Add Item Screen** | Add Item | Menambahkan item baru dengan nama, kategori, harga, dan tanggal. |
| **Edit Item Screen** | Edit Item | Mengubah data item yang sudah ada. Konfirmasi sebelum menyimpan perubahan. |
| **Category Screen** | Category | Mengelola kategori item. Bisa tambah atau hapus kategori dengan konfirmasi. |
| **Statistics Screen** | Statistics | Menampilkan grafik & ringkasan total pengeluaran per kategori. |
| **Export Screen** | Export | Mengekspor data item ke **CSV** atau **PDF**, bisa keseluruhan atau per kategori. |
| **User Profile Screen** | Profile | Menampilkan & mengedit data profil pengguna, disimpan menggunakan SharedPreferences. |

---

## ⚙️ Teknologi yang Digunakan

- **Framework:** Flutter (Dart)  
- **State Management:** setState & Provider  
- **Database Lokal:** Shared Preferences / Local Storage  
- **Library Pendukung:**  
  - `csv` – ekspor file CSV  
  - `pdf` – ekspor file PDF  
  - `charts_flutter` – menampilkan grafik statistik  
  - `path_provider` – penyimpanan file lokal  

---

## 🧩 Tujuan Pembelajaran

Proyek ini dikembangkan untuk memperdalam pemahaman tentang:  
- Implementasi konsep **Mobile App Lifecycle** di Flutter  
- Pengelolaan data dengan **CRUD dan kategori**  
- Integrasi fitur **export data ke file eksternal (CSV & PDF)**  
- Pemanfaatan **widget interaktif** seperti Drawer, ListView, dan DatePicker  
- Pemrosesan data keuangan dan visualisasi grafik sederhana  

---

## 💡 Kesimpulan

Checkout App membantu pengguna dalam **mengatur dan memantau data item barang** berdasarkan kategori, serta **mempermudah proses dokumentasi** dengan ekspor data ke PDF dan CSV.  
Aplikasi ini tidak hanya berfungsi sebagai alat bantu keuangan sederhana, tetapi juga sebagai sarana pembelajaran yang efektif untuk memahami penerapan **Flutter dalam pengembangan aplikasi mobile fungsional dan interaktif.**

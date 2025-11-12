// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Import PlaceholderView untuk fallback

class AccountAuthorView extends StatefulWidget {
  // Data dan Callback harus disediakan oleh MainWrapper
  final String authorId;
  final List<Map<String, dynamic>> comics;
  final Function(Map<String, dynamic>) onCreateComic;
  final Function(String, Map<String, dynamic>) onUpdateComic;
  final Function(String) onDeleteComic;

  const AccountAuthorView({
    super.key,
    required this.authorId,
    required this.comics,
    required this.onCreateComic,
    required this.onUpdateComic,
    required this.onDeleteComic,
  });

  @override
  State<AccountAuthorView> createState() => _AccountAuthorViewState();
}

class _AccountAuthorViewState extends State<AccountAuthorView> {
  // Form controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController coverController = TextEditingController();
  final TextEditingController genreController = TextEditingController();

  String status = 'ongoing';
  List<String> genres = [];
  Map<String, dynamic>? selectedComic;

  // State untuk menampilkan Dialog (diperlukan untuk stateful dialog)
  bool showCreateDialog = false;
  bool showEditDialog = false;
  bool showDeleteDialog = false;

  void resetForm() {
    titleController.clear();
    descriptionController.clear();
    coverController.clear();
    genreController.clear();
    setState(() {
      genres = [];
      status = 'ongoing';
      selectedComic = null; // Tambahkan reset selectedComic
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    coverController.dispose();
    genreController.dispose();
    super.dispose();
  }
  
  // --- Fungsi yang dipanggil oleh tombol dialog ---
  // Menggunakan fungsi terpisah untuk memastikan dialog muncul di atas konten utama
  void _showCreateDialog() {
    resetForm();
    showDialog(
      context: context,
      builder: (context) => _buildComicDialog(context, isEdit: false),
    );
  }

  void _showEditDialog(Map<String, dynamic> comic) {
    titleController.text = comic['title'];
    descriptionController.text = comic['description'] ?? '';
    coverController.text = comic['coverImage'] ?? '';
    setState(() {
      genres = List<String>.from(comic['genre'] ?? []);
      status = comic['status'] ?? 'ongoing';
      selectedComic = comic;
    });

    showDialog(
      context: context,
      builder: (context) => _buildComicDialog(context, isEdit: true),
    );
  }
  
  void _showDeleteDialog(Map<String, dynamic> comic) {
    setState(() {
      selectedComic = comic;
    });
    showDialog(
      context: context,
      builder: (context) => _buildDeleteDialog(context),
    );
  }


  @override
  Widget build(BuildContext context) {
    // Filter komik berdasarkan authorId
    final authorComics = widget.comics
        .where((comic) => comic['authorId'] == widget.authorId)
        .toList();

    // Hitung total views
    final totalViews = authorComics.fold<int>(
      0,
      (sum, c) => sum + (c['totalViews'] is int ? c['totalViews'] as int : 0),
    );

    // Hitung rating rata-rata
    final avgRating = authorComics.isNotEmpty
        ? (authorComics.fold<double>(
                  0.0, (sum, c) => sum + (c['rating'] ?? 0.0)) /
                authorComics.length)
              .toStringAsFixed(1)
        : '0';

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFECFDF5), Colors.white, Color(0xFFE6FFFA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Dashboard Author",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      Text(
                        "Kelola komik dan pantau performa Anda",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: _showCreateDialog, // Panggil showDialog
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text("Buat Komik Baru",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Statistik
              GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2.5),
                children: [
                  _buildStatCard("Total Komik", authorComics.length.toString(),
                      Icons.menu_book, Colors.green),
                  _buildStatCard("Total Views",
                      "${(totalViews / 1000).toStringAsFixed(totalViews >= 1000 ? 1 : 0)}k",
                      Icons.visibility, Colors.teal),
                  _buildStatCard("Rating Rata-rata", avgRating, Icons.star,
                      Colors.amber),
                  _buildStatCard("Total Pembaca", "1.2k", Icons.people,
                      Colors.purple), // Data dummy
                ],
              ),
              const SizedBox(height: 24),

              // Daftar Komik
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFFCCF0E3)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Daftar Komik Anda",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (authorComics.isEmpty)
                        Column(
                          children: [
                            const Icon(Icons.menu_book,
                                size: 60, color: Colors.teal),
                            const SizedBox(height: 8),
                            const Text("Belum ada komik"),
                            const Text("Mulai membuat komik pertama Anda"),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: _showCreateDialog,
                              icon: const Icon(Icons.add, color: Colors.white),
                              label: const Text("Buat Komik Baru",
                                  style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal),
                            ),
                          ],
                        )
                      else
                        Column(
                          children: authorComics.map((comic) {
                            return ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 8),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  comic['coverImage'] ??
                                      'https://via.placeholder.com/80',
                                  height: 80,
                                  width: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        height: 80,
                                        width: 60,
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.image_not_supported,
                                            color: Colors.grey),
                                      ),
                                ),
                              ),
                              title: Text(comic['title']),
                              subtitle: Text(
                                "Genre: ${comic['genre']?.join(', ')} • ${comic['status']}",
                                style: const TextStyle(color: Colors.grey),
                              ),
                              trailing: Wrap(
                                children: [
                                  IconButton(
                                    onPressed: () => _showEditDialog(comic),
                                    icon: const Icon(Icons.edit,
                                        color: Colors.teal),
                                  ),
                                  IconButton(
                                    onPressed: () => _showDeleteDialog(comic),
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Widget Helper (di luar build utama) ----------

  // Card Statistik
  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey)),
              Text(value,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  // Dialog Buat/Edit Komik
  Widget _buildComicDialog(BuildContext context, {required bool isEdit}) {
    // Gunakan StatefulBuilder untuk mengelola state lokal dialog (genres, status)
    return StatefulBuilder(
      builder: (context, setStateDialog) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min, 
              children: [
                Text(
                  isEdit ? "Edit Komik" : "Buat Komik Baru",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "Judul Komik",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Deskripsi",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: coverController,
                  decoration: const InputDecoration(
                    labelText: "URL Cover Image",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                // Input Genre
                TextField(
                  controller: genreController,
                  onSubmitted: (value) {
                    if (value.isNotEmpty && !genres.contains(value)) {
                      setStateDialog(() {
                        genres.add(value.trim());
                        genreController.clear();
                      });
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "Tambah Genre",
                    hintText: "Tekan Enter atau ikon '+'",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        if (genreController.text.isNotEmpty &&
                            !genres.contains(genreController.text)) {
                          setStateDialog(() {
                            genres.add(genreController.text.trim());
                            genreController.clear();
                          });
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Tampilan Chips Genre
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: genres
                      .map((g) => Chip(
                            label: Text(g),
                            onDeleted: () => setStateDialog(() => genres.remove(g)),
                            deleteIconColor: Colors.redAccent,
                          ))
                      .toList(),
                ),
                const SizedBox(height: 12),
                // Dropdown Status
                DropdownButtonFormField<String>(
                  value: status,
                  items: const [
                    DropdownMenuItem(value: 'ongoing', child: Text('Berlanjut')),
                    DropdownMenuItem(value: 'completed', child: Text('Selesai')),
                    DropdownMenuItem(value: 'hiatus', child: Text('Hiatus')),
                  ],
                  onChanged: (v) => setStateDialog(() => status = v!),
                  decoration: const InputDecoration(
                    labelText: "Status",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                // Tombol Aksi
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        // Tutup Dialog dan reset state lokal AccountAuthorView
                        Navigator.pop(context);
                        resetForm(); // FIX: Menghapus 'this.'
                      },
                      child: const Text("Batal"),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Validasi sederhana
                        if (titleController.text.isEmpty ||
                            descriptionController.text.isEmpty ||
                            coverController.text.isEmpty) {
                          Get.snackbar('Error', 'Harap isi semua kolom wajib.', 
                            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
                          return;
                        }
                        
                        // Kirim data ke parent
                        if (isEdit && selectedComic != null) {
                          widget.onUpdateComic(selectedComic!['id'], {
                            'title': titleController.text,
                            'description': descriptionController.text,
                            'coverImage': coverController.text,
                            'genre': genres,
                            'status': status,
                          });
                          Get.snackbar('Sukses', 'Komik berhasil diupdate.', 
                            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
                        } else {
                          // Buat Komik Baru
                          widget.onCreateComic({
                            'id': DateTime.now().millisecondsSinceEpoch.toString(), // ID sementara
                            'title': titleController.text,
                            'description': descriptionController.text,
                            'coverImage': coverController.text,
                            'genre': genres,
                            'status': status,
                            'authorId': widget.authorId,
                            'rating': 0.0, 
                            'totalViews': 0, 
                            'chapters': [], 
                            'createdAt': DateTime.now().toIso8601String(), 
                          });
                           Get.snackbar('Sukses', 'Komik baru berhasil dibuat.', 
                            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
                        }
                        
                        Navigator.pop(context); // Tutup dialog
                        resetForm(); // FIX: Menghapus 'this.'
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                      child: Text(isEdit ? "Simpan" : "Buat"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  // Dialog Hapus Komik
  Widget _buildDeleteDialog(BuildContext context) {
    return AlertDialog(
      title: const Text("Hapus Komik"),
      content: Text(
          'Apakah Anda yakin ingin menghapus komik "**${selectedComic?['title'] ?? ''}**"? Tindakan ini tidak dapat dibatalkan.'),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              selectedComic = null;
            });
            Navigator.pop(context);
          },
          child: const Text("Batal"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
          onPressed: () {
            if (selectedComic != null && selectedComic!['id'] is String) {
              widget.onDeleteComic(selectedComic!['id']);
              Get.snackbar('Terhapus', 'Komik berhasil dihapus.', 
                snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
              setState(() {
                selectedComic = null;
              });
            }
            Navigator.pop(context);
          },
          child: const Text("Hapus"),
        ),
      ],
    );
  }
}
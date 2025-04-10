import 'package:flutter/material.dart';

class ImageLobby extends StatefulWidget {
  const ImageLobby({super.key});

  @override
  State<ImageLobby> createState() => _ImageLobbyState();
}

class _ImageLobbyState extends State<ImageLobby> {
  bool _showAllHistory = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCard(
              title: "Lịch sử tìm kiếm",
              imagePath: "logo.png", // Icon lịch sử tìm kiếm
              child: _buildHistoryList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required String imagePath, required Widget child}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      color: Colors.white,
      shadowColor: Colors.grey.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/$imagePath',
                  width: 24,
                  height: 24,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList() {
    List<String> history = ['我们', '你们', '豪门', '你们'];
    List<String> displayHistory = _showAllHistory ? history : history.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: displayHistory.map((text) => _buildHistoryChip(text)).toList(),
        ),
        if (history.length > 3)
          Center(
            child: TextButton(
              onPressed: () {
                setState(() {
                  _showAllHistory = !_showAllHistory;
                });
              },
              child: Text(_showAllHistory ? "Ẩn bớt" : "Xem thêm"),
            ),
          ),
      ],
    );
  }

  Widget _buildHistoryChip(String text) {
    return InkWell(
      onTap: () {}, // Hành động khi nhấn vào từ
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 3,
              offset: const Offset(0, 2), // Hiệu ứng nổi nhẹ
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey[800]),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            InkWell(
              onTap: () {}, // Hành động khi xóa
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.all(3.0),
                child: Icon(Icons.close, size: 16, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class StoryLobby extends StatefulWidget {
  const StoryLobby({super.key});

  @override
  State<StoryLobby> createState() => _StoryLobbyState();
}

class _StoryLobbyState extends State<StoryLobby> {
  bool _showAllHistory = false;
  bool _showAllLevels = false; // Biến theo dõi việc hiển thị tất cả cấp độ

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
            const SizedBox(height: 10),
            _buildCard(
              title: "Gợi ý tìm kiếm",
              imagePath: "logo.png", // Icon lịch sử tìm kiếm
              child: _buildSuggestions(),
            ),
            const SizedBox(height: 10),
            _buildCard(
              title: "Hán tự theo cấp độ",
              imagePath: "logo.png", // Icon lịch sử tìm kiếm
              child: _buildVocabularyLevels(),
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
                  'assets/$imagePath', // Ảnh bên trái
                  width: 24,
                  height: 24,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 8), // Khoảng cách giữa ảnh và tiêu đề
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
    List<String> history = ['我', '你们', '豪', '大夏'];
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
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey[700]),
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

  Widget _buildSuggestions() {
    List<String> suggestions = ["你", "谢", "见", "语", "听", "文"];
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.start,
        children: suggestions.map((text) => _buildSuggestionChip(text)).toList(),
      ),
    );
  }

  Widget _buildSuggestionChip(String text) {
    return InkWell(
      onTap: () {}, // Thêm hiệu ứng khi nhấn
      borderRadius: BorderRadius.circular(20),
      child: Chip(
        label: Text(
          text,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[800]),
        ),
        backgroundColor: Colors.blueAccent.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.blueAccent.withOpacity(0.3)),
        ),
      ),
    );
  }


  Widget _buildVocabularyLevels() {
    List<Map<String, String>> levels = [
      {"level": "HSK 1", "words": "150 từ", "image": "HSK1_icon.png"},
      {"level": "HSK 2", "words": "300 từ", "image": "HSK2_icon.png"},
      {"level": "HSK 3", "words": "600 từ", "image": "HSK3_icon.png"},
      {"level": "HSK 4", "words": "1200 từ", "image": "HSK4_icon.png"},
      {"level": "HSK 5", "words": "1500 từ", "image": "HSK5_icon.png"},
      {"level": "HSK 6", "words": "1800 từ", "image": "HSK6_icon.png"},
      {"level": "HSK 7-9", "words": "3000 từ", "image": "HSK6_icon.png"},
    ];

    // Giới hạn hiển thị chỉ 3 mục đầu tiên nếu không hiển thị tất cả
    final displayLevels = _showAllLevels ? levels : levels.take(3).toList();

    return Column(
      children: [
        // Hiển thị các mục đã được lọc
        ...displayLevels.map(
                (item) => _buildVocabularyTile(item["level"]!, item["words"]!, item["image"]!)
        ).toList(),

        // Hiển thị nút "Xem thêm"/"Ẩn bớt" nếu có nhiều hơn 3 mục
        if (levels.length > 3)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Center(
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    _showAllLevels = !_showAllLevels;
                  });
                },
                icon: Icon(
                  _showAllLevels ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: 20,
                ),
                label: Text(_showAllLevels ? "Ẩn bớt" : "Xem thêm"),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                ),
              ),
            ),
          ),
      ],
    );
  }


  Widget _buildVocabularyTile(String level, String words, String imagePath) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0), // Loại bỏ padding mặc định
      leading: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0), // Sát mép trái
        child: Image.asset(
          'assets/$imagePath', // Đường dẫn ảnh
          width: 40,
          height: 40,
          fit: BoxFit.cover, // Đảm bảo ảnh hiển thị đẹp
        ),
      ),
      title: Text(
        level,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[800]),
      ),
      subtitle: Text(
        words,
        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {},
    );
  }

}
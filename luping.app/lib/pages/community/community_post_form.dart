import 'package:flutter/material.dart';

class CommunityPost extends StatefulWidget {
  @override
  _CommunityPostState createState() => _CommunityPostState();
}

class _CommunityPostState extends State<CommunityPost> {
  String selectedTag = "Tất cả"; // Tag mặc định
  final List<String> tags = ["Tất cả", "Lớp HSK 1 - Cơ bản", "Lớp Giao tiếp tiếng Trung"];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height, // Chiếm toàn bộ chiều cao
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20), // Tạo khoảng cách từ trên xuống
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "Tạo bài viết mới",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(width: 48), // Để cân bằng với IconButton
            ],
          ),
          SizedBox(height: 20), // Thêm khoảng cách dưới tiêu đề
          Text("Phạm vi:", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: selectedTag,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: tags.map((String tag) {
              return DropdownMenuItem<String>(
                value: tag,
                child: Text(tag),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedTag = newValue;
                });
              }
            },
          ),
          SizedBox(height: 15),
          TextField(
            maxLines: 5,
            decoration: InputDecoration(
              hintText: "Bạn đang suy nghĩ gì?",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 15),
          Align(
            alignment: Alignment.centerRight, // Đẩy nút sang phải
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Đăng bài"),
            ),
          ),
        ],
      ),
    );
  }
}

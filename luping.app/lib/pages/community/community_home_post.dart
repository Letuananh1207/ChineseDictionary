import 'package:flutter/material.dart';
import 'community_post_detail.dart'; // Import file CommunityPostDetail.dart

// Cập nhật hàm buildPostCard để nhận thêm sự kiện onCommentTap
Widget buildPostCard(BuildContext context, Map<String, dynamic> post, void Function() onCommentTap) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 8.0),
    elevation: 3,
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  post["avatar"] ?? "https://via.placeholder.com/150",
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post["author"] ?? "Unknown",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    post["time"] ?? "Unknown time",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(post["content"] ?? "No content"),
          const SizedBox(height: 10),
          Container(
            height: 0.5, // Chiều cao của đường kẻ
            color: Colors.grey, // Màu sắc của đường kẻ, bạn có thể thay đổi theo ý muốn
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.favorite_border, color: Colors.red.withOpacity(0.5), size: 18),
              SizedBox(width: 5),
              Text(
                'Yêu thích',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
              SizedBox(width: 5),
              Text(
                "${post["likes"] ?? 0}",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
              SizedBox(width: 15),
              GestureDetector(
                onTap: onCommentTap, // Gọi callback khi nhấn vào phần "Bình luận"
                child: Row(
                  children: [
                    Icon(Icons.chat_bubble_outline, color: Colors.blueGrey.withOpacity(0.5), size: 18),
                    SizedBox(width: 5),
                    Text(
                      'Bình luận',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      "${post["comments"] ?? 0}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

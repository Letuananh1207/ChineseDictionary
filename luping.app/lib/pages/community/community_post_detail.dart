import 'package:flutter/material.dart';

class CommunityPostDetail extends StatelessWidget {
  final Map<String, dynamic> post; // Nhận vào post dưới dạng Map

  const CommunityPostDetail({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dữ liệu giả lập các bình luận
    List<Map<String, String>> fakeComments = [
      {
        "author": "Hương Giang",
        "content": "Bài viết rất hay!",
        "avatar": "https://data.hanzii.net/files/images/Thumb_1732851036_707644.png"
      },
      {
        "author": "TiểuMộng",
        "content": "Mình đồng ý với bạn!",
        "avatar": "https://data.hanzii.net/files/images/Thumb_1742983562_813816.png"
      },
      {
        "author": "Bông Cải Xanh",
        "content": "Cảm ơn vì thông tin hữu ích!",
        "avatar": "https://graph.facebook.com/1544344309679347/picture?type=normal"
      },
    ];

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 60),
          // Người đăng và avatar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                    post['avatar'] ??
                        'https://ui-avatars.com/api/?name=User&background=random',
                  ),
                  backgroundColor: Colors.grey.shade200,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post['author'] ?? 'Chưa xác định',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Text(
                      'Thành viên',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Nội dung bài đăng
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              post['content'] ?? 'No content available.',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 0.5,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 10),
          // Hiển thị likes và comments
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.favorite_border,
                    color: Colors.red.withOpacity(0.5), size: 18),
                const SizedBox(width: 5),
                Text(
                  'Yêu thích: ${post["likes"] ?? 0}',
                  style: TextStyle(
                      fontSize: 13, color: Colors.black.withOpacity(0.6)),
                ),
                const SizedBox(width: 15),
                Icon(Icons.chat_bubble_outline,
                    color: Colors.blueGrey.withOpacity(0.5), size: 18),
                const SizedBox(width: 5),
                Text(
                  'Bình luận: ${post["comments"] ?? 0}',
                  style: TextStyle(
                      fontSize: 13, color: Colors.black.withOpacity(0.6)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 1,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(0, 2),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Hiển thị các bình luận
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: fakeComments.map((comment) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundImage:
                        NetworkImage(comment['avatar'] ?? ''),
                        backgroundColor: Colors.grey.shade300,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              comment['author'] ?? 'Người bình luận',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              comment['content'] ?? 'No content',
                              style: TextStyle(
                                fontSize: 14.5,
                                color: Colors.black.withOpacity(0.75),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

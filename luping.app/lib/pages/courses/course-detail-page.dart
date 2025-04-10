import 'package:flutter/material.dart';

class CourseDetailPage extends StatelessWidget {
  const CourseDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.white,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        actions: const [Padding(
          padding: EdgeInsets.only(right: 12),
          child: Icon(Icons.search, color: Colors.black),
        )],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Section: Banner
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 120,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[300],
                    ),
                    child: const Center(
                      child: Icon(Icons.play_circle, size: 40, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Lộ trình học tiếng Trung cho người mới',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 6),
                        Text('0%', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                ],
              ),
            ),

            // Section: Tổng quan chương trình
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Chương trình học\n16 Chương • 366 videos bài giảng • 95 tiếng 14 phút',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),

            // Section: Một chương học
            ExpansionTile(
              initiallyExpanded: true,
              title: const Text(
                'NHẬP MÔN SƠ CẤP',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
              ),
              subtitle: const Text('42 videos • 35 bài tập • 0 bài Test'),
              children: [
                // Bài học đầu tiên
                ListTile(
                  title: const Text('1. Giới thiệu khoá học & Tài liệu tải về'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLessonItem(
                        context,
                        title: 'Giới thiệu khoá học',
                        lectureCount: '2 bài giảng',
                        duration: '13p',
                        isTrial: true,
                      ),
                      _buildLessonItem(
                        context,
                        title: 'Tài liệu tải về',
                        lectureCount: '18 bài giảng',
                        duration: '18p',
                        isLocked: true,
                      ),
                    ],
                  ),
                ),
                // Bài học thứ 2
                ListTile(
                  title: const Text('2. Bảng chữ cái tiếng Nhật'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLessonItem(
                        context,
                        title: 'Bảng chữ Hiragana',
                        lectureCount: '16 bài giảng',
                        duration: '4h31p',
                        isTrial: true,
                      ),
                      _buildLessonItem(
                        context,
                        title: 'Bảng chữ Katakana',
                        lectureCount: '13 bài giảng',
                        duration: '2h13p',
                        isLocked: true,
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLessonItem(BuildContext context,
      {required String title,
        required String lectureCount,
        required String duration,
        bool isLocked = false,
        bool isTrial = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.play_circle_outline, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: isLocked ? Colors.grey : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (isTrial)
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text("Học thử", style: TextStyle(fontSize: 12)),
            ),
          if (isLocked) const Icon(Icons.lock, size: 18),
          if (!isLocked)
            Row(
              children: [
                const Icon(Icons.library_books, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(lectureCount, style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 8),
                const Icon(Icons.access_time, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(duration, style: const TextStyle(fontSize: 12)),
              ],
            ),
        ],
      ),
    );
  }
}

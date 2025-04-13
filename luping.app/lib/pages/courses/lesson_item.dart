import 'package:flutter/material.dart';

class LessonItem extends StatelessWidget {
  final String title;
  final String lectureCount;
  final String duration;
  final bool isLocked;
  final bool isTrial;
  final VoidCallback? onTap; // 👈 Thêm callback onTap

  const LessonItem({
    Key? key,
    required this.title,
    required this.lectureCount,
    required this.duration,
    this.isLocked = false,
    this.isTrial = false,
    this.onTap, // 👈 Nhận từ bên ngoài
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLocked ? null : onTap, // 👈 Chỉ cho click nếu không bị khoá
      borderRadius: BorderRadius.circular(8),
      splashColor: Colors.green.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.play_circle_outline, color: Colors.green),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isLocked ? Colors.grey : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (!isLocked) ...[
                        const Icon(Icons.access_time, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        const Text('Thời lượng :', style: TextStyle(fontSize: 12)),
                        const SizedBox(width: 4),
                        Text(duration, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                      if (isLocked) const Icon(Icons.lock, size: 16, color: Colors.grey),
                      if (isTrial)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text("Học thử", style: TextStyle(fontSize: 12)),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

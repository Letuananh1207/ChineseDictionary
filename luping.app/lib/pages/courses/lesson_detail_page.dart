import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:luping/pages/courses/custom_video_player.dart';

class LessonDetailPage extends StatefulWidget {
  final String title;

  const LessonDetailPage({Key? key, required this.title}) : super(key: key);

  @override
  State<LessonDetailPage> createState() => _LessonDetailPageState();
}

class _LessonDetailPageState extends State<LessonDetailPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F7),
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomVideoPlayer(
            videoUrl:
            'https://vd3.bdstatic.com/mda-pmmj80p4mf036br5/576p/h264/1703252101729083680/mda-pmmj80p4mf036br5.mp4',
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Thời gian học dự kiến: 8 phút',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLessonTab(),
                _buildCommentTab(),
              ],
            ),
          ),
          Card(
            elevation: 1,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.green,
                unselectedLabelColor: Colors.grey,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.transparent, // Không có màu nền khi tab được chọn
                ),
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                tabs: [
                  Tab(
                    iconMargin: const EdgeInsets.only(bottom: 2),
                    icon: const Icon(Icons.menu_book_rounded, size: 20),
                    text: 'Bài học',
                  ),
                  Tab(
                    iconMargin: const EdgeInsets.only(bottom: 2),
                    icon: const Icon(Icons.chat_bubble_outline_rounded, size: 20),
                    text: 'Bình luận',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        FractionallySizedBox(
          widthFactor: 0.8,
          alignment: Alignment.center,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset('assets/course-slide (1).png'),
          ),
        ),
        const SizedBox(height: 12),
        FractionallySizedBox(
          widthFactor: 0.8,
          alignment: Alignment.center,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset('assets/course-slide (2).png'),
          ),
        ),
        const SizedBox(height: 12),
        FractionallySizedBox(
          widthFactor: 0.8,
          alignment: Alignment.center,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset('assets/course-slide (3).png'),
          ),
        ),
      ],
    );
  }

  Widget _buildCommentTab() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: const [
              ListTile(
                leading: CircleAvatar(child: Icon(Icons.person)),
                title: Text('Nguyễn Văn A'),
                subtitle: Text('Bài giảng rất dễ hiểu, cảm ơn cô giáo!'),
              ),
              ListTile(
                leading: CircleAvatar(child: Icon(Icons.person)),
                title: Text('Trần Thị B'),
                subtitle: Text('Mình thấy phần ví dụ rất hữu ích!'),
              ),
              ListTile(
                leading: CircleAvatar(child: Icon(Icons.person)),
                title: Text('Lê Văn C'),
                subtitle: Text('Có phần nào khó hiểu không mn?'),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Nhập bình luận...',
                      hintStyle: TextStyle(fontSize: 15),  // Đảm bảo kích thước hintText nhỏ như chữ
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(bottom: 7),  // Căn giữa nội dung
                    ),
                    cursorWidth: 1.5,  // Giảm độ rộng của cursor
                    cursorHeight: 20,  // Giảm chiều cao của cursor
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  // Xử lý gửi comment
                  print('Gửi: ${_commentController.text}');
                  _commentController.clear();
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

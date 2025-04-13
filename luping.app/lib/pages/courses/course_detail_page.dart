import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:luping/pages/courses/fake_course_data.dart';
import 'package:luping/pages/courses/lesson_detail_page.dart';
import 'package:luping/pages/courses/lesson_item.dart';

class CourseDetailPage extends StatelessWidget {
  const CourseDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
        ),
        elevation: 0,
        shadowColor: Colors.transparent, // ✨ Không có bóng
        surfaceTintColor: Colors.transparent,
        title: const Text('Sơ cấp HSK 1', style: TextStyle(fontSize: 18),),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Section: Banner
              Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(16),
                shadowColor: Colors.black26,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Container(
                        width: 120,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: AssetImage('assets/video_thumbnail.png'), // thay bằng đường dẫn ảnh thật của bạn
                            fit: BoxFit.cover,
                          ),
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
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
              ),
              // Section: Tổng quan chương trình
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    Text(
                      'Chương trình học',
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    Text('10 Chương • 50 videos bài giảng • 95 tiếng 14 phút'),
                    SizedBox(height: 15,)
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: fakeCourseData.map((chapter) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300), // ✅ Bo viền
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        initiallyExpanded: true,
                        title: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/logo.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    chapter['title'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                chapter['info'],
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        children: (chapter['lessons'] as List).map<Widget>((lesson) {
                          return ListTile(
                            title: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(lesson['section'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: (lesson['items'] as List).map<Widget>((item) {
                                return LessonItem(
                                  title: item['title'],
                                  lectureCount: item['lectureCount'],
                                  duration: item['duration'],
                                  isLocked: item['isLocked'],
                                  isTrial: item['isTrial'],
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration: const Duration(milliseconds: 300),
                                        pageBuilder: (context, animation, secondaryAnimation) => LessonDetailPage(title: item['title']),
                                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                          const begin = Offset(1.0, 0.0); // từ bên phải
                                          const end = Offset.zero;
                                          const curve = Curves.ease;

                                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                                          return SlideTransition(
                                            position: animation.drive(tween),
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          )
        ),
      ),
    );
  }

}

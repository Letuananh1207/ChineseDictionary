import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommunityGroup extends StatelessWidget {
  final List<Map<String, dynamic>> groups = [
    {
      "name": "Lớp HSK 1 - Cơ bản",
      "members": 30,
      "schedule": "Thứ 2 & Thứ 4, 18:00 - 19:30",
      "teacher": "Thầy Lưu Văn Kiệt",
    },
    {
      "name": "Lớp HSK 2 - Sơ cấp",
      "members": 25,
      "schedule": "Thứ 3 & Thứ 5, 18:00 - 19:30",
      "teacher": "Cô Trần Thị Mai",
    },
    {
      "name": "Lớp HSK 3 - Trung cấp",
      "members": 20,
      "schedule": "Thứ 6 & Chủ nhật, 18:00 - 19:30",
      "teacher": "Thầy Hoàng Minh Đức",
    },
    {
      "name": "Lớp Giao tiếp tiếng Trung",
      "members": 35,
      "schedule": "Thứ 7 & Chủ nhật, 14:00 - 15:30",
      "teacher": "Cô Nguyễn Thảo Linh",
    },
    {
      "name": "Lớp Luyện thi HSK 4+",
      "members": 15,
      "schedule": "Thứ 2 & Thứ 5, 19:30 - 21:00",
      "teacher": "Thầy Trần Quốc Anh",
    },
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                spreadRadius: 0,
                blurRadius: 5.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.dark,
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Nhóm hỏi đáp',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: groups.length,
        itemBuilder: (context, index) {
          final group = groups[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            elevation: 3,
            color: Colors.white, // Đặt màu Card thành trắng
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text(
                group["name"],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("${group["members"]} thành viên"),
              trailing: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text("Tham gia", style: TextStyle(color: Colors.white)),
              ),
            ),
          );
        },
      ),
    );
  }
}

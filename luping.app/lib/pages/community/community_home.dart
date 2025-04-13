import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:luping/pages/community/community_home_post.dart';
import 'package:luping/pages/community/community_post_detail.dart';
import 'package:luping/pages/community/community_post_form.dart';
import 'community_group.dart';
import 'community_data.dart';

class CommunityHome extends StatefulWidget {
  @override
  _CommunityHomeState createState() => _CommunityHomeState();
}

class _CommunityHomeState extends State<CommunityHome> {
  final ScrollController _scrollController = ScrollController();
  bool _isAtTop = true;
  String _selectedTag = "all"; // Mặc định hiển thị tất cả
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Nếu cuộn xuống một đoạn thì ẩn
    bool isAtTop = _scrollController.offset < 20;
    if (isAtTop != _isAtTop) {
      setState(() {
        _isAtTop = isAtTop;
      });
    }
  }


  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent, // ✨ Không có bóng
        surfaceTintColor: Colors.transparent, // ✨ Loại bỏ hiệu ứng đổi màu khi cuộn
        centerTitle: false,
        title: _isSearching ? _buildSearchField() : Row(
          children: [
            Image.asset(
              'assets/logo.png',
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 8),
            const Text(
              'Cộng đồng',
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
              ),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              _buildSearchButton(),
              IconButton(
                icon: const Icon(Icons.group, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => CommunityGroup(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: _isAtTop
                ? Padding(
              key: ValueKey(true),
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: NetworkImage("https://yt3.ggpht.com/rbC68rxBCANyVKnZLfaeMXT_iUvz2pmag2SBPSG5TAYvF7W-cfgLf7c7oqXcvPQYaRivlM-N=s88-c-k-c0x00ffffff-no-rj"),
                    onBackgroundImageError: (_, __) {},
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) => CommunityPost(),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black26),
                        ),
                        child: const Text(
                          'Bạn đang suy nghĩ gì?',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
                : SizedBox.shrink(key: ValueKey(false)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FilterChip(
                  label: const Text('Tất cả'),
                  selected: _selectedTag == "all",
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedTag = "all";
                    });
                  },
                ),
                const SizedBox(width: 10),
                FilterChip(
                  label: const Text('Nhóm riêng'),
                  selected: _selectedTag == "group",
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedTag = "group";
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(10.0),
              itemCount: fakeData.where((post) => post["tag"] == _selectedTag || _selectedTag == "all").length,
              itemBuilder: (context, index) {
                final post = fakeData.where((post) => post["tag"] == _selectedTag || _selectedTag == "all").toList()[index];

                return buildPostCard(
                  context,
                  post,
                      () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return Container(
                          height: MediaQuery.of(context).size.height,
                          color: Colors.white,
                          child: SingleChildScrollView(
                            child: CommunityPostDetail(post: post),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          )
        ],
      ),

    );
  }

  Widget _buildSearchField() {
    return Container(
      // Sử dụng Container thay vì Expanded
      width: double.infinity, // Đảm bảo TextField chiếm toàn bộ chiều rộng
      child: TextField(
        controller: _searchController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: "Tìm kiếm...",
          border: InputBorder.none,
        ),
        onChanged: (query) {
          // TODO: Thêm logic xử lý tìm kiếm
          print("Tìm kiếm: $query");
        },
      ),
    );
  }

  /// Nút search sẽ thay đổi thành nút đóng khi đang tìm kiếm
  Widget _buildSearchButton() {
    return IconButton(
      icon: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.black),
      onPressed: () {
        setState(() {
          if (_isSearching) {
            // Nếu đang tìm kiếm, xóa ô tìm kiếm và đặt isSearching thành false
            _searchController.clear();
            _isSearching = false;
          } else {
            // Nếu không đang tìm kiếm, chuyển sang chế độ tìm kiếm
            _isSearching = true;
          }
        });
      },
    );
  }
}




import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:luping/models/hint_character.dart';
import 'package:luping/data/database_helper.dart';
import 'package:luping/models/hint_story.dart';
import 'package:luping/models/sentence.dart';
import 'package:luping/pages/search/drawingboard.dart';
import 'package:luping/pages/search/images/search_image_view.dart';
import 'package:luping/pages/search/utilities/search_loading_widget.dart';
import 'package:luping/pages/search/lobby/search_lobby_view.dart';
import 'package:luping/pages/search/sentences/search_sentence_view.dart';
import 'package:luping/pages/search/stories/search_story_view.dart';
import 'package:luping/pages/search/utilities/search_triangle_icon.dart';
import 'package:luping/pages/search/words/search_word_view.dart';
import 'package:luping/services/search_service.dart';
import 'handwriting.dart'; // Import lớp Handwriting

class Search extends StatefulWidget {
  final Function onBack; // Hàm callback để thay đổi trang
  final int sharedIndex;
  final int pageIndex;

  const Search({
    super.key,
    required this.onBack,
    required this.sharedIndex,
    required this.pageIndex
  });

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> with SingleTickerProviderStateMixin {
  // Import Search Service
  final SearchService _searchService = SearchService();

  // Color variable
  static const primaryColor = Color(0xFF96D962); // Màu chủ đề
  static const bodyColor = Color(0xFFF2F2F7); // Màu nền của body

  // Controllers
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late TabController _tabController;
  late PageController _pageController;

  // State tracking
  bool _isLoading = false;
  String _currentQuery = '';
  Timer? _debounceTimer;
  bool _isBackPressed = false;
  bool _isFocused = false;

  // Tab state
  late ValueNotifier<int> _selectedTabIndex;
  bool _isTabTapped = false;

  // Data storage
  final Map<int, dynamic> _cachedData = {
    0: <HintCharacter>[],  // Words
    1: <HintStory>[],      // Stories
    2: <Sentence>[],       // Sentences
    3: <String>[],         // Images
  };

  // Tab loading state
  final Set<int> _loadedTabs = {};

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    _selectedTabIndex = ValueNotifier<int>(widget.sharedIndex);
    _tabController = TabController(length: 4, vsync: this, initialIndex: widget.sharedIndex);
    _pageController = PageController(initialPage: widget.sharedIndex);

    // Set up tab and page synchronization
    _setupControllerListeners();

    // Initialize UI after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.pageIndex == 1) {
        FocusScope.of(context).requestFocus(_focusNode);
      }
    });
  }

  void _setupControllerListeners() {
    // Sync tab controller with page controller
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _isTabTapped = true;
        setState(() {
          _selectedTabIndex.value = _tabController.index;
        });

        // Animate to the selected page
        _pageController.animateToPage(
          _tabController.index,
          duration: const Duration(milliseconds: 200),
          curve: Curves.linear,
        );

        // Fetch data for the new tab if needed
        _loadTabDataIfNeeded(_tabController.index);
      }
    });

    // PageController không cần có listener riêng ở đây vì chúng ta
    // sẽ xử lý thông qua onPageChanged của PageView
  }

  @override
  void didUpdateWidget(covariant Search oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.sharedIndex != widget.sharedIndex) {
      _selectedTabIndex.value = widget.sharedIndex;
      _tabController.animateTo(widget.sharedIndex);
      _pageController.jumpToPage(widget.sharedIndex);
    }

    if (widget.pageIndex == 1) {
      Future.delayed(Duration.zero, () {
        FocusScope.of(context).requestFocus(_focusNode);
      });
    } else if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _tabController.dispose();
    _focusNode.dispose();
    _pageController.dispose();
    _selectedTabIndex.dispose();
    super.dispose();
  }

  // Load data for a specific tab if it's not already loaded and there's a query
  void _loadTabDataIfNeeded(int tabIndex) {
    if (_currentQuery.isNotEmpty && !_loadedTabs.contains(tabIndex)) {
      _fetchData(_currentQuery, tabIndex);
    }
  }

  // Unified data fetching method
  Future<void> _fetchData(String query, int tabIndex, {bool isNewQuery = false}) async {
    if (query.trim().isEmpty) {
      if (isNewQuery) {
        setState(() {
          // Clear all cached data if this is a new empty query
          for (var i = 0; i < 4; i++) {
            _clearCachedData(i);
          }
          _loadedTabs.clear();
        });
      }
      return;
    }

    setState(() {
      _isLoading = true;
      if (isNewQuery) {
        // Clear all cached data on new query
        for (var i = 0; i < 4; i++) {
          _clearCachedData(i);
        }
        _loadedTabs.clear();
      }
    });

    try {
      dynamic result;
      switch (tabIndex) {
        case 0:
          result = await _searchService.hintSearch(query);
          break;
        case 1:
          result = await _searchService.getStoryHint(query);
          break;
        case 2:
          result = await _searchService.getSentence(query);
          break;
        case 3:
          result = await _searchService.getImage(query, 0);
          result = result ?? []; // Handle null result for images
          break;
        default:
          print("Index không hợp lệ: $tabIndex");
          return;
      }

      setState(() {
        _cachedData[tabIndex] = result;
        _loadedTabs.add(tabIndex);
      });
    } catch (e) {
      print("Error fetching data for tab $tabIndex: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Clear cached data for a specific tab
  void _clearCachedData(int tabIndex) {
    switch (tabIndex) {
      case 0:
        _cachedData[0] = <HintCharacter>[];
        break;
      case 1:
        _cachedData[1] = <HintStory>[];
        break;
      case 2:
        _cachedData[2] = <Sentence>[];
        break;
      case 3:
        _cachedData[3] = <String>[];
        break;
    }
  }

  // Handle search text changes with debounce
  void _onSearchTextChanged(String newQuery) {
    _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (newQuery != _currentQuery) {
        setState(() {
          _currentQuery = newQuery;
        });

        // Fetch data for the current tab with the new query
        _fetchData(newQuery, _selectedTabIndex.value, isNewQuery: true);
      }
    });
  }

  // Clear search input and results
  void _clearText() {
    _controller.clear();
    setState(() {
      _currentQuery = '';
      for (var i = 0; i < 4; i++) {
        _clearCachedData(i);
      }
      _loadedTabs.clear();
    });
  }

  // Handle back button press
  Future<bool> _onWillPop() async {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
      return false;
    }

    if (_controller.text.isNotEmpty && !_isBackPressed) {
      _clearText();
      _isBackPressed = true;
      await Future.delayed(const Duration(seconds: 1));
      _isBackPressed = false;
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(58),
          child: AppBar(
            automaticallyImplyLeading: false,
            titleSpacing: 0.0,
            backgroundColor: primaryColor,
            title: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 21.0),
                    onPressed: () {
                      if (_focusNode.hasFocus) {
                        _focusNode.unfocus();
                      }
                      _clearText();
                      widget.onBack();
                    },
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              autofocus: false,
                              focusNode: _focusNode,
                              controller: _controller,
                              onChanged: _onSearchTextChanged,
                              style: const TextStyle(fontSize: 15.0),
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                hintText: '哈喽，你好，。。',
                                hintStyle: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 22),
                                fillColor: Colors.white,
                                filled: true,
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(18.0)),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: const Icon(Icons.search, size: 20.0, color: Colors.grey),
                                suffixIcon: _controller.text.isNotEmpty
                                    ? IconButton(
                                  icon: Icon(Icons.cancel, size: 18.0, color: Colors.grey[400]),
                                  onPressed: _clearText,
                                )
                                    : null,
                              ),
                              onTap: () {
                                setState(() {
                                  _isFocused = true;
                                });
                                FocusScope.of(context).requestFocus(_focusNode);
                              },
                            ),
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 10),
                              InkWell(
                                child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: const Icon(Icons.draw_outlined, color: Colors.white, size: 22)
                                ),
                                onTap: () {
                                  _focusNode.unfocus();
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const SizedBox(
                                        height: 400,
                                        child: DrawingBoard(),
                                      );
                                    },
                                  );
                                },
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        backgroundColor: bodyColor,
        body: GestureDetector(
          onPanEnd: (_) {
            SystemChannels.textInput.invokeMethod('TextInput.hide');
            setState(() {
              _isFocused = false;
            });
          },
          child: Column(
            children: [
              Container(
                color: primaryColor,
                height: 40,
                child: TabBar(
                  controller: _tabController,
                  tabs: ['Từ vựng', 'Story', 'Mẫu câu', 'Hình ảnh']
                      .map((label) => Tab(text: label))
                      .toList(),
                  labelPadding: const EdgeInsets.symmetric(vertical: 4),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.green[100],
                  indicator: const TriangleIndicator(
                    color: bodyColor,
                  ),
                ),
              ),
              Stack(
                children: [
                  Container(
                    height: 8,
                    color: primaryColor,
                  ),
                  Container(
                    height: 8,
                    decoration: const BoxDecoration(
                      color: bodyColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    // Khi người dùng lướt trang, cập nhật TabController bằng animateTo
                    // để đảm bảo indicator được cập nhật đúng cách
                    if (!_isTabTapped) {
                      setState(() {
                        _selectedTabIndex.value = index;
                      });
                      // Sử dụng animateTo với thời gian animation = 0 để kích hoạt
                      // việc vẽ lại indicator mà không có hiệu ứng chuyển động
                      _tabController.animateTo(index, duration: Duration.zero);

                      // Tải dữ liệu mới nếu cần
                      _loadTabDataIfNeeded(index);
                    } else {
                      // Reset flag sau khi hoàn tất chuyển trang
                      _isTabTapped = false;
                    }
                  },
                  children: [
                    _buildTabView(0),
                    _buildTabView(1),
                    _buildTabView(2),
                    _buildTabView(3),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Generic tab view builder based on index
  Widget _buildTabView(int tabIndex) {
    // Empty query shows lobby view
    if (_currentQuery.isEmpty) {
      return SearchLobbyView(type: _getTypeForTab(tabIndex));
    }

    // Trigger data load if needed
    if (!_loadedTabs.contains(tabIndex)) {
      _loadTabDataIfNeeded(tabIndex);
    }

    // Show loading indicator
    if (_isLoading && _cachedData[tabIndex].isEmpty) {
      return const Center(child: SearchLoadingWidget());
    }

    // No results found
    if (!_isLoading && _cachedData[tabIndex].isEmpty) {
      return const Center(child: Text("Không tìm thấy dữ liệu"));
    }

    // Return appropriate view based on tab
    switch (tabIndex) {
      case 0:
        return SearchWordView(list: _cachedData[0]);
      case 1:
        return SearchStoryView(list: _cachedData[1]);
      case 2:
        return SearchSentencesView(list: _cachedData[2]);
      case 3:
        return SearchImageView(list: _cachedData[3]);
      default:
        return const Center(child: Text("Tab không hợp lệ"));
    }
  }

  // Get search type name for the lobby view
  String _getTypeForTab(int tabIndex) {
    switch (tabIndex) {
      case 0: return 'word';
      case 1: return 'story';
      case 2: return 'sentence';
      case 3: return 'image';
      default: return 'unknown';
    }
  }
}
import 'package:flutter/material.dart';
import 'package:luping/pages/search/lobby/image_lobby.dart';
import 'package:luping/pages/search/lobby/sentence_lobby.dart';
import 'word_lobby.dart';
import 'story_lobby.dart';

class SearchLobbyView extends StatelessWidget {
  final String type;

  const SearchLobbyView({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case 'word':
        return const WordLobby();
      case 'story':
        return const StoryLobby();
      case 'sentence':
        return const SentenceLobby();
      case 'image':
        return const ImageLobby();
      default:
        return const Center(
          child: Text("Loại không hợp lệ", style: TextStyle(fontSize: 18, color: Colors.red)),
        );
    }
  }
}
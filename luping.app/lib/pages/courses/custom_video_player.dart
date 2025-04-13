import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const CustomVideoPlayer({super.key, required this.videoUrl});

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late VideoPlayerController _controller;
  bool _showControls = true;
  Timer? _hideControlsTimer;
  Timer? _positionUpdateTimer;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _startHideControlsTimer();
        _startPositionUpdater();
      });

    _controller.addListener(() {
      if (_controller.value.isPlaying) {
        _startHideControlsTimer();
      }

      if (_controller.value.position >= _controller.value.duration) {
        setState(() {
          _showControls = true;
        });
      }
    });
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (_controller.value.isPlaying) {
        setState(() => _showControls = false);
      }
    });
  }

  void _startPositionUpdater() {
    _positionUpdateTimer?.cancel();
    _positionUpdateTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_controller.value.isPlaying) {
        setState(() {});
      }
    });
  }

  void _playPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
        _startHideControlsTimer();
      }
      _showControls = true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _hideControlsTimer?.cancel();
    _positionUpdateTimer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final duration = _controller.value.duration;
    final position = _controller.value.position;

    return GestureDetector(
      onTap: () {
        setState(() => _showControls = !_showControls);
        if (_controller.value.isPlaying) _startHideControlsTimer();
      },
      child: AspectRatio(
        aspectRatio:
        _controller.value.isInitialized ? _controller.value.aspectRatio : 16 / 9,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _controller.value.isInitialized
                ? VideoPlayer(_controller)
                : const Center(child: CircularProgressIndicator()),
            if (_showControls)
              Container(
                color: Colors.black26,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.replay_10, color: Colors.white, size: 30),
                          onPressed: () {
                            _controller.seekTo(position - const Duration(seconds: 10));
                            _startHideControlsTimer();
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            _controller.value.isPlaying
                                ? Icons.pause_circle
                                : Icons.play_circle,
                            size: 48,
                            color: Colors.white,
                          ),
                          onPressed: _playPause,
                        ),
                        IconButton(
                          icon: const Icon(Icons.forward_10, color: Colors.white, size: 30),
                          onPressed: () {
                            _controller.seekTo(position + const Duration(seconds: 10));
                            _startHideControlsTimer();
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                      child: Row(
                        children: [
                          Text(_formatDuration(position),
                              style: const TextStyle(color: Colors.white, fontSize: 12)),
                          Expanded(
                            child: VideoProgressIndicator(
                              _controller,
                              allowScrubbing: true,
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              colors: VideoProgressColors(
                                playedColor: Colors.green,
                                bufferedColor: Colors.grey,
                                backgroundColor: Colors.white30,
                              ),
                            ),
                          ),
                          Text(_formatDuration(duration),
                              style: const TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      ),
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

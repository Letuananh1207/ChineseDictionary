import 'package:flutter/material.dart';

class DrawingBoard extends StatefulWidget {
  const DrawingBoard({super.key});

  @override
  _DrawingBoardState createState() => _DrawingBoardState();
}

class _DrawingBoardState extends State<DrawingBoard> {
  final List<Offset?> _points = [];
  String _recognizedResult = "";
  late Handwriting _handwriting;

  @override
  void initState() {
    super.initState();
    _handwriting = Handwriting();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        const Text(
          "Vẽ ký tự tiếng Trung ở đây",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          "Kết quả: $_recognizedResult",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: constraints.maxWidth, // 🔹 Chiều ngang tối đa
              height: 250, // Chiều cao cố định
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _points.add(details.localPosition);
                  });
                },
                onPanEnd: (details) {
                  _points.add(null);
                  _recognizeHandwriting();
                },
                child: CustomPaint(
                  size: Size.infinite,
                  painter: DrawingPainter(_points),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 20,),
            InkWell(
              onTap: () {
                Navigator.of(context).pop(); // 🔹 Đóng BottomSheet
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white, // 🔹 Nền trắng
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue, width: 1), // 🔹 Viền xanh
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // 🔹 Đổ bóng nhẹ
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.close, color: Colors.blue),
                    const SizedBox(width: 5),
                    const Text("Đóng", style: TextStyle(fontSize: 14, color: Colors.blue)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20), // 🔹 Khoảng cách giữa 2 nút
            Expanded(child: SizedBox()),
            const SizedBox(width: 20), // 🔹 Khoảng cách giữa 2 nút

            InkWell(
              onTap: _clearBoard,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white, // 🔹 Nền trắng
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red, width: 1), // 🔹 Viền đỏ
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // 🔹 Đổ bóng nhẹ
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.delete, color: Colors.red),
                    const SizedBox(width: 5),
                    const Text("Xóa", style: TextStyle(fontSize: 14, color: Colors.red)),
                  ],
                ),
              ),
            ),
            SizedBox(width: 20,),

          ],
        )

      ],
    );
  }


  void _clearBoard() {
    setState(() {
      _points.clear();
      _recognizedResult = "";
    });
  }

  void _recognizeHandwriting() {
    List<List<List<int>>> rawTrace = _convertPointsToTrace(_points);

    List<List<int>> trace = [];
    for (var stroke in rawTrace) {
      if (stroke.length == 2) {
        trace.add(stroke[0]);
        trace.add(stroke[1]);
      }
    }

    var options = {
      'language': 'zh_TW',
      'numOfReturn': 5,
      'numOfWords': 2,
    };

    _handwriting.recognize(
      trace,
      options,
          (results, error) {
        if (!mounted) return; // 🔹 Kiểm tra widget có còn tồn tại không
        setState(() {
          _recognizedResult = error != null ? "Error: ${error.toString()}" : results?.toString() ?? "No result";
        });
      },
    );
  }


  List<List<List<int>>> _convertPointsToTrace(List<Offset?> points) {
    List<List<List<int>>> trace = [];
    List<int> xCoords = [];
    List<int> yCoords = [];

    for (var point in points) {
      if (point != null) {
        xCoords.add(point.dx.toInt());
        yCoords.add(point.dy.toInt());
      } else if (xCoords.isNotEmpty && yCoords.isNotEmpty) {
        trace.add([xCoords, yCoords]);
        xCoords = [];
        yCoords = [];
      }
    }

    if (xCoords.isNotEmpty && yCoords.isNotEmpty) {
      trace.add([xCoords, yCoords]);
    }

    return trace;
  }
}

class DrawingPainter extends CustomPainter {
  final List<Offset?> points;

  DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}

class Handwriting {
  void recognize(List<List<int>> trace, Map<String, dynamic> options, Function(dynamic, dynamic) callback) {
    Future.delayed(const Duration(seconds: 1), () {
      callback(["字", "汉"], null); // 🔹 Kết quả giả định
    });
  }
}

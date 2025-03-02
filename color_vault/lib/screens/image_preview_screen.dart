import 'package:flutter/material.dart';
import 'dart:io';
import 'package:palette_generator/palette_generator.dart';
import 'package:hive/hive.dart';

class ImagePreviewScreen extends StatefulWidget {
  final File imageFile;
  final Function(List<Color>) onColorsSelected;

  ImagePreviewScreen({required this.imageFile, required this.onColorsSelected});

  @override
  _ImagePreviewScreenState createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  List<Color> _extractedColors = [];
  bool _isLoading = true;
  final List<Color> _selectedColors = [];
  late Box _colorBox;

  @override
  void initState() {
    super.initState();
    _openDatabase();
    Future.delayed(Duration(milliseconds: 100), _extractColors);
  }

  Future<void> _openDatabase() async {
    _colorBox = await Hive.openBox('colors');
  }

  Future<void> _extractColors() async {
    final imageProvider = FileImage(widget.imageFile);
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(imageProvider);

    setState(() {
      _extractedColors = paletteGenerator.colors.toList();
      _isLoading = false;
    });
  }

  void _saveColorsToDatabase() {
    for (var color in _selectedColors) {
      final hexColor =
          '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
      if (!_colorBox.containsKey(hexColor)) {
        _colorBox.put(hexColor, color.value);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Colors'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              _saveColorsToDatabase();
              widget.onColorsSelected(_selectedColors);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_isLoading) Center(child: CircularProgressIndicator()),
          if (!_isLoading)
            Column(
              children: [
                Expanded(flex: 1, child: Image.file(widget.imageFile)),
                Expanded(
                  flex: 1,
                  child: GridView.builder(
                    padding: EdgeInsets.all(8.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _extractedColors.length,
                    itemBuilder: (context, index) {
                      final color = _extractedColors[index];
                      bool isSelected = _selectedColors.contains(color);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedColors.remove(color);
                            } else {
                              _selectedColors.add(color);
                            }
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(12),
                            border:
                                isSelected
                                    ? Border.all(color: Colors.white, width: 3)
                                    : null,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(2, 4),
                              ),
                            ],
                          ),
                          child:
                              isSelected
                                  ? Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 30,
                                  )
                                  : null,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

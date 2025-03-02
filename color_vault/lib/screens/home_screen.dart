import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:pdf/pdf.dart';
import 'package:hive/hive.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'color_detail_screen.dart';
import 'image_preview_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();
  late Box<Color> _colorBox;

  @override
  void initState() {
    super.initState();
    _colorBox = Hive.box<Color>('colorsBox');
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => ImagePreviewScreen(
                imageFile: File(pickedFile.path),
                onColorsSelected: (colors) {
                  setState(() {
                    for (var color in colors) {
                      if (!_colorBox.values.contains(color)) {
                        _colorBox.add(color);
                      }
                    }
                  });
                },
              ),
        ),
      );
    }
  }

  Future<void> _exportCatalogCSV() async {
    List<List<String>> csvData = [
      ['Color Code'],
    ];
    for (var color in _colorBox.values) {
      csvData.add([
        '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}',
      ]);
    }
    String csv = const ListToCsvConverter().convert(csvData);
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/color_catalog.csv');
    await file.writeAsString(csv);
    Share.shareXFiles([XFile(file.path)], text: "Color Catalog CSV");
  }

  Future<void> _exportCatalogPDF() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build:
            (pw.Context context) => pw.Column(
              children:
                  _colorBox.values
                      .map(
                        (color) => pw.Container(
                          height: 50,
                          width: double.infinity,
                          color: PdfColor.fromInt(color.value),
                        ),
                      )
                      .toList(),
            ),
      ),
    );
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/color_catalog.pdf');
    await file.writeAsBytes(await pdf.save());
    Share.shareXFiles([XFile(file.path)], text: "Color Catalog PDF");
  }

  Future<void> _openColorPicker() async {
    Color selectedColor = Colors.blue;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (Color color) {
                selectedColor = color;
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              child: Text('Select'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ColorDetailScreen(color: selectedColor),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showExportOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.file_download),
                title: Text('Export CSV'),
                onTap: () {
                  Navigator.pop(context);
                  _exportCatalogCSV();
                },
              ),
              ListTile(
                leading: Icon(Icons.picture_as_pdf),
                title: Text('Export PDF'),
                onTap: () {
                  Navigator.pop(context);
                  _exportCatalogPDF();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteColor(int index) {
    setState(() {
      _colorBox.deleteAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = _colorBox.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Color Catalog'),
        actions: [
          IconButton(icon: Icon(Icons.share), onPressed: _showExportOptions),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Color Catalog!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Pick an image and extract colors to build your catalog.'),
            SizedBox(height: 24),

            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: colors.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onLongPress: () => _deleteColor(index),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  ColorDetailScreen(color: colors[index]),
                        ),
                      );
                    },
                    child: Hero(
                      tag: 'color_${colors[index].value}',
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: colors[index],
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(2, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '#${colors[index].value.toRadixString(16).padLeft(8, '0').toUpperCase()}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(blurRadius: 2, color: Colors.black),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        type: ExpandableFabType.up,
        distance: 60.0,
        children: [
          FloatingActionButton.small(
            heroTag: 'gallery',
            onPressed: () => _pickImage(ImageSource.gallery),
            child: Icon(Icons.image),
          ),
          FloatingActionButton.small(
            heroTag: 'camera',
            onPressed: () => _pickImage(ImageSource.camera),
            child: Icon(Icons.camera_alt),
          ),
          FloatingActionButton.small(
            heroTag: 'palette',
            onPressed: () => _openColorPicker(),
            child: Icon(Icons.color_lens),
          ),
        ],
      ),
    );
  }
}

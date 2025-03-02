import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

class ColorDetailScreen extends StatefulWidget {
  final Color color;

  ColorDetailScreen({required this.color});

  @override
  _ColorDetailScreenState createState() => _ColorDetailScreenState();
}

class _ColorDetailScreenState extends State<ColorDetailScreen> {
  late Box<Color> _colorBox;
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    _colorBox = Hive.box<Color>('colorsBox');
    isSaved = _colorBox.values.contains(widget.color);
  }

  String getHexCode() =>
      '#${widget.color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  String getRgbCode() =>
      'rgb(${widget.color.red}, ${widget.color.green}, ${widget.color.blue})';
  String getCssCode() => 'color: ${getHexCode()}';
  String getSwiftCode() =>
      'UIColor(red: ${widget.color.red / 255.0}, green: ${widget.color.green / 255.0}, blue: ${widget.color.blue / 255.0}, alpha: 1.0)';
  String getSwiftUiCode() =>
      'Color(red: ${widget.color.red / 255.0}, green: ${widget.color.green / 255.0}, blue: ${widget.color.blue / 255.0})';
  String getObjectiveCCode() =>
      '[UIColor colorWithRed:${widget.color.red / 255.0} green:${widget.color.green / 255.0} blue:${widget.color.blue / 255.0} alpha:1.0]';
  String getKotlinCode() =>
      'Color.rgb(${widget.color.red}, ${widget.color.green}, ${widget.color.blue})';

  void copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied to clipboard'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void toggleSave() {
    setState(() {
      if (isSaved) {
        _colorBox.deleteAt(_colorBox.values.toList().indexOf(widget.color));
      } else {
        _colorBox.add(widget.color);
      }
      isSaved = !isSaved;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Color Details')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(2, 4),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: toggleSave,
              child: Text(isSaved ? 'Delete' : 'Add'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  buildColorDetailTile(context, 'Hex', getHexCode()),
                  buildColorDetailTile(context, 'RGB', getRgbCode()),
                  buildColorDetailTile(context, 'CSS', getCssCode()),
                  buildColorDetailTile(context, 'Swift', getSwiftCode()),
                  buildColorDetailTile(context, 'SwiftUI', getSwiftUiCode()),
                  buildColorDetailTile(
                    context,
                    'Objective-C',
                    getObjectiveCCode(),
                  ),
                  buildColorDetailTile(context, 'Kotlin', getKotlinCode()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildColorDetailTile(
    BuildContext context,
    String label,
    String value,
  ) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          value,
          style: TextStyle(fontSize: 16, fontFamily: 'monospace'),
        ),
        trailing: IconButton(
          icon: Icon(Icons.copy, color: Colors.blueAccent),
          onPressed: () => copyToClipboard(context, value),
        ),
      ),
    );
  }
}

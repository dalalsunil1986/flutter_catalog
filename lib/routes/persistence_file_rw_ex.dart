import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import '../my_route.dart';

class FileReadWriteExample extends MyRoute {
  const FileReadWriteExample(
      [String sourceFile = 'lib/routes/persistence_file_rw_ex.dart'])
      : super(sourceFile);

  @override
  get title => 'Local file read/write';

  @override
  get description => 'Read and write local file using path_provider.';

  @override
  get links => {
        'Cookbook':
            'https://flutter.io/docs/cookbook/persistence/reading-writing-files',
      };

  @override
  Widget buildMyRouteContent(BuildContext context) {
    return Center(
      child: _FileRwDemo(),
    );
  }
}

class _FileRwDemo extends StatefulWidget {
  @override
  _FileRwDemoState createState() {
    return new _FileRwDemoState();
  }
}

class _FileRwDemoState extends State<_FileRwDemo> {
  static const String kLocalFileName = 'file_rw_demo_localfile.txt';
  final TextEditingController _textController = TextEditingController();
  String _localFileContent = '';
  String _localFilePath = kLocalFileName;

  @override
  void initState() {
    super.initState();
    this._readTextFromLocalFile();
    this._getLocalFile()
      ..then((file) => setState(() => this._localFilePath = file.path));
  }

  @override
  Widget build(BuildContext context) {
    FocusNode textFieldFocusNode = FocusNode();
    return ListView(
      padding: EdgeInsets.all(20.0),
      children: <Widget>[
        Text('Write to local file:'),
        TextField(
          focusNode: textFieldFocusNode,
          controller: _textController,
          maxLines: null,
        ),
        ButtonBar(
          children: <Widget>[
            MaterialButton(
              child: Text('Load'),
              onPressed: () async {
                this._readTextFromLocalFile();
                this._textController.text = this._localFileContent;
                _showSnackBar('String successfully loaded from local file.');
                // Focus on text field (bring keyboard up).
                FocusScope.of(context).requestFocus(textFieldFocusNode);
              },
            ),
            MaterialButton(
              child: Text('Save'),
              onPressed: () async {
                await this._writeTextToLocalFile(this._textController.text);
                this._textController.clear();
                _showSnackBar('String successfully written to local file".');
                this._readTextFromLocalFile();
              },
            ),
          ],
        ),
        Divider(height: 20.0),
        Text('Local file path:'),
        Text(this._localFilePath, style: Theme.of(context).textTheme.caption),
        Divider(height: 20.0),
        Text('Local file content:'),
        Text(this._localFileContent,
            style: Theme.of(context).textTheme.caption),
      ],
    );
  }

  Future<File> _getLocalFile() async {
    final directory = await path_provider.getApplicationDocumentsDirectory();
    return File('${directory.path}/$kLocalFileName');
  }

  Future<File> _writeTextToLocalFile(String text) async {
    final file = await _getLocalFile();
    return file.writeAsString(text);
  }

  // Reads local file into this._localFileContent.
  Future<Null> _readTextFromLocalFile() async {
    String content;
    try {
      final file = await _getLocalFile();
      content = await file.readAsString();
    } catch (e) {
      content = 'Error loading local file: $e';
    }
    setState(() {
      this._localFileContent = content;
    });
  }

  void _showSnackBar(String text) {
    Scaffold.of(this.context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: Duration(milliseconds: 500),
      ),
    );
  }
}

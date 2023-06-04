import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:flutter/material.dart';
import 'package:nexa_pros_installer/start_page_view.dart';

class ChooseNPIFile extends StatefulWidget {
  const ChooseNPIFile({Key? key}) : super(key: key);

  @override
  State<ChooseNPIFile> createState() => _ChooseNPIFileState();
}

class _ChooseNPIFileState extends State<ChooseNPIFile> {
  TextEditingController filePathCont = TextEditingController();
  String error = '';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(),
            Column(
              children: [
                const Text(
                  'اختر حزمة تود تثبيتها',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // color: Colors.yellow,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  error,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            TextField(
              controller: filePathCont,
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                  child: IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: checkFile,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            MaterialButton(
              onPressed: pickFile,
              minWidth: 200,
              height: 80,
              child: const Text(
                'اختيار ملف',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(),
          ],
        ),
      ),
    );
  }

  Future<void> checkFile() async {
    var fileState = await nPIFileExists(filePathCont.text);
    if (fileState == FileState.npFile) {
      Navigator.pop(context);
    } else if (fileState == FileState.notNpFile) {
      error = 'الملف المحدد ليس حزمة تثبيت';
      print('Not NP File');
      setState(() {});
    }
  }

  void pickFile() async {
    final file = OpenFilePicker()
      ..filterSpecification = {
        'Nexapros Installer File (*.npi)': '*.npi',
        'All Files': '*.*'
      }
      ..defaultFilterIndex = 0
      ..defaultExtension = 'npi'
      ..title = 'Select NP File';

    final result = file.getFile();
    if (result != null) {
      print(result.path);
      filePathCont.text = result.path;
      await checkFile();
      //  var fileState = await nPIFileExists(result.path);
    }
  }
}

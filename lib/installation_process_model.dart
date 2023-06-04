import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nexa_pros_installer/global_state.dart';
import 'package:nexa_pros_installer/registeration_view.dart';
import 'package:nexa_pros_installer/updaters.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:updater/updater.dart' as updater;

class InstallationProgress {
  InstallationProgress({
    required this.installationPath,
    required this.zipFilePath,
    required this.updaterIns,
  }) {
    if (GlobalState.instance.getInstallationProgress() == null) {
      GlobalState.instance.setInstallationProgress(this);
    }
  }

  static InstallationProgress instance =
      GlobalState.instance.getInstallationProgress();

  String? installationPath;
  String? zipFilePath;
  final updater.Updater updaterIns;
  num progress = 0.0;
  Uint8List? bytes;
  Archive? archive;
  bool doneSuccessfuly = false;
  bool errorOcc = false;
  StreamSubscription<double>? streamSubscription;
  Process? process;

  void cancel() {
    bytes = null;
    archive = null;
    streamSubscription?.cancel();
    process?.kill();
  }

  Future<bool> checkFileExists() async {
    return await File(zipFilePath!).exists();
  }

  void startInstallation(BuildContext context) {
    var stream = unzipFilesAndCopyStream(installationPath!, zipFilePath!);
    streamSubscription = stream.listen((event) {
      updaterIns.add(event);
    }, onDone: () async {
      await Future.delayed(
        const Duration(milliseconds: 500),
      );
      if (!errorOcc) {
        doneSuccessfuly = true;

        List<String> filesPaths = [
          '${Directory.current.path}\\mongodb-windows-x86_64-4.4.2-signed.msi'
        ];
        for (var filePath in filesPaths) {
          var file = File(filePath);
          if (await file.exists()) {
            await file.copy(
                installationPath! + '/mongodb-windows-x86_64-4.4.2-signed.msi');
          } else {
            throw 'File ${file.path} Not Found';
          }
        }

        void streamOfTalas() {
          var tt = .0;
          Stream.periodic(const Duration(milliseconds: 100), (t) {
            tt += 0.01;
            InstallationStateUpdater().add(tt);
          });
        }

        onProcess(Process process) {
          streamOfTalas();

          var transformer =
              StreamTransformer<List<int>, List<int>>.fromHandlers(
            handleData: (chunk, sink) {
              List<int> _fixedChunk = [...chunk];
              _fixedChunk.removeWhere((element) => element == 0);
              if (utf8
                  .decode(_fixedChunk)
                  .contains('Error opening installation log file')) {
                sink.addError(utf8.decode(_fixedChunk));
              } else {
                sink.add(_fixedChunk);
              }
            },
            handleError: (e, s, sink) {
              sink.addError(e);
            },
          );

          process.stdout.transform<List<int>>(transformer).listen((event) {
            stdout.write(utf8.decode(event));
          }, onDone: () {
            doneSuccessfuly = true;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RegisterationAndValidatingView(),
              ),
            );
            if (!errorOcc) {
              Alert(
                context: context,
                type: AlertType.success,
                title: "installation_done_successfuly".tr(),
                desc: "some_apps_has_been_requested_to_be_installed".tr(),
                buttons: [
                  DialogButton(
                    child: const Text(
                      "OK",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () => Navigator.pop(context),
                    width: 120,
                  )
                ],
              ).show();
            }
          }, onError: (e) {
            errorOcc = true;
            print('Error');
            Alert(
              context: context,
              type: AlertType.error,
              title: "An Error Occurred",
              desc: e.toString(),
              buttons: [
                DialogButton(
                  child: const Text(
                    "OK",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () => Navigator.pop(context),
                  width: 120,
                )
              ],
            ).show();
          });
        }

        await Process.start(
          'msiexec.exe',
          [
            '/l*v',
            'mdbinstall.log',
            '/qb',
            '/i',
            'mongodb-windows-x86_64-4.4.2-signed.msi',
          ],
          workingDirectory: installationPath,
        ).then(onProcess);
      }
    }, onError: (e) async {
      errorOcc = true;
      Alert(
        context: context,
        type: AlertType.error,
        title: "An Error Occurred",
        desc: e.toString(),
        buttons: [
          DialogButton(
            child: const Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    });
  }

  Stream<double> unzipFilesAndCopyStream(
      String out, String zipFilePath) async* {
    // Read the Zip file from disk.
    File file = File(zipFilePath);

    final bytes = file.readAsBytesSync();

    // Decode the Zip file
    final archive = ZipDecoder().decodeBytes(bytes);
    // var zipFileSizetoStringLength = (await file.length());
    var _zipFileSizeProgress = 0;
    // var onePercentValue = zipFileSize / 100;
    // Extract the contents of the Zip archive to disk.
    num? r1;
    var totalSize = .0;
    for (final file in archive) {
      if (file.isFile) {
        totalSize += file.size;
      }
    }
    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        File('$out/' + filename)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
        _zipFileSizeProgress += file.size;
        r1 =
            (_zipFileSizeProgress / (totalSize / 100).round()).roundToDouble() *
                0.01;
        yield (r1 > 1.0 ? 1.0 : r1).toDouble();
      } else {
        await Directory('$out/' + filename).create(recursive: true);
      }
    }
  }
}

num d1(num d, int t) {
  for (var i = 0; i < t; i++) {
    d *= .0;
  }
  return d;
}


    // Use an InputFileStream to access the zip file without storing it in memory.
    // final inputStream = InputFileStream('C:/CLaB/ESC-POS-.NET-master.zip');
    // // Decode the zip from the InputFileStream. The archive will have the contents of the
    // // zip, without having stored the data in memory.
    // final archive = ZipDecoder().decodeBuffer(inputStream);
    // // For all of the entries in the archive
    // for (var file in archive.files) {
    //   // If it's a file and not a directory
    //   if (file.isFile) {
    //     // Write the file content to a directory called 'out'.
    //     // In practice, you should make sure file.name doesn't include '..' paths
    //     // that would put it outside of the extraction directory.
    //     // An OutputFileStream will write the data to disk.
    //     final outputStream = OutputFileStream('C:/CLaB/${file.name}');
    //     // The writeContent method will decompress the file content directly to disk without
    //     // storing the decompressed data in memory.
    //     // outputStream.path;
    //     // File tFile = File(zipFilePath);
    //     // archive..;
    //     // tFile.openWrite();
    //     // Make sure to close the output stream so the File is closed.
    //     outputStream.close();
    //   }
    // }
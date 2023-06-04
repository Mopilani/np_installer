import 'dart:io';

// import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_desktop_folder_picker/flutter_desktop_folder_picker.dart';
import 'package:get/get.dart';
import 'package:nexa_pros_installer/developer_mode_view.dart';
import 'package:nexa_pros_installer/enums.dart';
import 'package:nexa_pros_installer/installation_process_model.dart';
import 'package:nexa_pros_installer/installation_screen.dart';
import 'package:nexa_pros_installer/updaters.dart';
import 'package:nexa_pros_installer/views/choose_npi_file_view.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:updater/updater.dart' as updater;
// import 'package:easy_localization/src/public_ext.dart';

import 'main.dart';

late String globalLanguageValue;

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

bool isNpFile(String filePath) {
  String fileName = filePath.split(Platform.pathSeparator).last;
  if (filePath.split(Platform.pathSeparator).last.isNotEmpty) {
    if (fileName.split('.').last == 'npi') {
      return true;
    }
  }
  return false;
}

Future<File?> searchNPFile([String? searchDirectory]) async {
  searchDirectory ??= Directory.current.path;
  var directory = Directory(searchDirectory);
  File? file;
  await directory.list().listen((fileSystemEntity) {
    String fileName = fileSystemEntity.path.split(Platform.pathSeparator).last;
    var isNpFileFound = isNpFile(fileSystemEntity.path);
    if (isNpFileFound) {
      file = File(fileName);
    }
  }).asFuture();

  if (file == null) {
    return null;
  } else {
    return file;
  }
}

enum FileState {
  notNpFile,
  notFound,
  npFile,
}

Future<FileState> nPIFileExists([String? filePath]) async {
  File? file;
  if (filePath != null) {
    if (await File(filePath).exists()) {
      var isNpFileFound = isNpFile(filePath);
      if (isNpFileFound) {
        return FileState.npFile;
      }
      return FileState.notNpFile;
    }
  }

  file = await searchNPFile();
  if (file != null) {
    if (await file.exists()) {
      return FileState.npFile;
    }
  }
  return FileState.notFound;
}

class _StartPageState extends State<StartPage> {
  late TextEditingController pathCont;
  String? installationPath;
  String? pathErrorText;

  @override
  void initState() {
    super.initState();
    pathCont = TextEditingController(text: 'C:/Program Files/Besmar');
  }

  @override
  Widget build(BuildContext context) {
    // globalLanguageValue = context.supportedLocales.first.languageCode;

    return Scaffold(
      body: FutureBuilder<FileState>(
        future: nPIFileExists(passedFilePath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            print('${snapshot.error}');
            return Center(
              child: Column(
                children: [
                  Text(
                    snapshot.error.toString(),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    snapshot.stackTrace.toString(),
                  ),
                ],
              ),
            );
          }
          print('${snapshot.data}');
          if (snapshot.hasData) {
            if (snapshot.data! == FileState.npFile) {
              print('NPFile');
            } else {
              // return ChooseNPIFile();
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChooseNPIFile(),
                  ),
                );
              });
            }
          } else {
            return const Center(
              child: LinearProgressIndicator(),
            );
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/Nexapros_logo.ico',
                    height: 100,
                    width: 150,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'welcome_to_nexapros_installer'.tr,
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  const Spacer(),
                  updater.UpdaterBloc(
                    updater: InstallationButtonStateUpdater(
                      initialState: InstallationState.normal,
                      updateForCurrentEvent: true,
                    ),
                    update: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'select_installation_path'.tr,
                              style: const TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 80,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: TextField(
                                      controller: pathCont,
                                      decoration: InputDecoration(
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                            12,
                                            0,
                                            12,
                                            0,
                                          ),
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.folder,
                                              color: Colors.grey,
                                            ),
                                            onPressed: () async {
                                              String? path =
                                                  await FlutterDesktopFolderPicker
                                                      .openFolderPickerDialog();
                                              if (path != null) {
                                                pathCont.text = path;
                                              }
                                            },
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        errorText: pathErrorText,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 50),
                          Container(
                            alignment: Alignment.center,
                            child: state.data == InstallationState.loading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : installButton(),
                          ),
                        ],
                      );
                    },
                  ),
                  // const SizedBox(height: 100),
                  Text(
                    ''.tr + '\nAll Copy Rights Reserved for NexaPros',
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DeveloperModeView(),
                            ),
                          );
                        },
                        child: Text('developer_mode'.tr),
                      ),
                      DropdownButton<String>(
                        items: supportedLocales.map((local) {
                          return DropdownMenuItem<String>(
                            child: Text(local.languageCode),
                            value: local.languageCode,
                            onTap: () async {
                              // await context.setLocale(local);
                              Get.updateLocale(local);
                            },
                          );
                        }).toList(),
                        value: globalLanguageValue,
                        onChanged: (value) async {
                          if (value == null) return;
                          globalLanguageValue = value;
                        },
                      ),
                    ],
                  ),
                  // const SizedBox(height: 100),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget installButton() {
    return MaterialButton(
      color: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          right: 20,
          bottom: 8,
          left: 20,
          top: 8,
        ),
        child: Text(
          'install'.tr,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      onPressed: () async {
        InstallationButtonStateUpdater().add(InstallationState.loading);
        try {
          await Directory(pathCont.text).create().then((value) async {
            if (await Directory(pathCont.text).exists()) {
              installationPath = pathCont.text;
              // print(Directory.current.path);
              InstallationProgress(
                installationPath: installationPath,
                zipFilePath: '${Directory.current.path}/setup.np',
                updaterIns: InstallationStateUpdater(),
              );
              InstallationButtonStateUpdater().add(InstallationState.loading);
              await InstallationProgress.instance
                  .checkFileExists()
                  .then((value) {
                if (value) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Installation(
                          // installationPath: installationPath!,
                          ),
                    ),
                  );
                } else {
                  InstallationButtonStateUpdater()
                      .add(InstallationState.normal);
                }
              });
            } else {
              InstallationButtonStateUpdater().add(InstallationState.error);
              pathErrorText = 'Installation Directory Does Not Exists';
            }
          });
        } catch (e) {
          var reason = '';
          if (e.toString().contains('OS Error: Access is denied')) {
            reason =
                'Access Is Denied\nPlease run the application as adminstrator to avoid issues.';
          }

          InstallationButtonStateUpdater().add(InstallationState.error);
          Alert(
            context: context,
            type: AlertType.error,
            title: "An Error Occurred",
            desc: reason,
            buttons: [
              DialogButton(
                child: const Text(
                  "COOL",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.pop(context),
                width: 120,
              )
            ],
          ).show();
        }
      },
    );
  }
}



                                            // var path = await FilesystemPicker.open(
                                            //   title: 'save_to_folder'.tr(),
                                            //   context: context,
                                            //   rootDirectory:
                                            //       Directory('C:/Program Files'),
                                            //   fsType: FilesystemType.folder,
                                            //   pickText:
                                            //       'save_files_to_this_folder'.tr(),
                                            //   folderIconColor: Colors.teal,
                                            // );
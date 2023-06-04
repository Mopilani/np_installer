import 'package:flutter/material.dart';
import 'package:nexa_pros_installer/start_page_view.dart';
// import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';

import 'internationalization/translations.dart';

String? passedFilePath;
List<Locale> supportedLocales = [];
void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  // await EasyLocalization.ensureInitialized();

  // if (args.isNotEmpty) {
  //   if (args.first == space) return;
  // }
  String title;
  if (args.isEmpty) {
    title = 'Nexapros Installer';
  } else {
    title = 'Nexapros Installer ${args.first}';
    passedFilePath = args.first;
  }
  supportedLocales = [
    const Locale('ar', 'SD'),
    const Locale('en', 'US'),
  ];
  globalLanguageValue = 'ar';
  runApp(
    GetMaterialApp(
      // supportedLocales: supportedLocales,
      title: title,

      translations: Messages(), // your translations
      // path: 'assets/translations',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'SD'),
      fallbackLocale: const Locale('en', 'US'),
      // assetLoader: const CodegenLoader(),
      // home: App(args: args),
      home: const StartPage(),
    ),
  );
}

// class App extends StatelessWidget {
//   const App({Key? key, required this.args}) : super(key: key);
//   final List<String> args;

//   @override
//   Widget build(BuildContext context) {
//     String title;
//     if (args.isEmpty) {
//       title = 'Nexapros Installer';
//     } else {
//       title = 'Nexapros Installer ${args.first}';
//       passedFilePath = args.first;
//     }
//     return MaterialApp(
//       localizationsDelegates: context.localizationDelegates,
//       supportedLocales: context.supportedLocales,
//       locale: context.locale,
//       debugShowCheckedModeBanner: false,
//       title: title,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const StartPage(),
//     );
//   }
// }

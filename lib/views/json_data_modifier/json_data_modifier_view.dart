import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_json_view/flutter_json_view.dart';
import 'package:get/get.dart';
import 'package:updater/updater.dart' as updater;

import 'controller.dart';

class JsonDataModifier extends StatelessWidget {
  JsonDataModifier({Key? key}) : super(key: key) {
    controller = TextEditingController(text: initialJsonStr);
  }
  final Map<String, dynamic> map = {
    'key': 'value',
    'number': 0,
  };

  String? error;
  String initialJsonStr = json.encode({
    'key': 'value',
    'number': 0,
  });

  TextEditingController controller = TextEditingController();
  // // var map = <String, dynamic>{}.obs;
  // final JsonViewModefierController cont = Get.put(JsonViewModefierController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Row(
          children: [],
        ),
      ),
      body: updater.UpdaterBloc(
          updater: ThisPageUpdater(
            initialState: 0,
            updateForCurrentEvent: true,
          ),
          update: (context, index) {
            return Column(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      errorText: error,
                      hintText: 'data',
                      // suffixIcon: IconButton(
                      //   icon: const Icon(Icons.file_copy),
                      //   onPressed: () {},
                      // ),
                    ),
                    expands: true,
                    maxLines: null,
                    minLines: null,
                    onChanged: (text) {
                      try {
                        map.clear();
                        map.addAll(json.decode(text));
                        error = null;
                        ThisPageUpdater().add(0);
                      } catch (e) {
                        error = e.toString();
                        ThisPageUpdater().add(0);
                      }
                    },
                  ),
                ),
                Expanded(
                  child: JsonView.map(
                    map,
                    theme: JsonViewTheme(
                      //   keyStyle: TextStyle(
                      //     color: Colors.black54,
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.w600,
                      //   ),
                      //   doubleStyle: TextStyle(
                      //     color: Colors.green,
                      //     fontSize: 16,
                      //   ),
                      //   intStyle: TextStyle(
                      //     color: Colors.green,
                      //     fontSize: 16,
                      //   ),
                      //   stringStyle: TextStyle(
                      //     color: Colors.green,
                      //     fontSize: 16,
                      //   ),
                      //   boolStyle: TextStyle(
                      //     color: Colors.green,
                      //     fontSize: 16,
                      //   ),
                      closeIcon: Icon(
                        Icons.close,
                        color: Colors.green,
                        size: 20,
                      ),
                      openIcon: Icon(
                        Icons.add,
                        color: Colors.green,
                        size: 20,
                      ),
                      //   separator: Padding(
                      //     padding: EdgeInsets.symmetric(horizontal: 8.0),
                      //     child: Icon(
                      //       Icons.arrow_right_alt_outlined,
                      //       size: 20,
                      //       color: Colors.green,
                      //     ),
                      //   ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class ThisPageUpdater extends updater.Updater {
  ThisPageUpdater({
    initialState,
    bool updateForCurrentEvent = false,
  }) : super(initialState, updateForCurrentEvent: updateForCurrentEvent);
}

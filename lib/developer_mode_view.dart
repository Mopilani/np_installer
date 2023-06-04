import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexa_pros_installer/views/json_data_modifier/json_data_modifier_view.dart';

class DeveloperModeView extends StatefulWidget {
  const DeveloperModeView({Key? key}) : super(key: key);

  @override
  State<DeveloperModeView> createState() => _DeveloperModeViewState();
}

class _DeveloperModeViewState extends State<DeveloperModeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Mode'),
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () {},
            title: const Text('Insert Data to Mongo DB'),
            subtitle: const Text('Insert Json Data to Mongo DB'),
          ),
          ListTile(
            onTap: () => Get.to( JsonDataModifier()),
            title: const Text('Read Data from Mongo DB'),
            subtitle: const Text('Read Json Data from Mongo DB'),
          ),
          ListTile(
            onTap: () {},
            title: const Text('Json Data Modifier'),
            subtitle: const Text('Modifi Json Data to match your needs'),
          ),
          ListTile(
            onTap: () {
              /// Must select applciation package
            },
            title: const Text('Debug Application'),
            subtitle: const Text(
                'Debug Application and analysis application requirements'),
          ),
          ListTile(
            onTap: () {},
            title: const Text('Send Application Errors Log'),
            subtitle: const Text(
                'Send application errors log to the system manufacture'),
          ),
        ],
      ),
    );
  }
}

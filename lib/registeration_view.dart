import 'dart:io';

import 'package:flutter/material.dart';

class RegisterationAndValidatingView extends StatefulWidget {
  const RegisterationAndValidatingView({Key? key}) : super(key: key);

  @override
  State<RegisterationAndValidatingView> createState() =>
      _RegisterationAndValidatingViewState();
}

class _RegisterationAndValidatingViewState
    extends State<RegisterationAndValidatingView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      exit(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    // getDisksInfos();
    // getVolumes();
    return Scaffold(
      body: Center(
        child: Column(
          children: const [
            Spacer(),
            Text(
              'All Done',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

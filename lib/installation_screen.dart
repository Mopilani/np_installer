import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nexa_pros_installer/installation_process_model.dart';
import 'package:nexa_pros_installer/registeration_view.dart';
import 'package:nexa_pros_installer/updaters.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:updater/updater.dart' as updater;

class Installation extends StatefulWidget {
  const Installation({
    Key? key,
    // required this.installationPath,
  }) : super(key: key);
  // final String installationPath;

  @override
  _InstallationState createState() => _InstallationState();
}

class _InstallationState extends State<Installation> {
  @override
  void initState() {
    super.initState();
    InstallationProgress.instance.startInstallation(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var width = size.width;
    return Scaffold(
      body: updater.UpdaterBloc(
        updater: InstallationStateUpdater(
          initialState: 0.0,
          updateForCurrentEvent: true,
        ),
        update: (context, state) {
          print(state.data);

          if (InstallationProgress.instance.doneSuccessfuly) {
          
          }
          return Column(
            children: [
              const SizedBox(height: 100),
              const Text(
                'installing',
                style: TextStyle(
                  fontSize: 40,
                ),
              ).tr(),
              const Spacer(),
              Row(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LinearPercentIndicator(
                        width: width - 50,
                        lineHeight: 12.0,
                        percent: state.data ?? 0.0,
                        progressColor: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 2),
              cancelButton(),
              const SizedBox(height: 100),
              const Text(
                'All Copy Rights Reserved for NexaPros 2020',
              ),
              const Spacer(),
            ],
          );
        },
      ),
    );
  }

  Widget cancelButton() {
    return MaterialButton(
      color: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 8,
          bottom: 8,
        ),
        child: const Text(
          'cancel',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ).tr(),
      ),
      onPressed: () async {
        InstallationProgress.instance.cancel();
        Navigator.pop(context);
      },
    );
  }

  Widget exitButton() {
    return MaterialButton(
      color: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 8,
          bottom: 8,
        ),
        child: Text(
          'Exit',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      onPressed: () async {
        // exit(3);
      },
    );
  }
}
  // if (InstallationProgress.instance.errorOcc) {
          //   return Scaffold(
          //     body: Center(
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: const [
          //           Text(
          //             'Error!',
          //             textAlign: TextAlign.center,
          //             style: TextStyle(
          //               fontWeight: FontWeight.w600,
          //               fontSize: 32,
          //             ),
          //           ),
          //           Text(
          //             'Try Run the Application As Adminstrator',
          //             textAlign: TextAlign.center,
          //             style: TextStyle(
          //               fontWeight: FontWeight.w600,
          //               fontSize: 24,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   );
          // }
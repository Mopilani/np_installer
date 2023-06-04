import 'package:updater/updater.dart' as updater;

class InstallationButtonStateUpdater extends updater.Updater {
  InstallationButtonStateUpdater({
    initialState,
    bool updateForCurrentEvent = false,
  }) : super(
          initialState,
          updateForCurrentEvent: updateForCurrentEvent,
        );
}

class InstallationStateUpdater extends updater.Updater {
  InstallationStateUpdater({
    initialState,
    bool updateForCurrentEvent = false,
  }) : super(
          initialState,
          updateForCurrentEvent: updateForCurrentEvent,
        );
}

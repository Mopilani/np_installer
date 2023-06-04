
import 'installation_process_model.dart';

class GlobalState {
  static GlobalState instance = GlobalState();

  Map<String, dynamic> cache = <String, dynamic>{};

  get(key) => cache[key];

  getInstallationProgress() => cache['ip'];

  set(key, value) => cache[key] = value;

  setInstallationProgress(InstallationProgress progress) =>
      cache['ip'] = progress;

  void delete(key) => cache.remove(key);
}

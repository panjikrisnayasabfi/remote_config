import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  bool _featureFlagText1 = false;
  bool _featureFlagText2 = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 30),
        minimumFetchInterval: Duration.zero,
      ));

      /// set in-app default parameter values
      await _remoteConfig.setDefaults(const {
        "feature_flag_text_1": true,
        "feature_flag_text_2": false,
      });

      await _remoteConfig.fetchAndActivate();
      await _remoteConfig.ensureInitialized();

      bool featureFlagText1 = _remoteConfig.getBool('feature_flag_text_1');
      bool featureFlagText2 = _remoteConfig.getBool('feature_flag_text_2');

      debugPrint('feature_flag_text_1: $featureFlagText1');
      debugPrint('feature_flag_text_2: $featureFlagText2');

      setState(() {
        _featureFlagText1 = featureFlagText1;
        _featureFlagText2 = featureFlagText2;
      });

      debugPrint('lastFetchStatus: ${_remoteConfig.lastFetchStatus}');
      debugPrint('lastFetchTime: ${_remoteConfig.lastFetchTime}');
      debugPrint('fetchTimeout: ${_remoteConfig.settings.fetchTimeout}');
      debugPrint(
          'minimumFetchInterval: ${_remoteConfig.settings.minimumFetchInterval}');
      debugPrint('pluginConstants: ${_remoteConfig.pluginConstants}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _getLatestRemoteConfigDataButton(),
          const SizedBox(height: 32),
          if (_featureFlagText1) const Text('Feature flag text 1'),
          if (_featureFlagText2) const Text('Feature flag text 2'),
        ],
      ),
    );
  }

  Widget _getLatestRemoteConfigDataButton() {
    void onPressed() {}

    return ElevatedButton(
      onPressed: onPressed,
      child: const Text('Get Latest Remote Config Data'),
    );
  }
}

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'home_screen.dart';
import 'transaction_screen.dart';
import 'user_profile.dart';
import '../widgets/navbar.dart';

class Dashboard extends StatefulWidget {
  Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var authService = AuthService();
  var isLogoutLoading = false;
  int currentIndex = 0;
  var pageViewList = [HomeScreen(), TransactionScreen(), UserProfilePage()];

  String latestApkUrl = ''; // Holds the latest APK URL

  @override
  void initState() {
    super.initState();
    _checkVersion();
  }

  Future<void> _checkVersion() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: Duration(seconds: 10),
      minimumFetchInterval: Duration(hours: 1),
    ));
    await remoteConfig.fetchAndActivate();

    final minimumRequiredVersion = remoteConfig.getString('minimum_required_version');
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;

    setState(() {
      latestApkUrl = remoteConfig.getString('latest_apk_url'); // Update the latest APK URL
    });

    if (_isUpdateRequired(currentVersion, minimumRequiredVersion)) {
      _showUpdateDialog();
    }
  }

  bool _isUpdateRequired(String currentVersion, String requiredVersion) {
    final currentParts = currentVersion.split('.').map(int.parse).toList();
    final requiredParts = requiredVersion.split('.').map(int.parse).toList();

    for (int i = 0; i < requiredParts.length; i++) {
      if (currentParts.length <= i || currentParts[i] < requiredParts[i]) {
        return true;
      } else if (currentParts[i] > requiredParts[i]) {
        return false;
      }
    }
    return false;
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Update Required'),
        content: Text('A new version of the app is available. Please update to continue.'),
        actions: [
          TextButton(
            onPressed: _redirectToUpdate,
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  void _redirectToUpdate() {
    if (latestApkUrl.isNotEmpty) {
      launch(latestApkUrl); // Launch the latest APK URL using url_launcher
    } else {
      // Fallback if URL is empty or not available
      final defaultUrl = 'https://drive.google.com/drive/folders/1k51cCnURx-V04zzyrerRMDSo-YCWrKEP?usp=sharing'; // Provide a default URL
      launch(defaultUrl); // Launch the default URL
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (int value) {
          setState(() {
            currentIndex = value;
          });
        },
      ),
      body: pageViewList[currentIndex],
    );
  }
}

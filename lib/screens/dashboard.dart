import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/auth_service.dart';
import '../widgets/navbar.dart';
import 'home_screen.dart';
import 'transaction_screen.dart';
import 'user_profile.dart';

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

  String latestApkUrl = '';

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

    if (mounted) {  // Add this check
      setState(() {
        latestApkUrl = remoteConfig.getString('latest_apk_url');
      });
    }

    if (_isUpdateRequired(currentVersion, minimumRequiredVersion)) {
      _showUpdateDialog();
    }
  }


  bool _isUpdateRequired(String currentVersion, String requiredVersion) {
    final currentParts = currentVersion.split('.').map(int.parse).toList();
    final requiredParts = requiredVersion.split('.').map(int.parse).toList();

    while (currentParts.length < requiredParts.length) {
      currentParts.add(0);
    }
    while (requiredParts.length < currentParts.length) {
      requiredParts.add(0);
    }

    for (int i = 0; i < requiredParts.length; i++) {
      if (currentParts[i] < requiredParts[i]) {
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
        backgroundColor: Color(0xFF252634),
        title: Text(
          textAlign: TextAlign.center,
          'Update Required',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.redAccent.shade400,
          ),
        ),
        content: Text(
          'A new version of the app is available. Please update to continue.',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: _redirectToUpdate,
            child: Text(
              'Update',
              style: TextStyle(color: Colors.yellowAccent[700], fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  void _redirectToUpdate() async {
    final url = latestApkUrl.isNotEmpty
        ? latestApkUrl
        : 'https://drive.google.com/drive/folders/1k51cCnURx-V04zzyrerRMDSo-YCWrKEP?usp=sharing';

    if (!url.startsWith('http')) {
      print('Invalid URL: $url');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid update URL')),
      );
      return;
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      print('Launching URL: $url');
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print('Could not launch URL: $url');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch update URL')),
      );
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

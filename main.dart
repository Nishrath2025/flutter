dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.2.2
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Login App',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // loading
          } else {
            return snapshot.data == true ? DashboardPage() : LoginPage();
          }
        },
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _controller = TextEditingController();

  void _login() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _controller.text);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => DashboardPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Enter Username'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            )
          ],
        ),
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getUsername(),
      builder: (context, snapshot) {
        final username = snapshot.data ?? 'User';
        return Scaffold(
          appBar: AppBar(title: Text('Dashboard')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Welcome, $username!', style: TextStyle(fontSize: 22)),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _logout(context),
                  child: Text('Logout'),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

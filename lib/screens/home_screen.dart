import 'package:flutter/material.dart';
import 'package:flutter_login/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String account = "";
  bool logout = false;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      account = prefs.getString("user") ?? "";
    });
    if(account == null || account.isEmpty) {
      // not yet login
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        actions: [
          IconButton(onPressed: _onLogout, icon: const Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Text("Hello $account!"),
      ),
    );
  }

  void _onLogout() async {
    if(logout) {
      return;
    }
    setState(() {
      logout = true;
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("user");
    setState(() {
      logout = false;
    });
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
  }
}
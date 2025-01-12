import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mascotas/RegisterUsers/RegisterPage.dart';
import 'package:mascotas/RegisterUsers/encrypt_data.dart';
import 'package:mascotas/widgets/tab_bar.dart';
import '../RegisterUsers/ApiServices_Users.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final EncryptData encryptData = EncryptData();
  bool _isObscured = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  late Map data;
  late List userData = [];

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  Future<void> getUsers() async {
    final List<dynamic> users = await ApiService.getUsers();
    setState(() {
      userData = users;
    });
  }

  Future<void> _storeUserData(String username) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
  }

  Future<bool> _validateLogin(String username1, String password1) async {
    for (var user in userData) {
      if (user['username'] == username1) {
        bool isVerified = await encryptData.verifyPassword(password1, user['password']);
        return isVerified;
      }
    }
    return false;
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(240, 22, 61, 96),
          title: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          content: Text(message, style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            TextButton(
              child: Text('Ok', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.bottomRight,
              radius: 3.5,
              colors: [
                const Color.fromARGB(240, 22, 61, 96),
                const Color.fromARGB(255, 25, 23, 61),
                const Color.fromARGB(255, 25, 23, 61),
                const Color.fromARGB(255, 25, 23, 61),
                const Color.fromARGB(240, 25, 23, 61),
              ],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          margin: const EdgeInsets.only(top: 50.0),
                          child: CustomPaint(
                            painter: ContainerPainter(),
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                          color: Color.fromARGB(240, 22, 61, 96),
                                          width: 2),
                                      color: const Color.fromARGB(61, 0, 0, 0),
                                    ),
                                    child: TextFormField(
                                      key: const Key('username_field'),
                                      controller: _usernameController,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.person, color: Colors.white),
                                        labelText: 'Username',
                                        labelStyle: TextStyle(color: Colors.white),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.all(15),
                                      ),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                          color: Color.fromARGB(240, 22, 61, 96),
                                          width: 2),
                                      color: const Color.fromARGB(61, 0, 0, 0),
                                    ),
                                    child: TextFormField(
                                      key: const Key('password_field'),
                                      controller: _passwordController,
                                      obscureText: _isObscured,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.lock, color: Colors.white),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _isObscured ? Icons.visibility : Icons.visibility_off,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _isObscured = !_isObscured;
                                            });
                                          },
                                        ),
                                        labelText: 'Contraseña',
                                        labelStyle: TextStyle(color: Colors.white),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.all(15),
                                      ),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  SizedBox(height: 40),
                                  ElevatedButton(
                                    key: Key('login_button'),
                                    onPressed: () async {
                                      if (_usernameController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
                                        bool isLoginValid = await _validateLogin(
                                            _usernameController.text, _passwordController.text);
                                        if (isLoginValid) {
                                          await _storeUserData(_usernameController.text);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => TabBarCustom()),
                                          );
                                        } else {
                                          _showAlertDialog("Login invalid", "Username or password incorrect");
                                        }
                                      } else {
                                        _showAlertDialog("Login invalid", "Texfield empty");
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF1f4a71),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                                    ),
                                    child: Text('Ingresar', style: TextStyle(color: Colors.white)),
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 2,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(Icons.keyboard_arrow_down, color: Colors.white),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Container(height: 2, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 40),
                                  Text(
                                    "¿Aún no tienes cuenta?",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(height: 40),
                                  Container(
                                    child: ElevatedButton(
                                      key: Key('register_button'),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => RegisterPage()),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF1f4a71),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                                      ),
                                      child: Text('Registrar usuario', style: TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                  SizedBox(height: 60),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: MediaQuery.of(context).size.width / 2 - 50,
                          top: 0,
                          child: CircleAvatar(
                            radius: 50.0,
                            backgroundColor: Colors.transparent,
                            child: Icon(
                              Icons.account_circle,
                              size: 100,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ContainerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color.fromARGB(61, 0, 0, 0)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 20)
      ..arcToPoint(Offset(20, 0), radius: Radius.circular(20), clockwise: false)
      ..lineTo(size.width - 20, 0)
      ..arcToPoint(Offset(size.width, 20), radius: Radius.circular(20), clockwise: false)
      ..lineTo(size.width, size.height - 20)
      ..arcToPoint(Offset(size.width - 20, size.height), radius: Radius.circular(20), clockwise: true)
      ..lineTo(20, size.height)
      ..arcToPoint(Offset(0, size.height - 20), radius: Radius.circular(20), clockwise: true)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

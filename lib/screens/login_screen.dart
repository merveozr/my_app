import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool isLoading = false;

  Future<void> _loginUser() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Giriş başarılı → home ekranına yönlendir
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Giriş Hatası: ${e.message}")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBEFFF),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: isLoading
              ? const CircularProgressIndicator()
              : Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Giriş Yap',
                        style: TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: const InputDecoration(labelText: "E-posta"),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (val) => email = val ?? '',
                        validator: (val) =>
                            val!.isEmpty ? "E-posta gerekli" : null,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: "Şifre"),
                        obscureText: true,
                        onSaved: (val) => password = val ?? '',
                        validator: (val) =>
                            val!.length < 6 ? "Şifre en az 6 karakter olmalı" : null,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _loginUser,
                        child: const Text("Giriş Yap"),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const Text("Kayıt Ol"),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

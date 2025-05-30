import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String surname = '';
  String email = '';
  String password = '';
  String birthplace = '';
  String city = '';
  String gender = 'Erkek';
  DateTime? birthDate;

  bool isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        birthDate = picked;
      });
    }
  }

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen doğum tarihi seçiniz.")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // Firebase Auth ile kullanıcı oluştur
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Firestore’a ek bilgilerle kullanıcı kaydet
      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set({
        'name': name,
        'surname': surname,
        'email': email,
        'birthDate': birthDate!.toIso8601String(),
        'gender': gender,
        'birthplace': birthplace,
        'city': city,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Başarıyla kayıt oldu, login sayfasına yönlendir
      Navigator.pushReplacementNamed(context, '/login');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: ${e.message}")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kayıt Ol")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Ad"),
                      onSaved: (val) => name = val ?? '',
                      validator: (val) => val!.isEmpty ? "Zorunlu alan" : null,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Soyad"),
                      onSaved: (val) => surname = val ?? '',
                      validator: (val) => val!.isEmpty ? "Zorunlu alan" : null,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: "E-posta"),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (val) => email = val ?? '',
                      validator: (val) => val!.isEmpty ? "Zorunlu alan" : null,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Şifre"),
                      obscureText: true,
                      onSaved: (val) => password = val ?? '',
                      validator: (val) =>
                          val!.length < 6 ? "En az 6 karakter olmalı" : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text("Doğum Tarihi: "),
                        Text(birthDate == null
                            ? "Seçilmedi"
                            : "${birthDate!.day}/${birthDate!.month}/${birthDate!.year}"),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(context),
                        ),
                      ],
                    ),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: "Cinsiyet"),
                      value: gender,
                      items: ['Erkek', 'Kadın', 'Diğer']
                          .map((g) => DropdownMenuItem(
                                value: g,
                                child: Text(g),
                              ))
                          .toList(),
                      onChanged: (val) => gender = val ?? 'Erkek',
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Doğum Yeri"),
                      onSaved: (val) => birthplace = val ?? '',
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Yaşadığı İl"),
                      onSaved: (val) => city = val ?? '',
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _registerUser,
                      child: const Text("Kayıt Ol"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

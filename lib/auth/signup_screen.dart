import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:glance/auth/auth_service.dart';
import 'package:glance/auth/login_screen.dart';
import 'package:glance/Discover/home_screen.dart';
import 'package:glance/widgets/button.dart';
import 'package:glance/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = AuthService();
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _password.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? selectedImage = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (selectedImage != null) {
        _imageFile = File(selectedImage.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // const Spacer(),
                const Text("Signup", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500)),
                const SizedBox(height: 20,),
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                    child: _imageFile == null
                        ? Icon(Icons.camera_alt, size: 50)
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  hint: "Enter Name",
                  label: "Name",
                  controller: _name,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  hint: "Enter Phone Number",
                  label: "Phone Number",
                  controller: _phone,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  hint: "Enter Email",
                  label: "Email",
                  controller: _email,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  hint: "Enter Password",
                  label: "Password",
                  isPassword: true,
                  controller: _password,
                ),
                const SizedBox(height: 30),
                CustomButton(
                  label: "Signup",
                  onPressed: _signup,
                ),
                const SizedBox(height: 5),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text("Already have an account? "),
                  InkWell(
                    onTap: () => goToLogin(context),
                    child: const Text("Login", style: TextStyle(color: Colors.red)),
                  )
                ]),
                // const Spacer()
              ],
            ),
          ),
        ),
      ),
    );
  }

  goToLogin(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const LoginScreen()),
  );

  goToHome(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const HomeScreen()),
  );

  _signup() async {
    final user = await _auth.createUserWithEmailAndPassword(_email.text, _password.text);
    if (user != null) {
      String? photoURL;
      if (_imageFile != null) {
        Reference ref = FirebaseStorage.instance.ref().child('user_photos').child(user.uid);
        UploadTask uploadTask = ref.putFile(_imageFile!);
        await uploadTask.whenComplete(() async {
          photoURL = await ref.getDownloadURL();
        });
      }

      Map<String, String> dataToSave = {
        "name": _name.text,
        "phone": _phone.text,
        "email": _email.text,
        "photoURL": photoURL ?? '',
      };

      FirebaseFirestore.instance.collection('user_details').doc(user.uid).set(dataToSave);

      log("User Created Succesfully");
      goToHome(context);
    }
  }
}
import 'dart:convert';
import 'package:akhbari/pages/home_page.dart';
import 'package:akhbari/widgets/utilties/custom_action_button.dart';
import 'package:akhbari/widgets/utilties/custom_textfield.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signin_page.dart';
import '../api/modelApi.dart';

class SignUp extends StatefulWidget {
  static const routeName = '/signup';
  SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool loading = false;
  final usernameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  Future<void> getCharactersfromApi() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<NewsMod> characList = [];

    CharacterApi.getCharacters().then((response) async {
      setState(() {
        Iterable list = json.decode(response.body);
        characterList = list.map((model) => NewsMod.fromJson(model)).toList();
        characterList.sort((a, b) => DateTime.now()
            .difference(DateTime.parse(a.date_time))
            .compareTo(DateTime.now().difference(DateTime.parse(b.date_time))));
      });

      //for (var i in characterList) print(i.date_time);

      if (characList.isNotEmpty) {
        final rawJson1 = prefs.getString('keystring') ?? '';
        Iterable list = json.decode(rawJson1);
        characList = list.map((model) => NewsMod.fromJson(model)).toList();
        for (var j in characList) {
          for (var k in characterList) {
            if (k.toString() != j.toString()) {
              characList.addAll(characterList);
              print(characList.length);
              String rawJson = json.encode(characList);
              await prefs.setString('keystring', rawJson);
            } else if (k.toString() == j.toString()) {
              print(characList.length);
            } else {
              print(characList.length);
              String rawJson = json.encode(characterList);
              await prefs.setString('keystring', rawJson);
            }
          }
        }
      } else if (characList.isEmpty) {
        print(characList.length);
        String rawJson = json.encode(characterList);
        await prefs.setString('keystring', rawJson);
      }
    }).then((value){
      setState(() {
        loading = false;
      });
      Navigator.push(
        context, MaterialPageRoute(builder: (context) => BottomNavBar()));});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: loading?Center(
        child: LoadingAnimationWidget.twistingDots(
          leftDotColor: const Color(0xFF1A1A3F),
          rightDotColor: const Color(0xFF00BF63),
          size: 100,

        ),
      ):SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                ),
              ],
            ),
            SizedBox(
              height: 0,
            ),
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/LOGO.png"))),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Welcome to AKHBARI News",
              style: TextStyle(
                  letterSpacing: 5,
                  color: Color(0xff004AAD),
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Please fill in the required fields",
              style:
                  TextStyle(letterSpacing: 2, color: Colors.grey, fontSize: 12),
            ),
            SizedBox(
              height: 25,
            ),
            CustomTextField(
              controller: usernameController,
              hintText: 'Full Name',
              obscureText: false,
            ),
            SizedBox(
              height: 5,
            ),
            CustomTextField(
              controller: emailController,
              hintText: 'E-mail',
              obscureText: false,
            ),
            SizedBox(
              height: 5,
            ),
            CustomTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
            ),
            SizedBox(height: 35),
            CustomActionButton(
              onTap: () async {
                setState(() {
                  loading = true;
                });
                if(emailController.text.isNotEmpty && usernameController.text.isNotEmpty && passwordController.text.isNotEmpty )
                  {
                    UserCredential result = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text).whenComplete(() => AwesomeDialog(
                      context: context,
                      dialogType: DialogType.success,
                      borderSide: const BorderSide(
                        color: Colors.green,
                        width: 2,
                      ),
                      width: 300,
                      buttonsBorderRadius: const BorderRadius.all(
                        Radius.circular(2),
                      ),
                      dismissOnTouchOutside: false,
                      dismissOnBackKeyPress: false,
                      onDismissCallback: (type) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Dismissed by User'),
                          ),
                        );
                      },
                      headerAnimationLoop: true,
                      animType: AnimType.bottomSlide,
                      title: 'Account Added',
                      desc: 'Welcome to akhbari news',
                      btnOkOnPress: () {
                        loading
                            ? Center(
                          child: LoadingAnimationWidget.twistingDots(
                            leftDotColor: const Color(0xFF1A1A3F),
                            rightDotColor: const Color(0xFF00BF63),
                            size: 100,
                          ),
                        ):
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    BottomNavBar()));

                      },
                    ).show());
                    User? user = result.user;
                    if (user != null) {
                      user.updateDisplayName(usernameController.text);
                      await user.reload();
                      user = await FirebaseAuth.instance.currentUser;
                      print("Registered user:");
                      print(user);
                    }
                    getCharactersfromApi().whenComplete(() async {
                      final SharedPreferences prefs1 = await SharedPreferences.getInstance();
                      await prefs1.setString('email', '${FirebaseAuth.instance.currentUser?.email}');
                      await prefs1.setString('password', '${passwordController.text}').whenComplete(() {


                      });

                    });
                  }
                else{
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.error,
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 2,
                    ),
                    width: 300,
                    buttonsBorderRadius: const BorderRadius.all(
                      Radius.circular(2),
                    ),
                    dismissOnTouchOutside: false,
                    dismissOnBackKeyPress: false,
                    onDismissCallback: (type) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Dismissed by User'),
                        ),
                      );
                    },
                    headerAnimationLoop: true,
                    animType: AnimType.bottomSlide,
                    title: 'Error Occurred',
                    desc: 'Sorry Something went Wrong',
                    btnOkOnPress: () {

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SignUp()));

                    },
                  ).show();
                }


              },
              hintText: 'Sign Up',
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'already have an account ? ',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                GestureDetector(
                  child: Text(
                    '  Log In',
                    style: TextStyle(
                        color: Color(0xff004AAD),
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

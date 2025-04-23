import 'dart:convert';
import 'package:akhbari/pages/home_page.dart';
import 'package:akhbari/pages/signup_page.dart';
import 'package:akhbari/widgets/utilties/custom_action_button.dart';
import 'package:akhbari/widgets/utilties/custom_textfield.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../api/modelApi.dart';

String usernam = "";
String userpas = "";
bool offline = false;

class Login extends StatefulWidget {
  static const routeName = '/login';
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loading = false;
  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  var Data;

  var QueryText;
  void getCharactersfromApi() async {
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
    }).then((value) {
      setState(() {
        loading = false;
      });
      Navigator.push(
        context, MaterialPageRoute(builder: (context) => BottomNavBar()));});
  }

  Future<void> getCharactersfromApiOff() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final rawJson1 = await prefs.getString('keystring') ?? '';
    Iterable list = json.decode(rawJson1);
    characterList = list.map((model) => NewsMod.fromJson(model)).toList();
  }

  int index1 = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: loading
          ? Center(
            child: LoadingAnimationWidget.twistingDots(
                leftDotColor: const Color(0xFF1A1A3F),
                rightDotColor: const Color(0xFF00BF63),
                size: 100,
              ),
          )
          : SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
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
                    height: 25,
                  ),
                  CustomTextField(
                    controller: usernameController,
                    hintText: 'E-mail',
                    obscureText: false,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(height: 35),
                  CustomActionButton(
                    onTap: () async {
                      setState(() {
                        loading = true;
                      });
                      final SharedPreferences prefs1 =
                          await SharedPreferences.getInstance();
                      final String? emailoff = prefs1.getString('email');
                      final String? passoff = prefs1.getString('password');

                      offline
                          ? (emailoff == usernameController.text
                              ? (passoff == passwordController.text
                                  ? await getCharactersfromApiOff()
                                      .whenComplete(() {
                                      setState(() {
                                        loading = false;
                                      });
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BottomNavBar()));
                                    })
                                  : AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        borderSide: const BorderSide(
                          color: Colors.yellow,
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
                        title: 'Warning',
                        desc: 'Please Check Your Email and Password',
                        btnOkOnPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Login()));
                        },
                      ).show())
                              : AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        borderSide: const BorderSide(
                          color: Colors.yellow,
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
                        title: 'Warning',
                        desc: 'Please Check Your Email and Password',
                        btnOkOnPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Login()));
                        },
                      ).show())
                          : FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: usernameController.text,
                                  password: passwordController.text)
                              .then((value) => getCharactersfromApi())
                              .whenComplete(() {
                        AwesomeDialog(
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
                          title: 'Verified',
                          desc: 'Welcome to AKHBARI NEWS',
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
                        ).show();
                            }).onError((error, stackTrace) => AwesomeDialog(
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
                        desc: 'Please Check Your Internet Connection and Credentials',
                        btnOkOnPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Login()));
                        },
                      ).show());
                      setState(() {
                        usernam = usernameController.text;
                        userpas = passwordController.text;
                      });
                      print("Retrieving ...");

                      setState(() {});
                    },
                    hintText: 'Sign In',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  offline
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'dont have account ? ',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 14),
                            ),
                            GestureDetector(
                              child: Text(
                                '  Sign Up',
                                style: TextStyle(
                                    color: Color(0xff004AAD),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUp()));
                              },
                            ),
                          ],
                        ),
                  Spacer(
                    flex: 1,
                  ),
                  ToggleSwitch(
                    minWidth: 90.0,
                    initialLabelIndex: index1,
                    cornerRadius: 15.0,
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.grey,
                    inactiveFgColor: Colors.white,
                    totalSwitches: 2,
                    labels: ['Online', 'Offline'],
                    icons: [Icons.wifi, Icons.wifi_2_bar],
                    activeBgColors: [
                      [Color(0xff004AAD)],
                      [Color(0xff004AAD)]
                    ],
                    onToggle: (index) {
                      setState(() {
                        if (index == 0) {
                          offline = false;
                        } else if (index == 1) {
                          offline = true;
                        }
                        index1 = index!;
                        print('switched to: $index');
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
    );
  }
}

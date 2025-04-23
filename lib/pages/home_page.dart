import 'dart:async';
import 'dart:convert';
import 'package:akhbari/pages/categories_page.dart';
import 'package:akhbari/pages/news_page.dart';
import 'package:akhbari/pages/signin_page.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xen_popup_card/xen_card.dart';
import '../api/modelApi.dart';
import '../widgets/utilties/custom_button.dart';
import '../widgets/utilties/image_container.dart';
import 'all_news_page.dart';

XenCardAppBar appBar = const XenCardAppBar(
  child: Text(
    "Account Info",
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
  ),
  shadow: BoxShadow(color: Colors.transparent),
);

XenCardGutter gutter = XenCardGutter(
  child: Padding(
    padding: EdgeInsets.all(8.0),
    child: CustomButton(text: "Reset Password"),
  ),
);

XenCardGutter gutter2 = const XenCardGutter(
  child: Padding(
    padding: EdgeInsets.all(8.0),
    child: CustomButton2(text: "Apply Changes"),
  ),
);

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  List<NewsMod> characList = [];

  List<NewsMod> characList1 = [];
  var _selectedTab = _SelectedTab.home;
  Future<void> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final rawJson = prefs.getString('keystring') ?? '';

    setState(() {
      Iterable list = json.decode(rawJson);
      characList = list.map((model) => NewsMod.fromJson(model)).toList();
      //for (var i in characList) print(i.title);
    });
    characList1 = characList;
  }

  @override
  void initState() {
    setState(() {
      init();
    });
    super.initState();
  }


  Future<void> _handleIndexChanged(int i) async {
      await init().whenComplete(() =>  _selectedTab = _SelectedTab.values[i]);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        child: panels[_selectedTab.index],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 40, right: 40.0),
        child: DotNavigationBar(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              offset: Offset(0, 4),
            )
          ],
          margin: EdgeInsets.only(left: 15, right: 15),
          currentIndex: _SelectedTab.values.indexOf(_selectedTab),
          dotIndicatorColor: Colors.white,
          unselectedItemColor: Colors.grey[300],
          splashBorderRadius: 20,
          enableFloatingNavBar: true,
          onTap: _handleIndexChanged,
          items: [
            DotNavigationBarItem(
              icon: Icon(Icons.article),
              selectedColor: Color(0xff004AAD),
            ),
            DotNavigationBarItem(
              icon: Icon(Icons.home),
              selectedColor: Color(0xff004AAD),
            ),
            DotNavigationBarItem(
              icon: Icon(Icons.category),
              selectedColor: Color(0xff004AAD),
            ),
          ],
        ),
      ),
    );
  }
}

enum _SelectedTab { news, home, favorite }

List<Widget> panels = [
  AllNews(),
  HomeScreen(),
  Categories(),
];
List<NewsMod> characList = [];

List<NewsMod> characList1 = [];
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = false;


  Future<void> getCharactersfromApi2() async {
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
      final rawJson1 = prefs.getString('keystring') ?? '';
      Iterable list = json.decode(rawJson1);
      characList = list.map((model) => NewsMod.fromJson(model)).toList();
      if (characList.isNotEmpty) {
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
    });
  }

  @override
  Widget build(BuildContext context) {

    // NewsMod article = characterList.isEmpty?new NewsMod():characterList[0];

    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        floatingActionButton: DraggableFab(
          securityBottom: 60,
          child: FloatingActionButton(
            onPressed: () async {
              setState(() {
                loading = true;

              });
              await getCharactersfromApi2().whenComplete(() {
                setState(() {
                  loading = false;
                });
              });
            },
            mini: true,
            backgroundColor: Color(0xFF00BF63),
            child: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          ),
        ),
        body: loading?Center(
          child: LoadingAnimationWidget.twistingDots(
            leftDotColor: const Color(0xFF1A1A3F),
            rightDotColor: const Color(0xFF00BF63),
            size: 100,
          ),
        ):Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _NewsOfTheDay(),
            Expanded(child: _BreakingNews(articles: offline?characList:characterList)),
          ],
        ));
  }
}

class _BreakingNews extends StatefulWidget {
  const _BreakingNews({
    Key? key,
    required this.articles,
  }) : super(key: key);

  final List<NewsMod> articles;

  @override
  State<_BreakingNews> createState() => _BreakingNewsState();
}

class _BreakingNewsState extends State<_BreakingNews> {


  void init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final rawJson = prefs.getString('keystring') ?? '';

    setState(() {
      Iterable list = json.decode(rawJson);
      characList = list.map((model) => NewsMod.fromJson(model)).toList();
      //for (var i in characList) print(i.title);
    });
    characList1 = characList;
  }

  @override
  void initState() {
    setState(() {
      init();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 30,
            width: double.infinity,
            child: Text(
              'Breaking News',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Expanded(
            child:characterList.isEmpty?Container(child: Center(child: Text("Sorry Something Went Wrong! \nRefresh or Try to Log In Again"),),): ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: characterList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 140,
                      margin: const EdgeInsets.only(right: 5, bottom: 0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            NewsScreen.routeName,
                            arguments: offline?characList[index]:characterList[index],
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 140,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ImageContainer(
                                width: 120,
                                height: 120,
                                imageUrl: offline?"https://images.template.net/wp-content/uploads/2016/03/14124445/Typographic-World-Night-Map-Free.jpg":(characterList[index].imageurl != "NaN"
                                    ? characterList[index].imageurl
                                    : "https://images.template.net/wp-content/uploads/2016/03/14124445/Typographic-World-Night-Map-Free.jpg"),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 15, right: 15, top: 5),
                                height: 140,
                                width: 200,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      offline?"${characList[index].title}":"${characterList[index].title}",
                                      maxLines: 2,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.bold,
                                              height: 1.5),
                                    ),
                                    Spacer(
                                      flex: 1,
                                    ),
                                    Row(
                                      children: [
                                        Text('by ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall),
                                        Text(
                                          ' ${offline?characList[index].source:characterList[index].source}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        )
                                      ],
                                    ),
                                    Spacer(
                                      flex: 1,
                                    ),
                                    Text(
                                        '${DateTime.now().difference(DateTime.parse(offline?characList[index].date_time:characterList[index].date_time)).inHours} hours ago',
                                        style: TextStyle(
                                            color: Color(0xFF00BF63),
                                            fontSize: 12)),
                                    Spacer(
                                      flex: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NewsOfTheDay extends StatefulWidget {
  const _NewsOfTheDay({
    Key? key,

  }) : super(key: key);

  // final NewsMod article;

  @override
  State<_NewsOfTheDay> createState() => _NewsOfTheDayState();
}

class _NewsOfTheDayState extends State<_NewsOfTheDay> {


  void init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final rawJson = prefs.getString('keystring') ?? '';

    setState(() {
      Iterable list = json.decode(rawJson);
      characList = list.map((model) => NewsMod.fromJson(model)).toList();
      //for (var i in characList) print(i.title);
    });
    characList1 = characList;
  }

  @override
  void initState() {
    setState(() {
      init();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        characterList.isEmpty?Container(child: Center(child: Text(""),),):ImageContainer(
          height: MediaQuery.of(context).size.height * 0.39,
          width: double.infinity,
          padding: const EdgeInsets.all(20.0),
          imageUrl: offline?"https://images.template.net/wp-content/uploads/2016/03/14124445/Typographic-World-Night-Map-Free.jpg":(characterList[0].imageurl != "NaN"
              ? characterList[0].imageurl
              : "https://images.template.net/wp-content/uploads/2016/03/14124445/Typographic-World-Night-Map-Free.jpg"),
          child: characterList.isEmpty?Container(child: Center(child: Text("Sorry Something Went Wrong! \nRefresh or Try to Log In Again"),),):Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'News of the Day',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                  Container(
                    width: double.infinity,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white.withOpacity(0.8),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Text(
                      offline?characList[0].title:characterList[0].title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(
                              fontWeight: FontWeight.normal,
                              height: 1.25,
                              color: Colors.black,
                              fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 140,
                    height: 45,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Color(0xff004AAD).withOpacity(0.5)),
                    child: TextButton(
                      onPressed: () async {
                        Navigator.pushNamed(
                          context,
                          NewsScreen.routeName,
                          arguments: characterList[0],
                        );
                      },
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(
                            flex: 1,
                          ),
                          Text(
                            "More",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                          ),
                          Spacer(
                            flex: 3,
                          ),
                          Icon(
                            Icons.more_horiz,
                            color: Colors.white,
                          ),
                          Spacer(
                            flex: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          child: Container(
            height: 50,
            width: double.infinity,
            padding: EdgeInsets.only(left: 20, right: 20),
            margin: EdgeInsets.only(top: 50),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/LOGO.png"),
                            fit: BoxFit.fill)),
                  ),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (builder) => Container(
                          padding: EdgeInsets.only(top: 220, bottom: 220),
                          child: XenPopupCard(
                            appBar: appBar,
                            gutter: gutter,
                            body: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Full Name"),
                                    Spacer(
                                      flex: 1,
                                    ),
                                    Text(
                                        "${FirebaseAuth.instance.currentUser?.displayName}"),
                                    Spacer(
                                      flex: 2,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("E-mail"),
                                    Spacer(
                                      flex: 1,
                                    ),
                                    Text(
                                        "${FirebaseAuth.instance.currentUser?.email}"),
                                    Spacer(
                                      flex: 2,
                                    ),
                                  ],
                                ),
                                Spacer(
                                  flex: 1,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 5),
                      width: 20,
                      height: 20,
                      child: Icon(
                        Icons.account_circle,
                        size: 35,
                        color: Color(0xFF00BF63),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

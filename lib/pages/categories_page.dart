import 'dart:convert';

import 'package:akhbari/pages/signin_page.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:akhbari/api/modelApi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xen_popup_card/xen_card.dart';
import '../widgets/utilties/custom_tag.dart';
import '../widgets/utilties/image_container.dart';
import 'all_news_page.dart';
import 'home_page.dart';
import 'news_page.dart';

XenCardAppBar appBar1 = const XenCardAppBar(
  child: Text(
    "Add New Category",
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
  ),
  shadow: BoxShadow(color: Colors.transparent),
);

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  static const routeName = '/discover';

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<String> tabs = [
    'diverse',
    'economy',
    'culture',
    'politic',
    'technology',
    'internationalnews',
    'sports'
  ];

  bool DiversChoice = true;
  bool EconomyChoice = true;
  bool CultureChoice = true;
  bool PoliticChoice = true;
  bool TechnologyChoice = true;
  bool InternationalChoice = true;
  bool SportsChoice = true;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: tabs.length,
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            SizedBox(height: 10),
            Container(
              height: 50,
              width: double.infinity,
              padding: EdgeInsets.only(left: 0, right: 0),
              margin: EdgeInsets.only(top: 20),
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
            Container(
              margin: EdgeInsets.only(top: 20),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
                child: Text(
                  'Categories',
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: Color(0xff004AAD), fontWeight: FontWeight.w900),
                ),
              ),
            ),
            _CategoryNews(tabs: tabs)
          ],
        ),
        floatingActionButton: DraggableFab(
          securityBottom: 60,
          child: FloatingActionButton(
              mini: true,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (builder) => StatefulBuilder(
                    builder: (BuildContext context,
                        void Function(void Function()) setState) {
                      return Container(
                        padding: EdgeInsets.only(top: 160, bottom: 200),
                        child: XenPopupCard(
                          appBar: appBar1,
                          body: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        EconomyChoice = !EconomyChoice;

                                        if (EconomyChoice == false &&
                                            tabs.contains("economy") == false) {
                                        } else if (EconomyChoice == false &&
                                            tabs.contains("economy") == true) {
                                          super.setState(() {
                                            tabs.remove("economy");
                                          });
                                        } else if (EconomyChoice == true &&
                                            tabs.contains("economy") == false) {
                                          super.setState(() {
                                            tabs.add("economy");
                                          });
                                        } else {}
                                      });
                                    },
                                    child: CustomTag(
                                      backgroundColor: EconomyChoice
                                          ? Color(0xff004AAD).withOpacity(0.8)
                                          : Colors.grey,
                                      children: [
                                        Text(
                                          "Economy",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: Colors.white,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(
                                    flex: 1,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        DiversChoice = !DiversChoice;

                                        if (DiversChoice == false &&
                                            tabs.contains("diverse") == false) {
                                        } else if (DiversChoice == false &&
                                            tabs.contains("diverse") == true) {
                                          super.setState(() {
                                            tabs.remove("diverse");
                                          });
                                        } else if (DiversChoice == true &&
                                            tabs.contains("diverse") == false) {
                                          super.setState(() {
                                            tabs.add("diverse");
                                          });
                                        } else {}
                                      });
                                    },
                                    child: CustomTag(
                                      backgroundColor: DiversChoice
                                          ? Color(0xff004AAD).withOpacity(0.8)
                                          : Colors.grey,
                                      children: [
                                        Text(
                                          "Divers",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: Colors.white,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(
                                    flex: 1,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        SportsChoice = !SportsChoice;

                                        if (SportsChoice == false &&
                                            tabs.contains("sports") == false) {
                                        } else if (SportsChoice == false &&
                                            tabs.contains("sports") == true) {
                                          super.setState(() {
                                            tabs.remove("sports");
                                          });
                                        } else if (SportsChoice == true &&
                                            tabs.contains("sports") == false) {
                                          super.setState(() {
                                            tabs.add("sports");
                                          });
                                        } else {}
                                      });
                                    },
                                    child: CustomTag(
                                      backgroundColor: SportsChoice
                                          ? Color(0xff004AAD).withOpacity(0.8)
                                          : Colors.grey,
                                      children: [
                                        Text(
                                          "Sports",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: Colors.white,
                                              ),
                                        ),
                                      ],
                                    ),
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
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        CultureChoice = !CultureChoice;

                                        if (CultureChoice == false &&
                                            tabs.contains("culture") == false) {
                                        } else if (CultureChoice == false &&
                                            tabs.contains("culture") == true) {
                                          super.setState(() {
                                            tabs.remove("culture");
                                          });
                                        } else if (CultureChoice == true &&
                                            tabs.contains("culture") == false) {
                                          super.setState(() {
                                            tabs.add("culture");
                                          });
                                        } else {}
                                      });
                                    },
                                    child: CustomTag(
                                      backgroundColor: CultureChoice
                                          ? Color(0xff004AAD).withOpacity(0.8)
                                          : Colors.grey,
                                      children: [
                                        Text(
                                          "Culture",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: Colors.white,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(
                                    flex: 1,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        PoliticChoice = !PoliticChoice;

                                        if (PoliticChoice == false &&
                                            tabs.contains("politic") == false) {
                                        } else if (PoliticChoice == false &&
                                            tabs.contains("politic") == true) {
                                          super.setState(() {
                                            tabs.remove("politic");
                                          });
                                        } else if (PoliticChoice == true &&
                                            tabs.contains("politic") == false) {
                                          super.setState(() {
                                            tabs.add("politic");
                                          });
                                        } else {}
                                      });
                                    },
                                    child: CustomTag(
                                      backgroundColor: PoliticChoice
                                          ? Color(0xff004AAD).withOpacity(0.8)
                                          : Colors.grey,
                                      children: [
                                        Text(
                                          "Politic",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: Colors.white,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(
                                    flex: 1,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        TechnologyChoice = !TechnologyChoice;

                                        if (TechnologyChoice == false &&
                                            tabs.contains("technology") ==
                                                false) {
                                        } else if (TechnologyChoice == false &&
                                            tabs.contains("technology") ==
                                                true) {
                                          super.setState(() {
                                            tabs.remove("technology");
                                          });
                                        } else if (TechnologyChoice == true &&
                                            tabs.contains("technology") ==
                                                false) {
                                          super.setState(() {
                                            tabs.add("technology");
                                          });
                                        } else {}
                                      });
                                    },
                                    child: CustomTag(
                                      backgroundColor: TechnologyChoice
                                          ? Color(0xff004AAD).withOpacity(0.8)
                                          : Colors.grey,
                                      children: [
                                        Text(
                                          "Technology",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: Colors.white,
                                              ),
                                        ),
                                      ],
                                    ),
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
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        InternationalChoice =
                                            !InternationalChoice;

                                        if (InternationalChoice == false &&
                                            tabs.contains(
                                                    "internationalnews") ==
                                                false) {
                                        } else if (InternationalChoice ==
                                                false &&
                                            tabs.contains(
                                                    "internationalnews") ==
                                                true) {
                                          super.setState(() {
                                            tabs.remove("internationalnews");
                                          });
                                        } else if (InternationalChoice ==
                                                true &&
                                            tabs.contains(
                                                    "internationalnews") ==
                                                false) {
                                          super.setState(() {
                                            tabs.add("internationalnews");
                                          });
                                        } else {}
                                      });
                                    },
                                    child: CustomTag(
                                      backgroundColor: InternationalChoice
                                          ? Color(0xff004AAD).withOpacity(0.8)
                                          : Colors.grey,
                                      children: [
                                        Text(
                                          "International News",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: Colors.white,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(
                                    flex: 1,
                                  ),
                                  Spacer(
                                    flex: 2,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Spacer(
                                flex: 1,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              backgroundColor: Color(0xFF00BF63),
              child: Icon(
                Icons.filter_alt_outlined,
                color: Colors.white,
              )),
        ),
      ),
    );
  }
}

class _CategoryNews extends StatefulWidget {
  _CategoryNews({
    Key? key,
    required this.tabs,
  }) : super(key: key);

  final List<String> tabs;

  @override
  State<_CategoryNews> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<_CategoryNews> {
  List<NewsMod> characList = [];

  List<NewsMod> characList1 = [];

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
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        TabBar(
          isScrollable: true,
          indicatorColor: Colors.grey,
          tabs: widget.tabs
              .map(
                (tab) => Tab(
                  child: Container(
                    width: 75,
                    child: Center(
                      child: Text(
                        tab,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: TabBarView(
            children: widget.tabs
                .map(
                  (tab) => Column(
                    children: [
                      characList.isEmpty?Container(child: Center(child: Text("Sorry Something Went Wrong! \nRefresh or Try to Log In Again"),),):Expanded(
                        child: ListView.builder(
                          shrinkWrap: false,
                          itemCount: offline?characList.where((element) => element.category == tab)
                              .length:characterList
                              .where((element) => element.category == tab)
                              .length,
                          itemBuilder: ((context, index) {
                            List<NewsMod> charfinal = offline?characList.where((element) => element.category == tab)
                                .toList():characterList
                                .where((element) => element.category == tab)
                                .toList();
                            return Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 140,
                                  margin: const EdgeInsets.only(
                                      right: 5, bottom: 0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        NewsScreen.routeName,
                                        arguments: charfinal[index],
                                      );
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: 140,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          ImageContainer(
                                            width: 120,
                                            height: 120,
                                            imageUrl: charfinal[index]
                                                        .imageurl !=
                                                    "NaN"
                                                ? charfinal[index].imageurl
                                                : "https://images.template.net/wp-content/uploads/2016/03/14124445/Typographic-World-Night-Map-Free.jpg",
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 15, right: 15),
                                            height: 130,
                                            width: 200,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  charfinal[index].title,
                                                  maxLines: 2,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                      ' ${charfinal[index].source}',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12),
                                                    )
                                                  ],
                                                ),
                                                Spacer(
                                                  flex: 1,
                                                ),
                                                Text(
                                                    '${DateTime.now().toUtc().difference(DateTime.parse(charfinal[index].date_time).toUtc()).inHours} hours ago',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF00BF63),
                                                        fontSize: 12)),
                                                SizedBox(
                                                  height: 10,
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
                          }),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

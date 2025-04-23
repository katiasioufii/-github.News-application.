import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xen_popup_card/xen_card.dart';
import 'news_page.dart';
import 'home_page.dart';
import '../api/modelApi.dart';


class AllNews extends StatefulWidget {
  const AllNews({super.key});

  @override
  State<AllNews> createState() => _AllNewsState();
}

class _AllNewsState extends State<AllNews> {
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

  final myController = TextEditingController();

  @override
  void initState() {
    setState(() {
      init();
    });
    super.initState();
    myController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  void _printLatestValue() {
    final text = myController.text;
    //print('Second text field: $text (${text.characters.length})');
  }

  void searchNews(String query) {
    final suggestions = characList.where((element) {
      final title = element.title.toLowerCase();
      final input = query.toLowerCase();

      return title.contains(input);
    }).toList();

    setState(() {
      characList1 = suggestions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
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
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => ExampleApp()));
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
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Akhbari News',
                style: Theme.of(context).textTheme.headline4!.copyWith(
                    fontWeight: FontWeight.bold, color: Color(0xff004AAD)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: myController,
            onChanged: (value) {
              searchNews(value);
            },
            decoration: InputDecoration(
              hintText: 'Search',
              fillColor: Colors.grey.shade200,
              filled: true,
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.grey,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          Expanded(
            child: characList1.isEmpty?Container(child: Center(child: Text("Sorry Something Went Wrong! \nRefresh or Try to Log In Again"),),):ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: characList1.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 110,
                      margin: const EdgeInsets.only(right: 5, bottom: 0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            NewsScreen.routeName,
                            arguments: characList1[index],
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 15, right: 15),
                                height: 100,
                                width: 335,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      characList1[index].title,
                                      textAlign: TextAlign.center,
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
                                          ' ${characList1[index].source}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                        Spacer(
                                          flex: 1,
                                        ),
                                        Text(
                                            '${DateTime.now().difference(DateTime.parse(characList1[index].date_time)).inHours} hours ago',
                                            style: TextStyle(
                                                color: Color(0xFF00BF63),
                                                fontSize: 12)),
                                      ],
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

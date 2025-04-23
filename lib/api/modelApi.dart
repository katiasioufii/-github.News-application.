import 'package:http/http.dart' as http;
import 'dart:async';

class NewsMod {
  String category;
  String date_time;
  String imageurl;
  String source;
  String summary;
  String text;
  String title;
  String url_link;
  NewsMod.fromJson(Map json)
      : category = json['category'],
        date_time = json['date_time'],
        imageurl = json['imageurl'],
        source = json['source'],
        summary = json['summary'],
        text = json['text'],
        title = json['title'],
        url_link = json['url_link'];

  Map toJson() {
    return {
      'category': category,
      'date_time': date_time,
      'imageurl': imageurl,
      'source': source,
      'summary': summary,
      'text': text,
      'title': title,
      'url_link': url_link,
    };
  }
}

List<NewsMod> characterList = [];

class CharacterApi {
  static Future getCharacters() {
    return http.get(Uri.parse(
        "https://c8d3-149-34-244-181.ngrok-free.app/api?Query=katia"));
  }
}

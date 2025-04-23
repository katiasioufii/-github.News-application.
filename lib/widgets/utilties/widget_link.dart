import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkWidget extends StatelessWidget {
  final String url;
  final String text;

  LinkWidget({required this.url, required this.text});

  void _launchURL(BuildContext context) async {
    try {
      await launch(url, forceSafariVC: false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch URL')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _launchURL(context),
      child: Text(
        text,
        style: TextStyle(
          decoration: TextDecoration.underline,
          color: Colors.blue,
        ),
      ),
    );
  }
}

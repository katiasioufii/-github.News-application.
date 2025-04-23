import 'package:flutter/material.dart';
import 'package:akhbari/api/modelApi.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/utilties/custom_tag.dart';
import '../widgets/utilties/image_container.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({Key? key}) : super(key: key);

  static const routeName = '/article';
  @override
  Widget build(BuildContext context) {
    final article = ModalRoute.of(context)!.settings.arguments as NewsMod;
    return ImageContainer(
      width: double.infinity,
      imageUrl: article.imageurl != "NaN"
          ? article.imageurl
          : "https://images.template.net/wp-content/uploads/2016/03/14124445/Typographic-World-Night-Map-Free.jpg",
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: ListView(
          children: [
            _NewsHeadline(article: article),
            _NewsBody(article: article)
          ],
        ),
      ),
    );
  }
}

class _NewsBody extends StatelessWidget {
  const _NewsBody({
    Key? key,
    required this.article,
  }) : super(key: key);

  final NewsMod article;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          CustomTag(
            backgroundColor: Color(0xff004AAD).withOpacity(0.8),
            children: [
              Text(
                "Summary",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            article.summary,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.normal,
                color: Colors.grey.shade700,
                fontSize: 16),
          ),
          const SizedBox(height: 40),
          Text(
            "Original Article",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          SizedBox(
            child: Text(
              article.text,
              softWrap: true,
              maxLines: 50,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(height: 1.5, color: Colors.grey, fontSize: 12),
            ),
          ),
          const SizedBox(height: 180),
        ],
      ),
    );
  }
}

Future<void> _launchUrl(Uri url) async {
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}

class _NewsHeadline extends StatelessWidget {
  _NewsHeadline({
    Key? key,
    required this.article,
  }) : super(key: key);

  final NewsMod article;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 200,
                child: Text(
                  article.title,
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Spacer(
                flex: 1,
              ),
              CustomTag(
                backgroundColor: Color(0xff004AAD).withOpacity(0.8),
                children: [
                  Text(
                    article.category,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomTag(
                    backgroundColor: Color(0xFF00BF63).withOpacity(0.7),
                    children: [
                      Icon(
                        Icons.article_outlined,
                        color: Colors.white,
                        size: 15,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        article.source,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.white, fontSize: 10),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  CustomTag(
                    backgroundColor: Colors.grey.shade200,
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        color: Colors.grey,
                        size: 15,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${DateTime.parse(article.date_time).day}/${DateTime.parse(article.date_time).month}/${DateTime.parse(article.date_time).year}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  CustomTag(
                    backgroundColor: Colors.grey.shade200,
                    children: [
                      const Icon(
                        Icons.timer_outlined,
                        color: Colors.grey,
                        size: 15,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${DateTime.parse(article.date_time).hour}:${DateTime.parse(article.date_time).minute}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  _launchUrl(Uri.parse(article.url_link));
                },
                child: CustomTag(
                  backgroundColor: Colors.grey.shade700,
                  children: [
                    const Icon(
                      Icons.language,
                      color: Colors.white,
                      size: 15,
                    ),
                    const SizedBox(width: 10),
                    Container(
                      child: Text(
                        article.source + " - website",
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontSize: 10, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

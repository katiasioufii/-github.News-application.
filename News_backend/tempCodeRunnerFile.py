response1 = api.news_api(q="", category="technology", language="ar")
    for i in range(0, len(response1["results"])):
        data = data.append({'text': response1["results"][i]['content'] or 'None',
        'title': response1["results"][i]['title'] or 'غير محدد',
        'summary': response1["results"][i]['description'] ,
        'category': response1["results"][i]['category'][0] or 'Unknown',
        'source': response1["results"][i]['source_id'] or 'Un-Identified',
        'date_time': response1["results"][i]['pubDate'] or '2023-01-01 00:00:00',
        'imageurl': response1["results"][i]['image_url'] or 'NaN',
        'url_link': response1["results"][i]['link'] or 'https://www.damascusuniversity.edu.sy/ite/index.php?set=3&lang=1&id=385',
                }, ignore_index=True)
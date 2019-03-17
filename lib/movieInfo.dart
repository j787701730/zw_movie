import 'package:flutter/material.dart';
import 'util.dart';
import 'pageLoading.dart';
import 'package:zw_movie/moviePlay.dart';
import 'moviePhotos.dart';

class MovieInfo extends StatefulWidget {
  final id;
  final title;

  MovieInfo(this.id, this.title);

  @override
  _MovieInfoState createState() => _MovieInfoState(id, title);
}

class _MovieInfoState extends State<MovieInfo> with AutomaticKeepAliveClientMixin{
  final id;
  final title;

  _MovieInfoState(this.id, this.title);

 @override
  bool get wantKeepAlive => true;

  String city = '福州';
  Map info = {};
  String role = '';
  String pubdates = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getInfo();
  }

  _getInfo() {
    ajax('http://api.douban.com/v2/movie/subject/$id?city=$city', (data) {
      String roleTmp = '';
      String pubdateTmp = '';
      if (data['directors'] != null) {
        for (var director in data['directors']) {
          roleTmp += '/${director['name']}(导演)';
        }
      }

      if (data['casts'] != null) {
        for (var cast in data['casts']) {
          roleTmp += '/${cast['name']}(演员)';
        }
      }

      if (data['pubdates'] != null) {
        for (var pubdate in data['pubdates']) {
          pubdateTmp += '$pubdate/';
        }
      }

      setState(() {
        info = data;
        role = roleTmp;
        pubdates = pubdateTmp;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: info.isEmpty
          ? PageLoading()
          : Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: ListView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 6, bottom: 8),
                    child: Text(
                      title,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width - 140,
                        child: Wrap(
                          children: <Widget>[
                            Text(((double.tryParse(info['rating']['stars']) / 10).toString())),
                            Text('  ${info['rating']['average']}'),
                            Text(
                              '  ${info['collect_count']}人评价',
                              style: TextStyle(color: Colors.black26),
                            ),
                            Text('${info['durations']} ${info['genres']} ${info['countries']} $role $pubdates'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Image.network(
                          info['images']['small'],
                          fit: BoxFit.fitWidth,
                        ),
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      '所属频道',
                      style: TextStyle(color: Colors.black38),
                    ),
                  ),
                  Wrap(
                    children: info['tags'].map<Widget>((tab) {
                      return Container(
                        padding: EdgeInsets.only(bottom: 4, right: 8),
                        child: Container(
                          padding: EdgeInsets.only(left: 8, right: 8),
                          height: 30,
                          child: Text(
                            tab,
                            style: TextStyle(fontSize: 12, height: 20 / 12),
                          ),
                          decoration: BoxDecoration(
                              border: Border(
                            top: BorderSide(width: 1, color: Colors.black38),
                            left: BorderSide(width: 1, color: Colors.black38),
                            right: BorderSide(width: 1, color: Colors.black38),
                            bottom: BorderSide(width: 1, color: Colors.black38),
                          )),
                        ),
                      );
                    }).toList(),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 10, top: 15),
                    child: Text(
                      '$title的剧情简介',
                      style: TextStyle(color: Colors.black38),
                    ),
                  ),
                  Container(
                    child: Text(
                      info['summary'],
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 10, top: 15),
                    child: Text(
                      '$title的预告片(${info['trailers'].length})',
                      style: TextStyle(color: Colors.black38),
                    ),
                  ),
                  info['trailers'].isEmpty
                      ? Container(
                          child: Text('无预告片'),
                        )
                      : Container(
                          height: 140,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: info['trailers'].map<Widget>((item) {
                              return Container(
                                padding: EdgeInsets.only(right: 10),
                                width: 200,
                                height: 120,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                                      return new MoviePlay({'url': item['resource_url'], 'title': item['title']});
                                    }));
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        height: 120,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(image: NetworkImage(item['medium']), fit: BoxFit.contain),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.play_circle_outline,
                                            color: Colors.white,
                                            size: 50,
                                          ),
                                        ),
                                      ),
                                      Text('${item['title']}')
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                  Container(
                    padding: EdgeInsets.only(bottom: 10, top: 15),
                    child: Text(
                      '$title的剧照(${info['photos'].length})',
                      style: TextStyle(color: Colors.black38),
                    ),
                  ),
                  info['photos'].isEmpty
                      ? Container(
                          child: Text('无剧照'),
                        )
                      : Container(
                          height: 140,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: info['photos'].map<Widget>((item) {
                              return Container(
                                padding: EdgeInsets.only(right: 10),
                                width: 200,
                                height: 120,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                                      return new MoviePhotos({'id': info['id'], 'title': info['title']});
                                    }));
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        height: 120,
                                        child: Image.network(
                                          item['thumb'],
                                          fit: BoxFit.fitHeight,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                  Container(
                    padding: EdgeInsets.only(bottom: 10, top: 15),
                    child: Text(
                      '$title的短评(${info['comments_count']})',
                      style: TextStyle(color: Colors.black38),
                    ),
                  ),
                  Column(
                    children: info['popular_comments'].map<Widget>((item) {
                      return ListTile(
                        contentPadding: EdgeInsets.only(left: 0, right: 0, bottom: 10),
                        title: Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)), color: Colors.black),
                                      width: 44,
                                      height: 44,
                                      child: ClipOval(
                                        child: Image.network(
                                          item['author']['avatar'],
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(left: 6),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(item['author']['name']),
                                            Text('${item['rating']['value']}'),
                                            Text(
                                              item['created_at'],
                                              style: TextStyle(color: Colors.black38),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: Text(item['content']),
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  Container(
                    child: Text('$title的影评(${info['reviews_count']})'),
                  ),
                  Column(
                    children: info['popular_reviews'].map<Widget>((item) {
                      return ListTile(
                        contentPadding: EdgeInsets.only(left: 0, right: 0, bottom: 10),
                        title: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)), color: Colors.black),
                                      width: 44,
                                      height: 44,
                                      child: ClipOval(
                                        child: Image.network(
                                          item['author']['avatar'],
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(left: 6),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(item['author']['name']),
                                            Text('${item['rating']['value']}'),
//                                            Text(item['created_at'],style: TextStyle(
//                                                color: Colors.black38
//                                            ),)
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: Text(item['title']),
                              ),
                              Container(
                                child: Text(item['summary']),
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
    );
  }
}

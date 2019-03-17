import 'package:flutter/material.dart';
import 'util.dart';
import 'package:zw_movie/pageLoading.dart';
import 'movieContent.dart';
import 'movieInfo.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMovies();
  }

  int start = 0;
  int count = 10;
  String city = '福州';
  List subjects = [];

  _getMovies() {
    ajax('https://api.douban.com/v2/movie/in_theaters?city=$city&start=$start&count=$count', (data) {
      setState(() {
        subjects = data['subjects'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
          child: subjects.isEmpty
              ? PageLoading()
              : ListView(
                  children: subjects.map<Widget>((item) {
                    return ListTile(
                      contentPadding: EdgeInsets.only(left: 10, right: 10),
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                                  return new MovieInfo('${item['id']}', item['title']);
                                }));
                              },
                              child: Image.network(
                                item['images']['small'],
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Text('${item['title']} (${item['original_title']})'),
                                  ),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Text(((double.tryParse(item['rating']['stars']) / 10).toString())),
                                        Text('  ${item['rating']['average']}'),
                                        Text(
                                          '  ${item['collect_count']}人评价',
                                          style: TextStyle(color: Colors.black26),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Text('${item['durations']} ${item['genres']} '),
                                  ),
                                  Container(
                                    child: Wrap(
                                      children: item['directors'].map<Widget>((director) {
                                        return Text('${director['name']}(导演) ');
                                      }).toList(),
                                    ),
                                  ),
                                  Container(
                                    child: Wrap(
                                      children: item['casts'].map<Widget>((cast) {
                                        return Text('${cast['name']}(演员) ');
                                      }).toList(),
                                    ),
                                  ),
                                  Container(
                                    child: Wrap(
                                      children: item['pubdates'].map<Widget>((pubdate) {
                                        return Text('$pubdate(上映) ');
                                      }).toList(),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      subtitle: Container(
                        padding: EdgeInsets.only(top: 8),
                        height: 190,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            Row(
                              children: item['directors'].map<Widget>((director) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                                      return new MovieContent('${director['alt']}', director['name']);
                                    }));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(right: 6),
                                    child: Column(
                                      children: <Widget>[
                                        Image.network(
                                          '${director['avatars']['small']}',
                                          height: 140,
                                          fit: BoxFit.fitHeight,
                                        ),
                                        Text(director['name']),
                                        Text('导演')
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            Row(
                              children: item['casts'].map<Widget>((cast) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                                      return new MovieContent('${cast['alt']}', cast['name']);
                                    }));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(right: 6),
                                    child: Column(
                                      children: <Widget>[
                                        Image.network(
                                          '${cast['avatars']['small']}',
                                          height: 140,
                                          fit: BoxFit.fitHeight,
                                        ),
                                        Text(cast['name']),
                                        Text('演员')
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                )),
    );
  }
}

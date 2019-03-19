import 'package:flutter/material.dart';
import 'pageLoading.dart';
import 'util.dart';
import 'drawStars.dart';

class Reviews extends StatefulWidget {
  final param;

  Reviews(this.param);

  @override
  _ReviewsState createState() => _ReviewsState(param);
}

class _ReviewsState extends State<Reviews> {
  Map param;

  _ReviewsState(this.param);

  int start = 0; // 第几条开始取
  int count = 5; // 要取条数
  List photos = [];
  int page = 0;
  int total = 0;
  List reviews = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getReviews();
  }

  _getReviews() {
    setState(() {
      reviews = [];
    });
    ajax('https://api.douban.com/v2/movie/subject/${param['id']}/reviews?start=$start&count=$count', (data) {
      setState(() {
        reviews = data['reviews'];
        total = data['total'];
      });
    });
  }

  Future<Null> _loadRefresh() async {
    await Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _getReviews();
        return null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${param['title']}短评'),
      ),
      body: reviews.isEmpty
          ? PageLoading()
          : RefreshIndicator(
              child: ListView(
                children: <Widget>[
                  Column(
                    children: reviews.map<Widget>((item) {
                      return ListTile(
                        contentPadding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        title: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(30)), color: Colors.black),
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
//                                            Text('${item['rating']['value']}'),
                                            DrawStars((double.tryParse('${item['rating']['value']}') * 10).toString()),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Offstage(
                          offstage: page == 0 ? true : false,
                          child: RaisedButton(
                            color: Colors.blue,
                            textColor: Colors.white,
                            child: Text('上一页'),
                            onPressed: () {
                              setState(() {
                                page -= 1;
                                start = page * count;
                                _getReviews();
                              });
                            },
                          ),
                        ),
                        Offstage(
                          offstage: (page == 0 || total / count - 1 < page) ? true : false,
                          child: Container(
                            width: 10,
                          ),
                        ),
                        Offstage(
                          offstage: total / count - 1 < page ? true : false,
                          child: RaisedButton(
                            color: Colors.blue,
                            textColor: Colors.white,
                            child: Text('下一页'),
                            onPressed: () {
                              setState(() {
                                page += 1;
                                start = page * count;
                                _getReviews();
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              onRefresh: _loadRefresh,
            ),
    );
  }
}

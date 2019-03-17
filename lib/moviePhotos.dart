import 'package:flutter/material.dart';
import 'util.dart';
import 'pageLoading.dart';

class MoviePhotos extends StatefulWidget {
  final params;

  MoviePhotos(this.params);

  @override
  _MoviePhotosState createState() => _MoviePhotosState(params);
}

class _MoviePhotosState extends State<MoviePhotos> {
  Map params;

  _MoviePhotosState(this.params);

  int start = 0;
  int count = 10;
  List photos = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPhotos();
  }

  _getPhotos() {
    ajax('https://api.douban.com/v2/movie/subject/${params['id']}/photos?start=$start&count=$count', (data) {
      setState(() {
        photos = data['photos'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(params['title']),
      ),
      body: Container(
        child: photos.isEmpty
            ? PageLoading()
            : ListView(
                children: photos.map<Widget>((photo) {
                  return Container(
                    padding: EdgeInsets.only(top: 8),
                    child: Image.network(
                      photo['thumb'],
                      fit: BoxFit.fitWidth,
                    ),
                  );
                }).toList(),
              ),
      ),
    );
  }
}

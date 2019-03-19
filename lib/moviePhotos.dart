import 'package:flutter/material.dart';
import 'util.dart';
import 'pageLoading.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class MoviePhotos extends StatefulWidget {
  final params;

  MoviePhotos(this.params);

  @override
  _MoviePhotosState createState() => _MoviePhotosState(params);
}

class _MoviePhotosState extends State<MoviePhotos> {
  Map params;

  _MoviePhotosState(this.params);

  int start = 0; // 第几条开始取
  int count = 20; // 取到第几条止
  List photos = [];
  int page = 0;
  int total = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPhotos();
  }

  _getPhotos() {
    setState(() {
      photos = [];
    });
    ajax('https://api.douban.com/v2/movie/subject/${params['id']}/photos?start=$start&count=$count', (data) {
      setState(() {
        photos = data['photos'];
        total = data['total'];
      });
    });
  }

  void open(BuildContext context, final int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GalleryPhotoViewWrapper(
                backgroundDecoration: const BoxDecoration(
                  color: Colors.black,
                ),
                imageProviders: photos,
                index: index,
              ),
        ));
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
                children: <Widget>[
                  Column(
                    children: photos.map<Widget>((photo) {
                      return Container(
                        padding: EdgeInsets.only(top: 8),
                        width: MediaQuery.of(context).size.width,
                        child: GestureDetector(
                          onTap: () {
                            open(context, photos.indexOf(photo));
                          },
                          child: Image.network(
                            photo['thumb'],
                            fit: BoxFit.fitWidth,
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
                                start = page * 20;
                                count = (page + 1) * 20 <= total ? (page + 1) * 20 : total;
                                _getPhotos();
                              });
                            },
                          ),
                        ),
                        Offstage(
                          offstage: count < total ? false : true,
                          child: Container(
                            width: 10,
                          ),
                        ),
                        Offstage(
                          offstage: count < total ? false : true,
                          child: RaisedButton(
                            color: Colors.blue,
                            textColor: Colors.white,
                            child: Text('下一页'),
                            onPressed: () {
                              setState(() {
                                page += 1;
                                start = page * 20;
                                count = (page + 1) * 20 <= total ? (page + 1) * 20 : total;
                                _getPhotos();
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}

class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper({
    this.imageProviders,
    this.loadingChild,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.index,
  }) : pageController = PageController(initialPage: index);

  List imageProviders;

  final Widget loadingChild;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int index;
  final PageController pageController;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  int currentIndex;

  @override
  void initState() {
    currentIndex = widget.index;
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: widget.backgroundDecoration,
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: <Widget>[
              PhotoViewGallery(
                scrollPhysics: const BouncingScrollPhysics(),
//                pageOptions: <PhotoViewGalleryPageOptions>[
//                  PhotoViewGalleryPageOptions(
//                    imageProvider: widget.imageProvider,
//                    heroTag: "tag1",
//                  ),
//                  PhotoViewGalleryPageOptions(
//                      imageProvider: widget.imageProvider2,
//                      heroTag: "tag2",
//                      maxScale: PhotoViewComputedScale.contained * 0.3),
//                  PhotoViewGalleryPageOptions(
//                    imageProvider: widget.imageProvider3,
//                    initialScale: PhotoViewComputedScale.contained * 0.8,
//                    minScale: PhotoViewComputedScale.contained * 0.8,
//                    maxScale: PhotoViewComputedScale.covered * 1.1,
//                    heroTag: "tag3",
//                  ),
//                ],
                pageOptions: widget.imageProviders.map<PhotoViewGalleryPageOptions>((item) {
                  return PhotoViewGalleryPageOptions(
                      imageProvider: NetworkImage(item['image']), heroTag: item['thumb']);
                }).toList(),
                loadingChild: widget.loadingChild,
                backgroundDecoration: widget.backgroundDecoration,
                pageController: widget.pageController,
                onPageChanged: onPageChanged,
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Image ${currentIndex + 1}",
                  style: const TextStyle(color: Colors.white, fontSize: 17.0, decoration: null),
                ),
              )
            ],
          )),
    );
  }
}

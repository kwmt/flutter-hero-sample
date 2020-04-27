import 'package:flutter/material.dart';
import 'package:herosample/fade_in_route.dart';
import 'package:herosample/image_view.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedAsset = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Viewer Sample')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            child: Hero(
              tag: "list$index",
              child: _buildItem(context, index, "assets/alpaca.jpg"),
            ),
          );
        });
  }

  Widget _buildItem(BuildContext context, int index, String image) {
    return Material(
      child: InkWell(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Image.asset(
              image,
              fit: BoxFit.contain,
            ),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) {
                return DetailPage(title: "$index", tag: "list$index", image: image);
              },
            ));
          }),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String title;
  final String tag;
  final String image;

  DetailPage({this.title, this.tag, this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(this.title),
        ),
        body: ImageWidget(this.tag, this.image));
  }
}

class ImageWidget extends StatelessWidget {
  final String tag;
  final String image;

  ImageWidget(this.tag, this.image);

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: this.tag,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            child: Image.asset(this.image),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ));
  }
}

class HeroAnimation extends StatelessWidget {
  Widget build(BuildContext context) {
//    timeDilation = 5.0; // 1.0 means normal animation speed.

    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Hero Animation'),
      ),
      body: Center(
        child: PhotoHero(
          photo: 'assets/alpaca.jpg',
          width: 300.0,
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute<void>(builder: (BuildContext context) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Flippers Page'),
                ),
                body: Container(
                  // The blue background emphasizes that it's a new route.
                  color: Colors.lightBlueAccent,
                  padding: const EdgeInsets.all(16.0),
                  alignment: Alignment.topLeft,
                  child: PhotoHero(
                    photo: 'assets/alpaca.jpg',
                    width: 100.0,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              );
            }));
          },
        ),
      ),
    );
  }
}

class PhotoHero extends StatelessWidget {
  const PhotoHero({Key key, this.photo, this.onTap, this.width})
      : super(key: key);

  final String photo;
  final VoidCallback onTap;
  final double width;

  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Hero(
        tag: photo,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Image.asset(
              photo,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

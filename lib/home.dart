import 'dart:math';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

const double VERTICAL_SWIPE_THRESHOLD = 200;
const int TRANSITION_DURATION = 600;
const int CONTAINER_REVERSE_DURATION = 200;
const double CONTAINER_MIN_OPACITY = 0.3;

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
            Navigator.of(context).push(PageRouteBuilder<DetailPage>(
                opaque: false,
                fullscreenDialog: true,
                pageBuilder: (context, animation, secondaryAnimation) {
                  return FadeTransition(
                    opacity: animation,
                    child: DetailPage(
                        title: "$index", tag: "list$index", image: image),
                  );
                },
                transitionDuration:
                    const Duration(milliseconds: TRANSITION_DURATION)));
          }),
    );
  }
}

class DetailPage extends StatefulWidget {
  final String title;
  final String tag;
  final String image;

  DetailPage({this.title, this.tag, this.image});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Offset beginningDragPosition = Offset.zero;
  Offset currentDragPosition = Offset.zero;

  int containerReverseDuration = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(containerBackgroundOpacity),
      child: Listener(
        onPointerDown: _onPointerDown,
        onPointerMove: _onPointerMove,
        onPointerUp: _onPointerUp,
        child: AnimatedContainer(
          duration: Duration(milliseconds: containerReverseDuration),
          transform: containerVerticalTransform,
          child: ImageWidget(this.widget.tag, this.widget.image),
        ),
      ),
    );
  }

  Matrix4 get containerVerticalTransform {
    final Matrix4 translationTransform = Matrix4.translationValues(
      0,
      currentDragPosition.dy,
      0.0,
    );

    return translationTransform;
  }

  double get containerBackgroundOpacity {
    return max(
        1.0 - currentDragPosition.distance * 0.003, CONTAINER_MIN_OPACITY);
  }

  void _onPointerDown(PointerDownEvent event) {
    setState(() {
      containerReverseDuration = 0;
    });
    beginningDragPosition = event.position;
  }

  void _onPointerMove(PointerMoveEvent details) {
    setState(() {
      currentDragPosition = Offset(
        0,
        details.position.dy - beginningDragPosition.dy,
      );
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    print(currentDragPosition.distance);
    if (currentDragPosition.distance < VERTICAL_SWIPE_THRESHOLD) {
      setState(() {
        currentDragPosition = Offset.zero;
        containerReverseDuration = CONTAINER_REVERSE_DURATION;
      });
    } else {
      Navigator.pop(context);
    }
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
          child: Image.asset(this.image),
        ));
  }
}


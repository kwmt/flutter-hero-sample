
import 'package:flutter/material.dart';
import 'package:hierarchical_transition_image/hierarchical_transition_image.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with HierarchicalTransitionSource {
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
          String image = "assets/alpaca.jpg";
          String tag = "list$index";
          return sourceContainer<DetailPage>(
            context,
            tag,
            image,
            DetailPage(tag, image),
          );
        });
  }
}

class DetailPage extends HierarchicalTransitionImageStatefulWidget {
  DetailPage(String tag, String image) : super(tag, image);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends HierarchicalTransitionDestinationState<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return destinationContainer(Container(
        child: Image.asset(this.widget.image)));
  }
}

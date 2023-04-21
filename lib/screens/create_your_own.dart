// ignore_for_file: unnecessary_new

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:remuse_builder/common/AppStrings.dart';
import 'package:remuse_builder/screens/apps_store.dart';
import 'package:remuse_builder/screens/image_editor/editor_page.dart';

class CreateYourOwnPage extends StatefulWidget {
  const CreateYourOwnPage({Key? key}) : super(key: key);

  @override
  State<CreateYourOwnPage> createState() => _CreateYourOwnPageState();
}

class _CreateYourOwnPageState extends State<CreateYourOwnPage> {
  List<String> imageList = [
    'https://pixabay.com/get/55e6d7414f53a514f1dc8460da293276103cdded5b5871_640.jpg',
    'https://pixabay.com/get/54e1d1454b5aad14f1dc8460da293276103cdde25b5871_640.jpg',
    'https://pixabay.com/get/57e8d7414e5aa814f1dc8460da293276103cdded5b5673_640.jpg',
    'https://pixabay.com/get/57e9d0434e52ae14f1dc8460da293276103cdded5b5470_640.jpg',
    'https://pixabay.com/get/54e9d3454f54a514f1dc8460da293276103cdded535678_640.jpg',
    'https://pixabay.com/get/5fe1dd464354b10ff3d89960c62d3f7b163cd6ed5158_640.jpg',
    'https://pixabay.com/get/57e5d3414a50a914f1dc8460da293276103cdded5b5078_640.jpg'
  ];
  List<Widget> example = [
    Container(
      decoration: const BoxDecoration(
          color: Colors.pink,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: const ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        // child: FadeInImage.memoryNetwork(
        //   placeholder: kTransparentImage, image: imageList[index],fit: BoxFit.cover,),
        child: Text('index: 0'),
      ),
    ),
    Container(
      decoration: const BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: const ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        // child: FadeInImage.memoryNetwork(
        //   placeholder: kTransparentImage, image: imageList[index],fit: BoxFit.cover,),
        child: Text('index: 0'),
      ),
    ),
    Container(
      decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: const ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        // child: FadeInImage.memoryNetwork(
        //   placeholder: kTransparentImage, image: imageList[index],fit: BoxFit.cover,),
        child: Text('index: 0'),
      ),
    ),
    Container(
      decoration: const BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: const ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        // child: FadeInImage.memoryNetwork(
        //   placeholder: kTransparentImage, image: imageList[index],fit: BoxFit.cover,),
        child: Text('index: 0'),
      ),
    ),
    Container(
      decoration: const BoxDecoration(
          color: Colors.pink,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: const ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        // child: FadeInImage.memoryNetwork(
        //   placeholder: kTransparentImage, image: imageList[index],fit: BoxFit.cover,),
        child: Text('index: 0'),
      ),
    ),
    Container(
      decoration: const BoxDecoration(
          color: Colors.pink,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: const ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        // child: FadeInImage.memoryNetwork(
        //   placeholder: kTransparentImage, image: imageList[index],fit: BoxFit.cover,),
        child: Text('index: 0'),
      ),
    ),
  ];

  final List<StaggeredTile> _staggeredTiles = const <StaggeredTile>[
    const StaggeredTile.count(2, 2),
    const StaggeredTile.count(2, 2.4),
    const StaggeredTile.count(2, 1.3),
    const StaggeredTile.count(2, 2.8),
    const StaggeredTile.count(2, 2),
    const StaggeredTile.count(2, 2.3),
    const StaggeredTile.count(2, 3),
    const StaggeredTile.count(2, 3.5),
    const StaggeredTile.count(2, 1),
    const StaggeredTile.count(2, 1.2),
    const StaggeredTile.count(2, 2),
    const StaggeredTile.count(2, 1.4),
    const StaggeredTile.count(2, 0.8),
    const StaggeredTile.count(2, 1.5),
    const StaggeredTile.count(2, 3.5),
    const StaggeredTile.count(2, 1.4),
    const StaggeredTile.count(2, 1.2),
    const StaggeredTile.count(2, 1.2),
    const StaggeredTile.count(2, 3.5),
    const StaggeredTile.count(2, 2.7),
    const StaggeredTile.count(2, 2.5),
    const StaggeredTile.count(2, 1.2),
    const StaggeredTile.count(2, 1.2),
  ];
  final List<Widget> _tiles = <Widget>[
    _Example01Tile(Colors.green, 'Custom Size'),
    _Example02Tile(
        Colors.lightBlue, 'Standard Portrait', FontAwesomeIcons.idCard, '4:7\n600X1050'),
    _Example03Tile(Colors.amber, 'Standard Landscape',FontAwesomeIcons.idCard,'7:4\n1050X600'),
    _Example02Tile(Colors.brown, 'Instagram Portrait',FontAwesomeIcons.instagram,'4:5'),
    _Example02Tile(Colors.deepOrange, 'Instagram Square',FontAwesomeIcons.instagram,'1:1'),
    _Example02Tile(Colors.indigo, 'Pinterest Post',FontAwesomeIcons.pinterestP,'3:4'),
    _Example02Tile(Colors.red, 'Instagram Story',FontAwesomeIcons.instagram,'9:16'),
    _Example02Tile(Colors.pink, 'Snapchat Geofilter',FontAwesomeIcons.snapchatGhost,'9:16'),
    _Example03Tile(Colors.purple, 'Cover 3:1',FontAwesomeIcons.twitter,'3:1'),
    _Example03Tile(Colors.blue, 'Twitter Post',FontAwesomeIcons.twitter,'2:1'),
    _Example02Tile(Colors.green, 'Facebook Square',FontAwesomeIcons.facebookF,'1:1'),
    _Example02Tile(Colors.lightBlue, 'Thumbnail',FontAwesomeIcons.youtube,'16:9'),
    _Example03Tile(Colors.amber, 'Background',FontAwesomeIcons.linkedinIn,'4:1'),
    _Example03Tile(Colors.brown, 'Cover 16:9',FontAwesomeIcons.facebookF,'16:9'),
    _Example01Tile(Colors.deepOrange, '1:2'),
    _Example02Tile(Colors.indigo, 'Cinematic 16:9',FontAwesomeIcons.videoCamera,'16:9'),
    _Example03Tile(Colors.red, 'Cover Photo',FontAwesomeIcons.google,'16:9'),
    _Example03Tile(Colors.pink, 'Cover Image 16:9',FontAwesomeIcons.linkedinIn,'16:9'),
    _Example01Tile(Colors.purple, '9:16'),
    _Example01Tile(Colors.blue, '3:4'),
    _Example01Tile(Colors.purple, '5:4'),
    _Example01Tile(Colors.pink, '3:2'),
    _Example01Tile(Colors.blue, '16:9'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text(AppStrings.kWhatYouNeed),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GestureDetector(
                onTap: () {
                  print('Ads');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AppsStorePage()));
                },
                child: Image.asset(
                  'assets/images/Web_Advertising.png',
                  width: 25,
                  height: 25,
                ),
              ),
            ),
          ],
        ),
        // body: Container(
        //   margin: const EdgeInsets.all(20),
        //   child: StaggeredGrid.count(
        //     crossAxisCount: 4,
        //     mainAxisSpacing: 4,
        //     crossAxisSpacing: 4,
        //     children: const [
        //       StaggeredGridTile.count(
        //         crossAxisCellCount: 2,
        //         mainAxisCellCount: 2,
        //         child: Text('index: 0'),
        //       ),
        //       StaggeredGridTile.count(
        //         crossAxisCellCount: 2,
        //         mainAxisCellCount: 1,
        //         child: Text('index: 1'),
        //       ),
        //       StaggeredGridTile.count(
        //         crossAxisCellCount: 1,
        //         mainAxisCellCount: 1,
        //         child: Text('index: 2'),
        //       ),
        //       StaggeredGridTile.count(
        //         crossAxisCellCount: 1,
        //         mainAxisCellCount: 1,
        //         child: Text('index: 3'),
        //       ),
        //       StaggeredGridTile.count(
        //         crossAxisCellCount: 4,
        //         mainAxisCellCount: 2,
        //         child: Text('index: 4'),
        //       ),
        //     ],
        //   ),
        // ),
        // body: Container(
        //   margin: EdgeInsets.all(12),
        //   child: StaggeredGridView.countBuilder(
        //       crossAxisCount: 2,
        //       crossAxisSpacing: 12,
        //       mainAxisSpacing: 12,
        //       itemCount: 10,
        //       itemBuilder: (context, index) {
        //         return Container(
        //           decoration: BoxDecoration(
        //               color: Colors.pink,
        //               borderRadius: BorderRadius.all(Radius.circular(12))),
        //           child: ClipRRect(
        //             borderRadius: BorderRadius.all(Radius.circular(12)),
        //             // child: FadeInImage.memoryNetwork(
        //             //   placeholder: kTransparentImage, image: imageList[index],fit: BoxFit.cover,),
        //             child: Text('index: $index'),
        //           ),
        //         );
        //       },
        //       staggeredTileBuilder: (index) {
        //         return new StaggeredTile.count(1,  1.8);
        //       }),
        // ),
        body: new Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: new StaggeredGridView.count(
              crossAxisCount: 4,
              staggeredTiles: _staggeredTiles,
              children: _tiles,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              padding: const EdgeInsets.all(4.0),
            ))
      // body: Container(margin: const EdgeInsets.all(20),
      //     child: StaggeredGridView.count(crossAxisCount: 4,
      //   mainAxisSpacing: 4,
      //   crossAxisSpacing: 4,
      //   children: [
      //     StaggeredGridTile.count(
      //       crossAxisCellCount: 2,
      //       mainAxisCellCount: 2,
      //       child: Text('index: 0'),
      //     ),
      //     StaggeredGridTile.count(
      //       crossAxisCellCount: 2,
      //       mainAxisCellCount: 1,
      //       child: Text('index: 1'),
      //     ),
      //     StaggeredGridTile.count(
      //       crossAxisCellCount: 1,
      //       mainAxisCellCount: 1,
      //       child: Text('index: 2'),
      //     ),
      //     StaggeredGridTile.count(
      //       crossAxisCellCount: 1,
      //       mainAxisCellCount: 1,
      //       child: Text('index: 3'),
      //     ),
      //     StaggeredGridTile.count(
      //       crossAxisCellCount: 4,
      //       mainAxisCellCount: 2,
      //       child: Text('index: 4'),
      //     ),
      //   ],)),
    );
  }
}

class _Example01Tile extends StatelessWidget {
  _Example01Tile(this.backgroundColor, this.title);

  final Color backgroundColor;
  final String title;

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: backgroundColor,
      child: new InkWell(
        onTap: () {
          print('object');
          // Navigator.push(context, MaterialPageRoute(builder: (context) => const DesignCreate()));
          Navigator.push(context, MaterialPageRoute(builder: (context)=> const EditorPage()));
        },
        child: new Center(
          child: new Padding(
            padding: const EdgeInsets.all(4.0),
            child: new Text(title),
          ),
        ),
      ),
    );
  }
}

class _Example02Tile extends StatelessWidget {
  _Example02Tile(this.backgroundColor, this.title, this.icon, this.subtitle);

  final Color backgroundColor;
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: backgroundColor,
      child: new InkWell(
        onTap: () {
          print('object');
          Navigator.push(context, MaterialPageRoute(builder: (context)=> const EditorPage()));
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon(icon),
              FaIcon(icon,size: 40,),
              Text(
                title,
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Example03Tile extends StatelessWidget {
  _Example03Tile(this.backgroundColor, this.title, this.icon, this.subtitle);

  final Color backgroundColor;
  final String title;
  final IconData icon;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: backgroundColor,
      child: new InkWell(
        onTap: () {
          print('object');
          Navigator.push(context, MaterialPageRoute(builder: (context)=> const EditorPage()));
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Icon(icon),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FaIcon(icon,size: 30,),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      // softWrap: true,
                      // maxLines: 2,
                      style: const TextStyle(fontSize: 17),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

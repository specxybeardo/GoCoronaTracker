import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CovidCard extends StatelessWidget {
  _launchURL() async {
  const url = 'https://www.who.int/emergencies/diseases/novel-coronavirus-2019/events-as-they-happen';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not load $url';
  }
}

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
    child: Image.asset(
      './Assets/images/covid.jpg',
      fit: BoxFit.cover,
    ),
    footer: GestureDetector(
      onTap: ()=>_launchURL(),
          child: GridTileBar(
        backgroundColor: Colors.purple,
        title: Row(
          children: <Widget>[
            Text(
              'WHO Reports',
              style: TextStyle(fontSize: 18),
            ),
            Icon(Icons.arrow_forward)
          ],
        ),
      ),
    ),
        ),
      );
  }
}

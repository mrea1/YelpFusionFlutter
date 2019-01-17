import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:yelp_fusion_flutter/config.dart';
import 'package:yelp_fusion_flutter/data/repository.dart';
import 'package:yelp_fusion_flutter/models/business.dart';
import "package:yelp_fusion_flutter/utils/Utils.dart";
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp(repository: Repository.get()));

class MyApp extends StatelessWidget {
  Repository repository;

  MyApp({Key key, this.repository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.APP_NAME,
      theme: ThemeData(primarySwatch: AppConfig.PRIMARY_COLOR),
      home: Scaffold(
        appBar: AppBar(title: Text(AppConfig.APP_NAME)),
        body: Center(
          child: FutureBuilder<List<Business>>(
            future: repository.getBusinesses(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Center(
                            child: Card(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(padding: const EdgeInsets.all(8.0)),
                                  ListTile(
                                    leading: Image.network(snapshot.data[index].imageUrl, width: 80, height: 80,),
                                    title: Text('${snapshot.data[index].name}'),
                                    subtitle: Text('${snapshot.data[index].distance.toStringAsFixed(2)} distance'),
                                  ),
                                  ButtonTheme.bar(
                                    // make buttons use the appropriate styles for cards
                                    child: ButtonBar(
                                      children: <Widget>[
                                        FlatButton(
                                          child: const Text('WEBSITE'),
                                          onPressed: () {
                                            _launchURL(snapshot.data[index].url);
                                          },
                                        ),
                                        FlatButton(
                                          child: const Text('NAVIGATE'),
                                          onPressed: () {
                                            //todo: launch using google/apple maps
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }));
              } else if (snapshot.hasError) {
                return Padding(padding: const EdgeInsets.symmetric(horizontal: 15.0), child: Text("${snapshot.error}"));
              }

              // By default, show a loading spinner
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

//_launchAddress(double latitude, double longitude) {
//  String destination="30.26715, -97.74306";
//  String googleUrl = 'comgooglemaps://?center=$latitude,$longitude';
//  String appleUrl = 'https://maps.apple.com/?sll=$latitude,$longitude';
//
//  if (await canLaunch(googleUrl)) {
//    print('launching com googleUrl');
//    await launch(googleUrl);
//  } else if (await canLaunch(appleUrl)) {
//    print('launching apple url');
//    await launch(appleUrl);
//  } else {
//    throw 'Could not launch url';
//  }
//}

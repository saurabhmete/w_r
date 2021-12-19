import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

Future<Weather> fetchWeather(http.Client client) async {
  final response = await client.get(Uri.parse(
      'https://www.7timer.info/bin/api.pl?lon=113.17&lat=23.09&product=astro&output=json'));

  Weather weather =
      Weather.fromJson(jsonDecode(response.body) as Map<String, dynamic>);

  return weather;
}

class Dataseries {
  final int timepoint;
  final int cloudcover;
  final int seeing;
  final int transparency;
  final int lifted_index;
  final int rh2m;
  final Wind10m wind10m;
  final int temp2m;
  final String prec_type;

  const Dataseries({
    required this.timepoint,
    required this.cloudcover,
    required this.seeing,
    required this.transparency,
    required this.lifted_index,
    required this.rh2m,
    required this.wind10m,
    required this.temp2m,
    required this.prec_type,
  });

  factory Dataseries.fromJson(Map<String, dynamic> json) {
    return Dataseries(
      timepoint: json['timepoint'] as int,
      cloudcover: json['cloudcover'] as int,
      transparency: json['transparency'] as int,
      lifted_index: json['lifted_index'] as int,
      rh2m: json['rh2m'] as int,
      wind10m: Wind10m.fromJson(json['wind10m']),
      temp2m: json['temp2m'] as int,
      seeing: json['seeing'] as int,
      prec_type: json['prec_type'] as String,
    );
  }
}

class Wind10m {
  late final String direction;
  late final int speed;

  Wind10m({
    required this.direction,
    required this.speed,
  });

  factory Wind10m.fromJson(Map<String, dynamic> json) {
    return Wind10m(
      direction: json['direction'] as String,
      speed: json['speed'] as int,
    );
  }
}

class Weather {
  final String product;
  final String init;
  final List<Dataseries> data;

  Weather({
    required this.product,
    required this.init,
    required this.data,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    List<Dataseries> listOfDataPoints = [];
    List<dynamic> dataseries = json["dataseries"];
    for (var datapoint in dataseries) {
      listOfDataPoints
          .add(Dataseries.fromJson(datapoint as Map<String, dynamic>));
    }
    return Weather(
      product: json['product'] as String,
      init: json['init'] as String,
      data: listOfDataPoints,
    );
  }
}

void main() {
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(

      theme: CupertinoThemeData(
      brightness: Brightness.light,
          textTheme: CupertinoTextThemeData(
              navLargeTitleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,


        // fontSize: 70.0,
      )))
      ,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.cloud_moon_bolt_fill),
              label: 'Weather',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.profile_circled),
              label: 'Profile',
            ),
          ],
        ),
        tabBuilder: (context, i) {
          fetchWeather(http.Client()).then((weather) async {
            Weather weatherDetails = weather;
            return weatherDetails;
          });

          if (i == 0) {
            return CupertinoTabView(
              builder: (context) {
                return CupertinoPageScaffold(
                  navigationBar: const CupertinoNavigationBar(
                    middle: Text('Weather'),
                  ),
                  child: FutureBuilder<Weather>(
                    future: fetchWeather(http.Client()),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('An error has occurred!'),
                        );
                      } else if (snapshot.hasData) {
                        return WeatherDetails(weatherDetails: snapshot.data!);
                      } else {
                        return const Center(
                          child: CupertinoActivityIndicator(),
                        );
                      }
                    },
                  ),
                );
              },
            );
          } else {
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                navigationBar: const CupertinoNavigationBar(
                  middle: Text('Profile'),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 100, 30, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Center(
                        child: CircleAvatar(
                          backgroundImage: AssetImage('assets/DSC_1844.JPG'),
                          radius: 70,
                        ),
                      ),
                      const Divider(
                        height: 40,
                      ),
                      const Text('Saurabh Sanjay Mete',
                          style: TextStyle(
                              color: Colors.indigo,
                              fontSize: 30,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Row(
                        children: const <Widget>[
                          Text('Nationality:',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                          SizedBox(width: 10),
                          Text('Indian',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 20,
                              )),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: const <Widget>[
                          Icon(
                            Icons.phone,
                            color: Colors.indigo,
                          ),
                          SizedBox(width: 10),
                          Text('(+49) 1785799833',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 20,
                              )),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: const <Widget>[
                          Text('Date of Birth:',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                          SizedBox(width: 10),
                          Text('11/06/1997',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 20,
                              )),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: const <Widget>[
                          Text('Gender:',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                          SizedBox(width: 10),
                          Text('Male',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 20,
                              )),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        children: const <Widget>[
                          Icon(
                            Icons.email,
                            color: Colors.indigo,
                          ),
                          SizedBox(width: 10),
                          Text('Email address:',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                          SizedBox(width: 10),
                          Text('metesaurabh@gmail.com',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 20,
                              )),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        children: const <Widget>[
                          Icon(
                            Icons.location_pin,
                            color: Colors.indigo,
                          ),
                          SizedBox(width: 10),
                          Text('Address:',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                          SizedBox(width: 10, height: 10),
                          Text('Brackeler Str. 2, 44145 Dortmund (Germany)',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 20,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            });
          }
        });
  }
}

class WeatherDetails extends StatelessWidget {
  const WeatherDetails({Key? key, required this.weatherDetails})
      : super(key: key);

  final Weather weatherDetails;

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var hour = now.hour;
    var nearestTime = 0;
    List<Dataseries> dataPointsList = weatherDetails.data;
    if (hour % 3 == 0) {
      nearestTime = hour;
    } else if (hour % 3 == 1) {
      nearestTime = hour - 1;
    } else {
      nearestTime = hour - 2;
    }
    List<Dataseries> tempThereAfter = [];
    List<Dataseries> todayTemp = [];
    List<Dataseries> tomorrowTemp = [];
    List<Dataseries> dayAfterTemp = [];
    Dataseries currentTempDetails = dataPointsList[nearestTime ~/ 3];

    for (int k = nearestTime ~/ 3; k < dataPointsList.length; k++) {
      tempThereAfter.add(dataPointsList[k]);
    }

    for (int i = 0; i < tempThereAfter.length; i++) {
      if (tempThereAfter[i].timepoint <= 24) {
        todayTemp.add(tempThereAfter[i]);
      } else if (tempThereAfter[i].timepoint > 24 &&
          tempThereAfter[i].timepoint <= 48) {
        tomorrowTemp.add(tempThereAfter[i]);
      } else {
        dayAfterTemp.add(tempThereAfter[i]);
      }
    }

    String currentCloud = "";
    String precipitation = "";
    IconData cloudIcon = Icons.cloud;
    if (currentTempDetails.cloudcover > 6) {
      currentCloud = "Cloudy";
      cloudIcon = Icons.cloud;
    } else if (currentTempDetails.cloudcover <= 6 &&
        currentTempDetails.cloudcover > 3) {
      currentCloud = "Shadowy";
      cloudIcon = Icons.cloud_outlined;
    } else {
      currentCloud = "Clear";
      cloudIcon = Icons.wb_sunny;
    }

    if (currentTempDetails.prec_type == "rain") {
      precipitation = "Rains";
    } else {
      precipitation = "Low chances of Rains";
    }

    return CupertinoPageScaffold(
      child: CupertinoButton(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 105, 10, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: const <Widget>[
                  Icon(
                    Icons.location_pin,
                    size: 40,
                  ),
                  Text(
                    'Hamburg',
                    style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 32,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Center(
                child: Text(
                  currentTempDetails.temp2m.toString() + "\u2103",
                  style: const TextStyle(
                      color: Colors.indigo,
                      fontSize: 140,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Wrap(
                children: <Widget>[
                  Center(
                    child: Icon(
                      cloudIcon,
                      size: 50,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Center(
                    child: Text(
                      currentCloud,
                      style: const TextStyle(
                        color: Colors.indigo,
                        fontSize: 50,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Wrap(
                children: <Widget>[
                  const Center(
                    child: Icon(
                      Icons.grain,
                      size: 50,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Center(
                    child: Text(
                      precipitation,
                      style:
                          const TextStyle(color: Colors.indigo, fontSize: 30),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        onPressed: () {
          Navigator.of(context).push(
            CupertinoPageRoute(builder: (context) {
              return DetailScreen(
                  'Weather', todayTemp, tomorrowTemp, dayAfterTemp);
            }),
          );
        },
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  DetailScreen(this.topic, this.todayTemp, this.tomorrowTemp, this.dayAfterTemp,
      {Key? key})
      : super(key: key);

  final String topic;
  List<Dataseries> todayTemp;
  List<Dataseries> tomorrowTemp;
  List<Dataseries> dayAfterTemp;
  List<String> currentCloud = [];
  List<String> precipitationDetail = [];
  List<String> currentCloudTom = [];
  List<String> precipitationDetailTom = [];
  List<String> currentCloudAfter = [];
  List<String> precipitationDetailAfter = [];
  List<IconData> cloudyIcon = [];
  List<IconData> cloudyIconTom = [];
  List<IconData> cloudyIconAfter = [];
  List<List> allData = [];



  final ScrollController _firstController = ScrollController();

  @override
  Widget build(BuildContext context) {


    for (int i = 0; i < todayTemp.length; i++) {
      if (todayTemp[i].cloudcover > 6) {
        currentCloud.add("Cloudy");
        cloudyIcon.add(Icons.cloud);
      } else if (todayTemp[i].cloudcover <= 6 && todayTemp[i].cloudcover > 3) {
        currentCloud.add("Shadowy");
        cloudyIcon.add(Icons.cloud_outlined);
      } else {
        currentCloud.add("Clear");
        cloudyIcon.add(Icons.wb_sunny);
      }

      if (todayTemp[i].prec_type == "rain") {
        precipitationDetail.add("High");
      } else {
        precipitationDetail.add("Low");
      }
    }
    for (int i = 0; i < tomorrowTemp.length; i++) {
      if (tomorrowTemp[i].cloudcover > 6) {
        currentCloudTom.add("Cloudy");
        cloudyIconTom.add(Icons.cloud);
      } else if (tomorrowTemp[i].cloudcover <= 6 &&
          tomorrowTemp[i].cloudcover > 3) {
        currentCloudTom.add("Shadowy");
        cloudyIconTom.add(Icons.cloud_outlined);
      } else {
        currentCloudTom.add("Clear");
        cloudyIconTom.add(Icons.wb_sunny);
      }

      if (tomorrowTemp[i].prec_type == "rain") {
        precipitationDetailTom.add("High");
      } else {
        precipitationDetailTom.add("Low");
      }
    }

    for (int i = 0; i < dayAfterTemp.length; i++) {
      if (dayAfterTemp[i].cloudcover > 6) {
        currentCloudAfter.add("Cloudy");
        cloudyIconAfter.add(Icons.cloud);
      } else if (dayAfterTemp[i].cloudcover <= 6 &&
          dayAfterTemp[i].cloudcover > 3) {
        currentCloudAfter.add("Shadowy");
        cloudyIconAfter.add(Icons.cloud_outlined);
      } else {
        currentCloudAfter.add("Clear");
        cloudyIconAfter.add(Icons.wb_sunny);
      }

      if (dayAfterTemp[i].prec_type == "rain") {
        precipitationDetailAfter.add("High");
      } else {
        precipitationDetailAfter.add("Low");
      }
    }

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Detailed Weather Forecast'),
      ),
      child: Scrollbar(
        isAlwaysShown: true,
        controller: _firstController,
        child: ListView.builder(
          controller: _firstController,
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(children: <Widget>[Icon(
                  Icons.location_pin,
                  size: 40,
                ),
                  Text(
                    'Hamburg',
                    style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 32,
                        fontWeight: FontWeight.bold),
                  ),],),

                Center(child: Column(
                children: <Widget>[
                Container(
                margin: const EdgeInsets.all(6),
            child: Table(
                    defaultColumnWidth: const FixedColumnWidth(100),
                    children: [
                      TableRow(children: [
                        Column(children: const [
                          Icon(
                            Icons.access_time,
                            size: 24,
                          )
                        ]),
                        Column(children: const [
                          Text('\u2103', style: TextStyle(fontSize: 24)),
                        ]),
                        Column(children: const [
                          Icon(
                            Icons.cloud,
                            size: 24,
                          )
                        ]),
                        Column(children: const [
                          Icon(
                            Icons.grain,
                            size: 24,
                          )
                        ]),
                      ]),
                    ]),),],),),
                Container(
                  color: Colors.indigo,
                  child: const Center(
                    child: Text("Today",
                        style: TextStyle(color: Colors.white, fontSize: 35)),
                  ),
                  // ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(6),
                        child: Table(
                          border: TableBorder(horizontalInside: BorderSide(width: 1, color: Colors.black38, style: BorderStyle.solid)),
                          defaultColumnWidth: const FixedColumnWidth(100),
                          children: [
                            for (int i = 0; i < todayTemp.length; i++)
                              TableRow(children: [
                                Column(children: [
                                  Text(
                                      ((todayTemp[i].timepoint) - 3)
                                              .toString() +
                                          " Hrs",
                                      style: const TextStyle(fontSize: 24))
                                ]),
                                Column(children: [
                                  Text(todayTemp[i].temp2m.toString(),
                                      style: const TextStyle(fontSize: 24))
                                ]),
                                Column(children: <Widget>[
                                  Icon(
                                    cloudyIconAfter[i],
                                    size: 24,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                ]),
                                Column(children: [
                                  Text(precipitationDetail[i],
                                      style: const TextStyle(fontSize: 24))
                                ]),
                              ])
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.indigo,
                  child: const Center(
                    child: Text("Tomorrow",
                        style: TextStyle(color: Colors.white, fontSize: 35)),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(6),
                        child: Table(
                          border: TableBorder(horizontalInside: BorderSide(width: 1, color: Colors.black38, style: BorderStyle.solid)),
                          defaultColumnWidth: const FixedColumnWidth(100),
                          children: [
                            for (int i = 0; i < tomorrowTemp.length; i++)
                              TableRow(children: [
                                Column(children: [
                                  Text(
                                      ((tomorrowTemp[i].timepoint) - 27)
                                              .toString() +
                                          " Hrs",
                                      style: const TextStyle(fontSize: 24))
                                ]),
                                Column(children: [
                                  Text(tomorrowTemp[i].temp2m.toString(),
                                      style: const TextStyle(fontSize: 24))
                                ]),
                                Column(children: <Widget>[
                                  Icon(
                                    cloudyIconAfter[i],
                                    size: 24,
                                  ),
                                ]),
                                Column(children: [
                                  Text(precipitationDetailTom[i],
                                      style: const TextStyle(fontSize: 24))
                                ]),
                              ])
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.indigo,
                  child: const Center(
                    child: Text("Day After Tomorrow",
                        style: TextStyle(color: Colors.white, fontSize: 35)),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(6),
                        child: Table(
                          border: TableBorder(horizontalInside: BorderSide(width: 1, color: Colors.black38, style: BorderStyle.solid)),
                          defaultColumnWidth: const FixedColumnWidth(100),
                          children: [
                            for (int i = 0; i < dayAfterTemp.length; i++)
                              TableRow(children: [
                                Column(children: [
                                  Text(
                                      ((dayAfterTemp[i].timepoint) - 51)
                                              .toString() +
                                          " Hrs",
                                      style: const TextStyle(fontSize: 24))
                                ]),
                                Column(children: [
                                  Text(dayAfterTemp[i].temp2m.toString(),
                                      style: const TextStyle(fontSize: 24))
                                ]),
                                Column(children: <Widget>[
                                  Icon(
                                    cloudyIconAfter[i],
                                    size: 24,
                                  ),
                                ]),
                                Column(children: [
                                  Text(precipitationDetailAfter[i],
                                      style: const TextStyle(fontSize: 24))
                                ]),
                              ])
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

Future<List<Weather>> fetchWeather(http.Client client) async {
  final response = await client
      .get(Uri.parse('http://www.7timer.info/bin/api.pl?lon=113.17&lat=23.09&product=astro&output=json'));

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseWeather, response.body);
}

class Weather {


}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: const CupertinoThemeData(
          textTheme: CupertinoTextThemeData(
            navLargeTitleTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
                // fontSize: 70.0,
        )
      )
      ),
    home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget{
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
      tabBuilder: (context,i) {
        if (i == 0) {
          return CupertinoTabView(
            builder: (context) {
              return CupertinoPageScaffold(
                navigationBar: const CupertinoNavigationBar(
                  middle: Text('Weather'),
                ),


                child: Center(
                  child: CupertinoButton(
                    child: Text(
                      'This is tab $i',
                      style: CupertinoTheme
                          .of(context)
                          .textTheme
                          .actionTextStyle
                          .copyWith(fontSize: 32),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(builder: (context) {
                          return DetailScreen(i == 0 ? 'Weather' : 'Profile');
                        }),
                      );
                    },
                  ),
                ),
              );
            },
          );
        } else {
          return CupertinoTabView(
              builder: (context) {
                return CupertinoPageScaffold(
                    navigationBar: const CupertinoNavigationBar(
                    middle:Text('Profile'),
                ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 100, 30, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:   <Widget>[
                        Center(
                          child: CircleAvatar(
                            backgroundImage: AssetImage('assets/DSC_1844.JPG'),
                            radius: 70,
                          ),
                        ),
                        Divider(
                          height: 40,
                        ),
                        Text('Saurabh Sanjay Mete',
                            style:TextStyle(
                              color: Colors.indigo,
                              fontSize: 30,
                              fontWeight: FontWeight.bold
                            )
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: <Widget>[
                            Text('Nationality:',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )
                            ),
                            SizedBox(width: 10),
                            Text('Indian',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 20,
                            )
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.phone,
                              color: Colors.indigo,
                            ),
                            SizedBox(width: 10),
                            Text('(+49) 1785799833',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 20,
                                )
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            Text('Date of Birth:',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )
                            ),
                            SizedBox(width: 10),
                            Text('11/06/1997',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 20,
                                )
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            Text('Gender:',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )
                            ),
                            SizedBox(width: 10),
                            Text('Male',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 20,
                                )
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Wrap(
                          children: <Widget>[
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
                                )
                            ),
                            SizedBox(width: 10),
                            Text('metesaurabh@gmail.com',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 20,
                                )
                            ),
                          ],
                        ),

                        SizedBox(height: 10),
                        Wrap(
                          children: <Widget>[
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
                                )
                            ),
                            SizedBox(width: 10,height: 10),
                            Text('Brackeler Str. 2, 44145 Dortmund (Germany)',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 20,
                                )
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),

                );


    }
          );
        }
      }
    );

  }
}

class DetailScreen extends StatelessWidget{
  const DetailScreen(this.topic);
  final String topic;
  @override
  Widget build(BuildContext context) {
  return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Details of Weather'),
      ),
          child: Center(
            child: Text('Details for $topic',
            style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle
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
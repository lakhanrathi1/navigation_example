import 'package:flutter/material.dart';
import 'package:navigation_example/car.dart';
import 'package:navigation_example/constants.dart';
import 'package:navigation_example/dbhelper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        '/': (cont) => MyHomePageq(title: "Gogo"),
        Constants.routeName : (cont) => MyHomePage(),
      },
    );
  }
}




class MyHomePage extends StatefulWidget {

  // final String userID;
  // MyHomePage()

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final dbHelper = DatabaseHelper.instance;

  List<Car> cars = [];
  List<Car> carsByName = [];

  //controllers used in insert operation UI
  TextEditingController nameController = TextEditingController();
  TextEditingController milesController = TextEditingController();

  //controllers used in update operation UI
  TextEditingController idUpdateController = TextEditingController();
  TextEditingController nameUpdateController = TextEditingController();
  TextEditingController milesUpdateController = TextEditingController();

  //controllers used in delete operation UI
  TextEditingController idDeleteController = TextEditingController();

  //controllers used in query operation UI
  TextEditingController queryController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _showMessageInScaffold(String message){
    _scaffoldKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(message),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as Map<String,String>;
    var userid = args['id'];

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                text: "Insert",
              ),
              Tab(
                text: "View",
              ),
              // Tab(
              //   text: "Query",
              // ),
              // Tab(
              //   text: "Update",
              // ),
              // Tab(
              //   text: "Delete",
              // ),
            ],
          ),
          title: Text('SQLite'),
        ),
        body: TabBarView(
          children: [
            Center(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(20),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Car Name',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: TextField(
                      controller: milesController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Car Miles',
                      ),
                    ),
                  ),
                  RaisedButton(
                    child: Text('Insert Car Details'),
                    onPressed: () {
                      String name = nameController.text;
                      int miles = int.parse(milesController.text);
                      _insert(name, miles,userid);
                    },
                  ),
                ],
              ),
            ),
            Container(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: cars.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == cars.length) {
                    return RaisedButton(
                      child: Text('Refresh'),
                      onPressed: () {
                        setState(() {
                          _query(userid);
                        });
                      },
                    );
                  }
                  return Container(
                    height: 40,
                    child: Center(
                      child: Text(
                        '[${cars[index].id}] ${cars[index].name} - ${cars[index].miles} miles',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Center(
            //   child: Column(
            //     children: <Widget>[
            //       Container(
            //         padding: EdgeInsets.all(20),
            //         child: TextField(
            //           controller: queryController,
            //           decoration: InputDecoration(
            //             border: OutlineInputBorder(),
            //             labelText: 'Car Name',
            //           ),
            //           onChanged: (text) {
            //             if (text.length >= 2) {
            //               setState(() {
            //                 _query(text);
            //               });
            //             } else {
            //               setState(() {
            //                 carsByName.clear();
            //               });
            //             }
            //           },
            //         ),
            //         height: 100,
            //       ),
            //       Container(
            //         height: 300,
            //         child: ListView.builder(
            //           padding: const EdgeInsets.all(8),
            //           itemCount: carsByName.length,
            //           itemBuilder: (BuildContext context, int index) {
            //             return Container(
            //               height: 50,
            //               margin: EdgeInsets.all(2),
            //               child: Center(
            //                 child: Text(
            //                   '[${carsByName[index].id}] ${carsByName[index].name} - ${carsByName[index].miles} miles',
            //                   style: TextStyle(fontSize: 18),
            //                 ),
            //               ),
            //             );
            //           },
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // Center(
            //   child: Column(
            //     children: <Widget>[
            //       Container(
            //         padding: EdgeInsets.all(20),
            //         child: TextField(
            //           controller: idUpdateController,
            //           decoration: InputDecoration(
            //             border: OutlineInputBorder(),
            //             labelText: 'Car id',
            //           ),
            //         ),
            //       ),
            //       Container(
            //         padding: EdgeInsets.all(20),
            //         child: TextField(
            //           controller: nameUpdateController,
            //           decoration: InputDecoration(
            //             border: OutlineInputBorder(),
            //             labelText: 'Car Name',
            //           ),
            //         ),
            //       ),
            //       Container(
            //         padding: EdgeInsets.all(20),
            //         child: TextField(
            //           controller: milesUpdateController,
            //           decoration: InputDecoration(
            //             border: OutlineInputBorder(),
            //             labelText: 'Car Miles',
            //           ),
            //         ),
            //       ),
            //       RaisedButton(
            //         child: Text('Update Car Details'),
            //         onPressed: () {
            //           int id = int.parse(idUpdateController.text);
            //           String name = nameUpdateController.text;
            //           int miles = int.parse(milesUpdateController.text);
            //           _update(id, name, miles);
            //         },
            //       ),
            //     ],
            //   ),
            // ),
            // Center(
            //   child: Column(
            //     children: <Widget>[
            //       Container(
            //         padding: EdgeInsets.all(20),
            //         child: TextField(
            //           controller: idDeleteController,
            //           decoration: InputDecoration(
            //             border: OutlineInputBorder(),
            //             labelText: 'Car id',
            //           ),
            //         ),
            //       ),
            //       RaisedButton(
            //         child: Text('Delete'),
            //         onPressed: () {
            //           int id = int.parse(idDeleteController.text);
            //           _delete(id);
            //         },
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  void _insert(name, miles,userID) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: name,
      DatabaseHelper.columnMiles: miles
    };
    Car car = Car.fromMap(row);
    final id = await dbHelper.insert(car,userID);
    _showMessageInScaffold('inserted row id: $id');
  }

  void _queryAll() async {
    final allRows = await dbHelper.queryAllRows();
    cars.clear();
    allRows.forEach((row) => cars.add(Car.fromMap(row)));
    _showMessageInScaffold('Query done.');
    setState(() {});
  }

  void _query(name) async {
    final allRows = await dbHelper.queryRows(name);
    cars.clear();
    print(allRows);
    allRows.forEach((row) => cars.add(Car.fromMap(row)));
    print(cars.toString());
    setState(() {

    });
  }

  void _update(id, name, miles) async {
    // row to update
    Car car = Car(id, name, miles);
    final rowsAffected = await dbHelper.update(car);
    _showMessageInScaffold('updated $rowsAffected row(s)');
  }

  void _delete(id) async {
    // Assuming that the number of rows is the id for the last row.
    final rowsDeleted = await dbHelper.delete(id);
    _showMessageInScaffold('deleted $rowsDeleted row(s): row $id');
  }
}



class MyHomePageq extends StatefulWidget {
  const MyHomePageq({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePageq> createState() => _MyHomePageStateq();
}

class _MyHomePageStateq extends State<MyHomePageq> {
  int _counter = 0;

  TextEditingController nameFeild = TextEditingController();
  TextEditingController passwordFeild = TextEditingController();
  bool isVisibale = true;

  void _incrementCounter(String id) {

    Navigator.pushNamed(context, Constants.routeName,arguments: {'id':id});

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(controller: nameFeild,),
            TextFormField(controller: passwordFeild,),
            GestureDetector(
              onTap: (){

                if(nameFeild.text != null && nameFeild.text.length>0 && passwordFeild.text != null && passwordFeild.text.length>0){

                  _incrementCounter(nameFeild.text+"_"+passwordFeild.text);
                  setState(() {

                    isVisibale = false;
                  });


                }else{

                }

              },

              child: Container(
                child:const Text("Submit"),
              ),
            ),

          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (),
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.blue,
      child: TextButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder:(context) => ThirdPage()));
        },
        child: const Text("Next"),
      ),
    );
  }
}

class ThirdPage extends StatelessWidget {
  const ThirdPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
    );
  }
}

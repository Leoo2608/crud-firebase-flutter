import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crud/add.dart';
import 'package:firebase_crud/database.dart';
import 'package:firebase_crud/view.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Database? db;
  List docs = [];
  bool _isLoading = false;

  initdb() {
    print('ola');
    db = Database();
    db!.init();
    db!.read().then((value) => {
          setState(() {
            docs = value;
          })
        });
  }

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  _fetchProducts() async {
    setState(() {
      _isLoading = true;
    });
    await initdb();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[300],
      appBar: AppBar(
        title: Text(
          "Shopping Site",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red[700],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: docs.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => View(
                                        product: docs[index],
                                        db: db,
                                      ))).then((value) => {
                                if (value != null) {_fetchProducts()}
                              });
                        },
                        contentPadding: EdgeInsets.only(right: 30, left: 36),
                        title: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(docs[index]['name'],
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 10,
                            ),
                            Text(docs[index]['brand'], style:TextStyle(fontWeight: FontWeight.w600)),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                        trailing: Text(
                            'S/.' + (docs[index]['price']).toString() + '.00',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0 ))));
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Add(
                        db: db,
                      ))).then((value) => {
                if (value != null) {_fetchProducts()}
              });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
        backgroundColor: Colors.red[700],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

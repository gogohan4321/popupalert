import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class Quiz {
  final String a;
  final String b;
  final String c;
  Quiz(this.a, this.b, this.c);
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

List<Quiz> q = [];
    int _radioValue = 0;
  String _result = "a";
class _MyHomePageState extends State<MyHomePage> {
  List<Quiz> qdis = [];
  final _formkey = GlobalKey<FormState>();
  String intput1;
  String intput2;
  String intput3;
  int currentIndex = 0;
  List<Widget> _children() => [filter1(), filter2(), filter()];
  Future<void> _add() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rewind and remember'),
          content: SingleChildScrollView(
            child: Form(
                key: _formkey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: 'a'),
                      onSaved: (String value) {
                        intput1 = value;
                      },
                    ),
                    radiotype(),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'c'),
                      onSaved: (String value) {
                        intput3 = value;
                      },
                    ),
                    
                  ],
                )),
          ),
          actions: <Widget>[
            RaisedButton(
              child: Text('add'),
              onPressed: () {
                _formkey.currentState.save();
                setState(() {
                  q.insert(0, Quiz(intput1, _result, intput3));
                });
                _formkey.currentState.reset();
                Navigator.of(context).pop();
              },
            ),
            RaisedButton(
              child: Text('cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  final TextEditingController _filter = new TextEditingController();
  final dio = new Dio();
  String _searchText = "";
  List names = new List();
  List filteredNames = new List();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text( 'Search Example' );

  _MyHomePageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = names;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  void initState() {
    this._getNames();
    super.initState();
  }
  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  filter1() {

    if (!(_searchText.isEmpty)) {
      List tempList = new List();
      filteredNames.forEach((item) {
           if (item.b == 'a') {
        if (item.a.toLowerCase().contains(_searchText.toLowerCase())) {
        tempList.add(item);
        }
           }
        }
      );
    
    return ListView.builder(
      itemCount: names == null ? 0 : tempList.length,
      itemBuilder: (BuildContext context, int index) {
        return Quizclass(tempList[index].a, tempList[index].b, tempList[index].c);
      },
    );}
    else{
              List<Quiz> q2 = [];
    q2.addAll(q);
    List<Quiz> qd = [];
    q2.forEach((item) {
      if (item.b == 'a') {
        qd.add(item);
      }
    });
    return ListView.builder(
      itemCount: qd.length,
      itemBuilder: (BuildContext context, int index) {
        return Quizclass(qd[index].a, qd[index].b, qd[index].c);
      },
    );}
  }

  filter2() {
    if (!(_searchText.isEmpty)) {
      List tempList = new List();
      filteredNames.forEach((item) {
           if (item.b == 'b') {
        if (item.a.toLowerCase().contains(_searchText.toLowerCase())) {
        tempList.add(item);
        }
           }
        }
      );
    
    return ListView.builder(
      itemCount: names == null ? 0 : tempList.length,
      itemBuilder: (BuildContext context, int index) {
        return Quizclass(tempList[index].a, tempList[index].b, tempList[index].c);
      },
    );}
    else{
    List<Quiz> q2 = [];
    q2.addAll(q);
    List<Quiz> qd = [];
    q2.forEach((item) {
      if (item.b == 'b') {
        qd.add(item);
      }
    });
    return ListView.builder(
      itemCount: qd.length,
      itemBuilder: (BuildContext context, int index) {
        return Quizclass(qd[index].a, qd[index].b, qd[index].c);
      },
    );}
  }

  filter() {
    if (!(_searchText.isEmpty)) {
      List tempList = new List();
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i].a.toLowerCase().contains(_searchText.toLowerCase())) {
          tempList.add(filteredNames[i]);
        }
      }
      filteredNames = tempList;
    
    return ListView.builder(
      itemCount: names == null ? 0 : filteredNames.length,
      itemBuilder: (BuildContext context, int index) {
        return Quizclass(filteredNames[index].a, filteredNames[index].b, filteredNames[index].c);
      },
    );}
    else{
    return ListView.builder(
      itemCount: q.length,
      itemBuilder: (BuildContext context, int index) {
        return Quizclass(q[index].a, q[index].b, q[index].c);
      },
    );}
  }



  @override
  Widget build(BuildContext context) {
    final List<Widget> children = _children();
    return Scaffold(
      appBar:  _buildBar(context),
      body: children[currentIndex],
      bottomNavigationBar: new Theme(
          data: Theme.of(context).copyWith(
            primaryColor: Colors.blue[700],
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(caption: new TextStyle(color: Colors.black)),
          ),
          child: BottomNavigationBar(
            onTap: onTabTapped,
            currentIndex: currentIndex,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.add),
                title: Text('a'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                title: Text('b'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                title: Text('all'),
              ),
            ],
          )),
    );
  }
  void _getNames() async {
    List tempList = q;
    setState(() {
      names = tempList;
      names.shuffle();
      filteredNames = names;
    });
  }
  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle, 
      actions: <Widget>[
        // action button
        IconButton(
        icon: _searchIcon,
        onPressed: _searchPressed,

      ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            _add();
          },
        ),
      ]);
  }
        
         _buildList() {
    if (!(_searchText.isEmpty)) {
      List tempList = new List();
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i]['a'].toLowerCase().contains(_searchText.toLowerCase())) {
          tempList.add(filteredNames[i]);
        }
      }
      filteredNames = tempList;
    }
    return ListView.builder(
      itemCount: names == null ? 0 : filteredNames.length,
      itemBuilder: (BuildContext context, int index) {
        return Quizclass(filteredNames[index].a, filteredNames[index].b, filteredNames[index].c);
      },
    );
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
            prefixIcon: new Icon(Icons.search),
            hintText: 'Search...'
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text( 'Search Example' );
        filteredNames = names;
        _filter.clear();
      }
    });
  }
}

class Quizclass extends StatelessWidget {
  final String aa;
  final String bb;
  final String cc;

  const Quizclass(
    this.aa,
    this.bb,
    this.cc, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(cc),
        ),
        title: Text(aa),
        subtitle: Text(bb),
      ),
    );
  }
}
class radiotype extends StatefulWidget {
  @override
  _radiotypeState createState() => _radiotypeState();
}

class _radiotypeState extends State<radiotype> {

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          _result = "a";
          break;
        case 1:
          _result = "b";
          break;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
                      new Text("Type : "),
                      Radio(
                        value: 0,
                        groupValue: _radioValue,
                        onChanged: _handleRadioValueChange,
                      ),new Text("a"),
                      Radio(
                        value: 1,
                        groupValue: _radioValue,
                        onChanged: _handleRadioValueChange,
                      ),new Text("b"),
            ])
                      
    );
  }
}

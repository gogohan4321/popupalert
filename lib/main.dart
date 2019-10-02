import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
      home: Home(),
    );
  }
}

int _radioValue = 0;
String input_f_type = 'Meat';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class Quote {
  String Food;
  double Price;
  String Type;
  int Ind;

  Quote(this.Food, this.Price, this.Type, this.Ind);
}

List<Quote> quotes = [];
List<Quote> quotes_filter = [];

class _HomeState extends State<Home> {
  final _formkey = GlobalKey<FormState>();

  static String dropdownValue = 'Meat';
  String selected = "";
  String _input_f_name;
  double _input_f_price;
  int _currentIndex = 0;

  List<Widget> _children() =>
      [filterSearchResults2(), filterSearchResults3(), filterSearchResults()];
  //[filterSearchResults4("Meat"), filterSearchResults4("Dessert"), filterSearchResults4(selected)];
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _alerts() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return buildAlertDialog(context);
        },
      );
    }

    final List<Widget> children = _children();
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
        actions: [
          new IconButton(
            icon: new Icon(Icons.add_circle),
            onPressed: _alerts,
          ),
        ],
      ),
      body: children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            title: Text('Meat'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            title: Text('Dessert'),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.all_out), title: Text('All')),
        ],
      ),
    );
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          input_f_type = "Meat";
          break;
        case 1:
          input_f_type = "Dessert";
          break;
      }
    });
  }

  AlertDialog buildAlertDialog(BuildContext context) {
    return AlertDialog(
      title: Text('Add Food'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Form(
              key: _formkey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    onSaved: (String value) {
                      _input_f_name = value;
                    },
                    // controller: TextEditingController(text: ""),
                    decoration: InputDecoration(
                      labelText: 'Food\'s Name',
                    ),
                  ),
                  TextFormField(
                    onSaved: (String value) {
                      _input_f_price = double.parse(value);
                    },
                    // controller: TextEditingController(text: ""),
                    decoration: InputDecoration(
                        labelText: 'Food\'s Price',
                        hintText: 'number only',
                        focusColor: Colors.blue),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter(
                        RegExp('[0123456789.]'),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Text("Type: "),
                Radiotype(),
              ],
            )
          ],
        ),
      ),
      actions: <Widget>[
        RaisedButton(
          color: Colors.white,
          onPressed: () {
            _formkey.currentState.save();
            setState(() {
              quotes.insert(
                  quotes.length,
                  Quote(_input_f_name, _input_f_price, input_f_type,
                      quotes.length));
              print(_input_f_name);
              print(_input_f_price);
              print(input_f_type);
              print(quotes.length);
            });
            _formkey.currentState.reset();

            filterSearchResults();
            Navigator.of(context).pop();
            // print('$_inputName : $_inputtext');
          },
          child: Text('Add'),
        ),
        RaisedButton(
          color: Colors.white,
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  /*AlertDialog buildAlertDialog2(BuildContext context, int _index) {
    return AlertDialog(
      title: Text('Delete'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[Text("are you sure to delete this food?")],
        ),
      ),
      actions: <Widget>[
        RaisedButton(
          color: Colors.white,
          onPressed: () {
            // print('$_inputName : $_inputtext');
              remove(_index);

            filterSearchResults();
            Navigator.of(context).pop();
          },
          child: Text('Delete'),
        ),
        RaisedButton(
          color: Colors.white,
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
            
          },
        ),
      ],
    );
  }

  AlertDialog buildAlertDialog3(BuildContext context, String food, String price,
      String type, int _index) {
    TextEditingController f = TextEditingController();
    TextEditingController p = TextEditingController();
    TextEditingController t = TextEditingController();
    return AlertDialog(
      title: Text('Edit Food'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Form(
              key: _formkey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    onSaved: (String value) {
                      _input_f_name = value;
                    },
                    //controller: TextEditingController(text: food),
                    controller: f,
                    decoration: InputDecoration(
                      labelText: 'Food\'s Name',
                    ),
                  ),
                  TextFormField(
                    onSaved: (String value) {
                      _input_f_price = double.parse(value);
                    },
                    //controller: TextEditingController(text: price),
                    controller: p,
                    decoration: InputDecoration(
                        labelText: 'Food\'s Price',
                        hintText: 'number only',
                        focusColor: Colors.blue),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter(
                        RegExp('[0123456789.]'),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Text("Type: "),
                Radiotype(),
              ],
            )
          ],
        ),
      ),
      actions: <Widget>[
        RaisedButton(
          color: Colors.white,
          onPressed: () {
            Edit(f.text, double.parse(p.text), input_f_type, _index);
            print(f.text);
            print(p.text);
            print(input_f_type);
            print(quotes.length);
            Navigator.of(context).pop();
            // print('$_inputName : $_inputtext');
          },
          child: Text('Edit'),
        ),
        RaisedButton(
          color: Colors.white,
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }*/

  filterSearchResults() {
    List<Quote> filter_list = [];
    filter_list.addAll(quotes);
    setState(() {
      quotes_filter.clear();
      quotes_filter.addAll(quotes);
    });
    return ListView.builder(
      itemCount: quotes_filter.length,
      itemBuilder: (
        BuildContext context,
        int index,
      ) {
        return ListTile(
          title: QuoteCard(
              filter_list[index].Food,
              (filter_list[index].Price).toString(),
              filter_list[index].Type,
              (filter_list[index].Ind).toString()),
          onTap: () {},
        );
      },
    );
  }

  filterSearchResults2() {
    List<Quote> filter_list = [];
    filter_list.addAll(quotes);

    List<Quote> dummyListData = [];
    filter_list.forEach((item) {
      if (item.Type == "Meat") {
        dummyListData.add(item);
      }
    });
    setState(() {
      quotes_filter.clear();
      quotes_filter.addAll(dummyListData);
    });
    return ListView.builder(
      itemCount: quotes_filter.length,
      itemBuilder: (
        BuildContext context,
        int index,
      ) {
        return ListTile(
          title: QuoteCard(
              dummyListData[index].Food,
              (dummyListData[index].Price).toString(),
              dummyListData[index].Type,
              (dummyListData[index].Ind).toString()),
          onTap: () {},
        );
      },
    );
  }

  filterSearchResults3() {
    List<Quote> filter_list = [];
    filter_list.addAll(quotes);

    List<Quote> dummyListData = [];
    filter_list.forEach((item) {
      if (item.Type == "Dessert") {
        dummyListData.add(item);
      }
    });
    setState(() {
      quotes_filter.clear();
      quotes_filter.addAll(dummyListData);
    });

    return ListView.builder(
      itemCount: quotes_filter.length,
      itemBuilder: (
        BuildContext context,
        int index,
      ) {
        return ListTile(
          title: QuoteCard(
              dummyListData[index].Food,
              (dummyListData[index].Price).toString(),
              dummyListData[index].Type,
              (dummyListData[index].Ind).toString()),
          onTap: () {},
        );
      },
    );
  }
}

class QuoteCard extends StatelessWidget {
  final String _Food;
  final String _Price;
  final String _Type;
  final String _Index;

  const QuoteCard(
    this._Food,
    this._Price,
    this._Type,
    this._Index, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Text("\n$_Type"),
            title: Text("Name : $_Food"),
            subtitle: Row(
              children:<Widget>[
            Text("Price : $_Price  \$"),
            //Text("$_Type",)
            ]),
            trailing: popupmenu2(
                Food: _Food,
                Price: _Price,
                Type: _Type,
                Index: int.parse(_Index)),
            onTap: () {
              //remove(int.parse(_Index));
            },
          ),
        ],
      ),
    );
  }
}

class Radiotype extends StatefulWidget {
  @override
  _RadiotypeState createState() => _RadiotypeState();
}

class _RadiotypeState extends State<Radiotype> {
  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          input_f_type = "Meat";
          break;
        case 1:
          input_f_type = "Dessert";
          break;
      }
    });
  }

  String B_t = 'Meat';
  @override
  Widget build(BuildContext context) {
    return Container(
        child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          new Radio(
            value: 0,
            groupValue: _radioValue,
            onChanged: _handleRadioValueChange,
          ),
          Text("Meat"),
          new Radio(
            value: 1,
            groupValue: _radioValue,
            onChanged: _handleRadioValueChange,
          ),
          Text("Dessert"),
        ]));
  }
}

remove(int _Index) {
  quotes.removeWhere((item) => item.Ind == _Index);
}

Edit(String _Food, double _Price, String _Type, int _Index) {
  quotes[_Index].Food = _Food;
  quotes[_Index].Price = _Price;
  quotes[_Index].Type = _Type;
}

class popupmenu2 extends StatefulWidget {
  final String Food;
  final String Price;
  final String Type;
  final int Index;
  const popupmenu2({Key key, this.Food, this.Price, this.Type, this.Index})
      : super(key: key);

  @override
  _popupmenu2State createState() => _popupmenu2State();
}

class _popupmenu2State extends State<popupmenu2> {
  String Food;
  String Price;
  String Type;
  int Index;
  final _formkey = GlobalKey<FormState>();
  String _input_f_name;
  double _input_f_price;
  _popupmenu2State({this.Food, this.Price, this.Type, this.Index});
  @override
  Widget build(BuildContext context) {
    Future<void> _alerts2() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return buildAlertDialog2(context, widget.Index);
        },
      );
    }

    Future<void> _alerts3() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return buildAlertDialog3(
              context, widget.Food, widget.Price, widget.Type, widget.Index);
        },
      );
    }

    void showMenuSelection(String value) {
      switch (value) {
        case 'Delete':
          _alerts2();
          break;
        case 'Edit':
          _alerts3();
          break;
        // Other cases for other menu options
      }
    }

    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.more_vert),
      onSelected: showMenuSelection,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
            value: 'Edit',
            child: ListTile(leading: Icon(Icons.edit), title: Text('Edit'))),
        const PopupMenuItem<String>(
            value: 'Delete',
            child: ListTile(leading: Icon(Icons.delete), title: Text('Delete')))
      ],
    );
  }

  AlertDialog buildAlertDialog2(BuildContext context, int _index) {
    return AlertDialog(
      title: Text('Delete'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Form(
              key: _formkey,
              child: Column(
                children: <Widget>[
                  Text("are you sure to delete this food?"),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        RaisedButton(
          color: Colors.white,
          onPressed: () {
            // print('$_inputName : $_inputtext');
            _formkey.currentState.save();
            setState(() {
              remove(_index);
              print(_index);
            });
            _formkey.currentState.reset();
            /*Route route = MaterialPageRoute(builder: (context) => Home());
            Navigator.pushReplacement(context, route);*/
            //Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Home()));
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Home()),
              (Route<dynamic> route) => false,
            );
          },
          child: Text('Delete'),
        ),
        RaisedButton(
          color: Colors.white,
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  AlertDialog buildAlertDialog3(BuildContext context, String food, String price,
      String type, int _index) {
    TextEditingController f = TextEditingController();
    TextEditingController p = TextEditingController();
    TextEditingController t = TextEditingController();
    return AlertDialog(
      title: Text('Edit Food'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Form(
              key: _formkey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    onSaved: (String value) {
                      _input_f_name = value;
                    },
                    //controller: TextEditingController(text: food),
                    controller: f,
                    decoration: InputDecoration(
                      labelText: 'Food\'s Name',
                    ),
                  ),
                  TextFormField(
                    onSaved: (String value) {
                      _input_f_price = double.parse(value);
                    },
                    //controller: TextEditingController(text: price),
                    controller: p,
                    decoration: InputDecoration(
                        labelText: 'Food\'s Price',
                        hintText: 'number only',
                        focusColor: Colors.blue),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter(
                        RegExp('[0123456789.]'),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Text("Type: "),
                Radiotype(),
              ],
            )
          ],
        ),
      ),
      actions: <Widget>[
        RaisedButton(
          color: Colors.white,
          onPressed: () {
            Edit(f.text, double.parse(p.text), input_f_type, _index);
            print(f.text);
            print(p.text);
            print(input_f_type);
            print(quotes.length);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Home()),
              (Route<dynamic> route) => false,
            );
            // print('$_inputName : $_inputtext');
          },
          child: Text('Edit'),
        ),
        RaisedButton(
          color: Colors.white,
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

/*class PopUpMenu extends StatelessWidget {
  final String _Food;
  final String _Price;
  final String _Type;
  final int _Index;

  const PopUpMenu(
    this._Food,
    this._Price,
    this._Type,
    this._Index, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> _alerts2() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return _HomeState().buildAlertDialog2(context, _Index);
        },
      );
    }

    Future<void> _alerts3() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return _HomeState()
              .buildAlertDialog3(context, _Food, _Price, _Type, _Index);
        },
      );
    }

    void showMenuSelection(String value) {
      switch (value) {
        case 'Delete':
          _alerts2();
          break;
        case 'Edit':
          _alerts3();
          break;
        // Other cases for other menu options
      }
    }

    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.more_vert),
      onSelected: showMenuSelection,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
            value: 'Edit',
            child: ListTile(leading: Icon(Icons.edit), title: Text('Edit'))),
        const PopupMenuItem<String>(
            value: 'Delete',
            child: ListTile(leading: Icon(Icons.delete), title: Text('Delete')))
      ],
    );
  }
}*/

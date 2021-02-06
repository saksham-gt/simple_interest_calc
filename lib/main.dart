import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Simple Interest Calculator App",
    home: SIForm(),
    theme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.indigo,
      accentColor: Colors.indigoAccent,
    ),
  ));
}

class SIForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SIFormState();
  }
}

class _SIFormState extends State<SIForm> {
  var _FormKey = GlobalKey<FormState>();
  var _currencies = ['Rupees', 'Dollars', 'Pounds'];
  final _minimum_padding = 5.0;
  var displayResult = '';
  var _currentItemSelected = '';
  @override
  void initState() {
    super.initState();
    _currentItemSelected = _currencies[0];
  }

  TextEditingController principalController = TextEditingController();
  TextEditingController roiController = TextEditingController();
  TextEditingController termController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Simple Interest Calculator"),
      ),
      body: Form(
        key: _FormKey,
        child: Padding(
            padding: EdgeInsets.all(_minimum_padding * 2),
            child: ListView(
              children: <Widget>[
                getImageAsset(),
                Padding(
                    padding: EdgeInsets.only(
                        top: _minimum_padding, bottom: _minimum_padding),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: textStyle,
                      controller:
                          principalController, // to allow the keyboard to have just numerical values
                      validator: (String value) {
                        // ignore: missing_return
                        if (value.isEmpty) {
                          return ("Please enter Principle amount.");
                        }
                        if (double.tryParse(value) == null) {
                          return ("Please enter a valid value.");
                        }
                      },
                      decoration: InputDecoration(
                          labelText: 'Principle',
                          hintText: 'Enter Principle e.g. 12000',
                          labelStyle: textStyle,
                          errorStyle: TextStyle(
                            color: Colors.yellowAccent,
                            fontSize: 15.0,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        top: _minimum_padding, bottom: _minimum_padding),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style:
                          textStyle, // to allow the keyboard to have just numerical values
                      controller: roiController,
                      // ignore: missing_return
                      validator: (String value) {
                        if (value.isEmpty) {
                          return ("Please enter the Rate of Interest");
                        }
                        if (double.tryParse(value) == null) {
                          return ("Please enter a valid value.");
                        }
                      },
                      decoration: InputDecoration(
                          labelText: 'Rate of Interest',
                          hintText: 'in percent',
                          labelStyle: textStyle,
                          errorStyle: TextStyle(
                              color: Colors.yellowAccent, fontSize: 15.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        top: _minimum_padding, bottom: _minimum_padding),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: TextFormField(
                          keyboardType: TextInputType
                              .number, // to allow the keyboard to have just numerical values
                          //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          style: textStyle,
                          controller: termController,
                          // ignore: missing_return
                          validator: (String value) {
                            if (value.isEmpty) {
                              return ("Please enter the term in years.");
                              // ignore: missing_return
                            }
                            if (double.tryParse(value) == null) {
                              return ("Please enter a valid value.");
                            }
                          },

                          decoration: InputDecoration(
                              labelText: 'Term',
                              hintText: 'Time in Years',
                              labelStyle: textStyle,
                              errorStyle: TextStyle(
                                  color: Colors.yellowAccent, fontSize: 15.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        )),
                        Container(
                          width: _minimum_padding * 5,
                        ),
                        Expanded(
                            child: DropdownButton(
                          items: _currencies.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          value: _currentItemSelected,
                          onChanged: (String newValueSelected) {
                            _onDropDownItemSelected(newValueSelected);
                          },
                        ))
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        top: _minimum_padding, bottom: _minimum_padding),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            color: Theme.of(context).accentColor,
                            textColor: Theme.of(context).primaryColorDark,
                            child: Text(
                              "Calculate",
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                if (_FormKey.currentState.validate()) {
                                  this.displayResult = _calculateTotalReturns();
                                }
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text(
                              "Reset",
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                _reset();
                              });
                            },
                          ),
                        ),
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.only(
                      top: _minimum_padding, bottom: _minimum_padding),
                  child: Text(
                    this.displayResult,
                    style: textStyle,
                  ),
                )
              ],
            )),
      ),
    );
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage('images/money.jpg');
    Image image = Image(
      image: assetImage,
      width: 125.0,
      height: 125.0,
    );

    return Container(
      child: image,
      margin: EdgeInsets.all(_minimum_padding * 10),
    );
  }

  void _onDropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
  }

  void _reset() {
    principalController.text = '';
    roiController.text = '';
    termController.text = '';
    displayResult = '';
    _currentItemSelected = _currencies[0];
  }

  String _calculateTotalReturns() {
    double principle = double.parse(principalController.text);
    double roi = double.parse(roiController.text);
    double term = double.parse(termController.text);

    double totaAmountPayable = principle + (principle * roi * term) / 100;
    return ("After $term years, your investment will be worth $totaAmountPayable $_currentItemSelected");
  }
}

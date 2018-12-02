import 'package:flutter/material.dart';

import '../scoped-models/main.dart';
import '../widgets/helpers/ensure-visible.dart';

import 'package:scoped_model/scoped_model.dart';
import '../models/secret.dart';

class AddLinkPage extends StatefulWidget {
  final MainModel model;

  AddLinkPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _AddLinkPageState();
  }
}

class _AddLinkPageState extends State<AddLinkPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _giverFocusNode = FocusNode();
  final _takerFocusNode = FocusNode();
  String _giverId = '';
  String _takerId = '';
  final Map<String, dynamic> _formData = {
    'giver': null,
    'taker': null,
  };

  @override
  initState() {
    widget.model.fetchData();
    super.initState();
  }

  List<DropdownMenuItem> _buildGiverList(model) {
    List<DropdownMenuItem> list = model.secretList.map<DropdownMenuItem>((Secret item) {
      return DropdownMenuItem<String>(
        value: item.id,
        child: SizedBox(
            width: 200.0,
            child: Text(
              item.name,
            )),
      );
    }).toList();
    list.add(DropdownMenuItem<String>(
        value: '',
        child: SizedBox(
            width: 200.0,
            child: Text(
              '',
            )),
      ));
    return list;
  }

  List<DropdownMenuItem> _buildTakerList(model) {
    List<DropdownMenuItem> list = model.secretList.map<DropdownMenuItem>((Secret item) {
      return DropdownMenuItem<String>(
        value: item.id,
        child: SizedBox(
            width: 200.0,
            child: Text(
              item.name,
            )),
      );
    }).toList();
    list.add(DropdownMenuItem<String>(
        value: '',
        child: SizedBox(
            width: 200.0,
            child: Text(
              '',
            )),
      ));
    return list;
  }

  Widget _buildGiver(MainModel model) {
    return EnsureVisibleWhenFocused(
        focusNode: _giverFocusNode,
        child: DropdownButtonFormField(
          items: _buildGiverList(model),
          value: _giverId,
          onChanged: (dynamic value) {
            setState(() {
              _giverId = value;
            });
          },
          decoration: InputDecoration(labelText: 'Choose Giver'),
          onSaved: (dynamic value) {
            _formData['giver'] = value;
          },
        ));
  }

  Widget _buildTaker(MainModel model) {
    return EnsureVisibleWhenFocused(
      focusNode: _takerFocusNode,
      child: DropdownButtonFormField(
        items: _buildTakerList(model),
        value: _takerId,
        onChanged: (dynamic value) {
          setState(() {
            _takerId = value;
          });
        },
        decoration: InputDecoration(labelText: 'Choose Taker'),
        onSaved: (dynamic value) {
          _formData['taker'] = value;
        },
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return widget.model.isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : RaisedButton(
            onPressed: () => _submitForm(context),
            child: Text('Add Link'),
            textColor: Colors.white,
          );
  }

  void _submitForm(BuildContext context) {
    _giverFocusNode.unfocus();
    _takerFocusNode.unfocus();
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    widget.model.addLink(
      _formData['giver'],
      _formData['taker'],
    );
    Navigator.pop(context);
  }

  Widget _buildPageContent(BuildContext context, MainModel model) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            children: <Widget>[
              _buildGiver(model),
              _buildTaker(model),
              SizedBox(
                height: 10.0,
              ),
              _buildSubmitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHome(BuildContext context, MainModel model) {
    Widget content = _buildPageContent(context, model);
    if (model.isLoading) {
      content = Center(
        child: CircularProgressIndicator(),
      );
    }
    return RefreshIndicator(
      onRefresh: model.fetchData,
      child: content,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Add Link'),
          ),
          body: _buildHome(context, model),
        );
      },
    );
  }
}

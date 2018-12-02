import 'package:flutter/material.dart';

import '../scoped-models/main.dart';
import '../widgets/helpers/ensure-visible.dart';

import 'package:scoped_model/scoped_model.dart';

class HomePage extends StatefulWidget {
  final MainModel model;

  HomePage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameFocusNode = FocusNode();
  final _wishFocusNode = FocusNode();
  final Map<String, dynamic> _formData = {
    'name': null,
    'wish': null,
  };

  @override
  initState() {
    widget.model.fetchData();
    super.initState();
  }

  Widget _buildAdmin(MainModel model) {
    return model.isAdmin || model.isSuperadmin
        ? IconButton(
            icon: Icon(Icons.star),
            onPressed: () {
              Navigator.pushNamed(context, '/admin');
            },
          )
        : Container();
  }

  Widget _buildNameTextField(MainModel model) {
    return EnsureVisibleWhenFocused(
      focusNode: _nameFocusNode,
      child: TextFormField(
        focusNode: _nameFocusNode,
        initialValue: model.secret == null ? '' : model.secret.name,
        decoration: InputDecoration(labelText: 'Name'),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Name cannot be blank.';
          }
        },
        onSaved: (String value) {
          _formData['name'] = value;
        },
      ),
    );
  }

  Widget _buildWishTextField(MainModel model) {
    return EnsureVisibleWhenFocused(
      focusNode: _wishFocusNode,
      child: TextFormField(
        focusNode: _wishFocusNode,
        maxLines: 4,
        initialValue: model.secret == null ? '' : model.secret.wish,
        decoration: InputDecoration(labelText: 'Wish'),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Wish cannot be blank.';
          }
        },
        onSaved: (String value) {
          _formData['wish'] = value;
        },
      ),
    );
  }

  Widget _buildNameText(MainModel model) {
    return model.theirSecret == null
        ? Container()
        : Column(
            children: <Widget>[
              ListTile(
                title: Text(model.theirSecret.name),
                subtitle: Text(model.theirSecret.wish),
                // trailing: _buildEditButton(context, index, model),
              )
            ],
          );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return widget.model.isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : RaisedButton(
            onPressed: () => _submitForm(context),
            child: Text('Save'),
            textColor: Colors.white,
          );
  }

  void _submitForm(BuildContext context) {
    _nameFocusNode.unfocus();
    _wishFocusNode.unfocus();
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    widget.model
        .addSecret(
          _formData['name'],
          _formData['wish'],
        )
        .then((bool res) => Scaffold.of(context).showSnackBar(SnackBar(
              duration: Duration(seconds: 1),
              content: Text(
                  res ? "Successfully Saved!" : "Error: Something went wrong!"),
            )));
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
              _buildNameTextField(model),
              _buildWishTextField(model),
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

  Widget _buildPageContent2(BuildContext context, MainModel model) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        children: <Widget>[
          _buildNameText(model),
        ],
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

  Widget _buildHome2(BuildContext context, MainModel model) {
    Widget content = _buildPageContent2(context, model);
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Secret Santa'),
        actions: <Widget>[
          ScopedModelDescendant(
          builder: (BuildContext context, Widget child, MainModel model) {
        return _buildAdmin(model);
      })
          ,
        ],
      ),
      body: ScopedModelDescendant(
          builder: (BuildContext context, Widget child, MainModel model) {
        return model.linksDrawn
            ? _buildHome2(context, model)
            : _buildHome(context, model);
      }),
    );
  }
}

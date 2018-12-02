import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import './secrets.dart';
import './links.dart';
import './utilities.dart';
import '../scoped-models/main.dart';

class AdminPage extends StatelessWidget {

  Widget _buildController(MainModel model){
    return model.isSuperadmin ? DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Admin'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: 'Secrets',
              ),
              Tab(
                text: 'Links',
              ),
              Tab(
                text: 'Utilities',
              )
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            SecretsPage(model),
            LinksPage(model),
            UtilitiesPage(model),
          ],
        ),
      ),
    ) : 
    DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Admin'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: 'Secrets',
              ),
              Tab(
                text: 'Utilities',
              )
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            SecretsPage(model),
            UtilitiesPage(model),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(builder: (BuildContext context, Widget child, MainModel model){
      return _buildController(model);
    },);
  }
}

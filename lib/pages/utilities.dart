import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main.dart';

class UtilitiesPage extends StatefulWidget {
  final MainModel model;

  UtilitiesPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _UtilitiesPageState();
  }
}

class _UtilitiesPageState extends State<UtilitiesPage> {
  @override
  initState() {
    widget.model.fetchData();
    super.initState();
  }

  Widget _buildResetButton(MainModel model) {
    return RaisedButton(
      onPressed: () {
        model.resetLinks();
      },
      child: Text('Reset'),
    );
  }

  Widget _buildDrawButton(MainModel model) {
    return RaisedButton(
      onPressed: () {
        model.drawLinks();
      },
      child: Text('Draw Links'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return RefreshIndicator(
          onRefresh: model.fetchData,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              model.isSuperadmin
                  ? RaisedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/addlink');
                      },
                      child: Text('Add Link'),
                    )
                  : Container(),
              Divider(),
              model.linksDrawn
                  ? model.isSuperadmin ? _buildResetButton(model) : Container()
                  : _buildDrawButton(model),
            ],
          ));
    });
  }
}

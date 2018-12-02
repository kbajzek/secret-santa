import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main.dart';

class SecretsPage extends StatefulWidget {
  final MainModel model;

  SecretsPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _SecretsPageState();
  }
}

class _SecretsPageState extends State<SecretsPage> {
  @override
  initState() {
    widget.model.fetchData();
    super.initState();
  }

  // Widget _buildEditButton(BuildContext context, int index, MainModel model) {
  //   return IconButton(
  //         icon: Icon(Icons.edit),
  //         onPressed: () {
  //           model.selectProduct(model.allProducts[index].id);
  //           Navigator.of(context).push(
  //             MaterialPageRoute(
  //               builder: (BuildContext context) {
  //                 return ProductEditPage();
  //               },
  //             ),
  //           ).then((_) {
  //             model.selectProduct(null);
  //           });
  //         },
  //       );
  // }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return RefreshIndicator(
        onRefresh: model.fetchData,
        child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: <Widget>[
                  ListTile(
                    title: Text(model.secretList[index].name),
                    subtitle: Text(model.secretList[index].wish),
                    // trailing: _buildEditButton(context, index, model),
                  ),
                  Divider(),
                ],
              );
            },
            itemCount: model.secretList.length),
      );
    });
  }
}

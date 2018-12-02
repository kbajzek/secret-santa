import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main.dart';

class LinksPage extends StatefulWidget {
  final MainModel model;

  LinksPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _LinksPageState();
  }
}

class _LinksPageState extends State<LinksPage> {
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
              return Dismissible(
                key: Key(model.secretLinkList[index].giverId),
                direction: DismissDirection.endToStart,
                onDismissed: (DismissDirection direction) {
                  if (direction == DismissDirection.endToStart) {
                    model.deleteLink(model.secretLinkList[index].giverId, index);
                  }
                },
                background: Container(
                  color: Colors.red,
                ),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(model.secretLinkList[index].giverName +
                          ' => ' +
                          model.secretLinkList[index].takerName),
                      // trailing: _buildEditButton(context, index, model),
                    ),
                    Divider(),
                  ],
                ),
              );
            },
            itemCount: model.secretLinkList.length),
      );
    });
  }
}

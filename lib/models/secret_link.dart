import 'package:flutter/material.dart';

class SecretLink {
  final String giverId;
  final String takerId;
  final int isTemp;
  final String giverName;
  final String takerName;


  SecretLink({
    @required this.giverId,
    @required this.takerId,
    @required this.isTemp,
    @required this.giverName,
    @required this.takerName,
  });
}

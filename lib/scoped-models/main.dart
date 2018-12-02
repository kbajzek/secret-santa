import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:http/io_client.dart' as ioclient;

import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/secret.dart';
import '../models/secret_link.dart';

class MainModel extends Model {
  //String _link = 'http://10.0.2.2:5000';
  String _link = 'https://kevinbajzek.com';
  bool _isAdmin = false;
  bool _isSuperadmin = false;
  int _appState =
      1; // 1 = add/edit mode, 2 = waiting for drawing, 3 = show draw
  bool _isLoading = false;
  bool _linksDrawn = false;
  String _id;
  Secret _secret;
  Secret _theirSecret;
  List<Secret> _secretList = [];
  List<SecretLink> _secretLinkList = [];

  List<Secret> get secretList {
    return List.of(_secretList);
  }

  List<SecretLink> get secretLinkList {
    return List.of(_secretLinkList);
  }

  Secret get secret {
    if (_secret == null) {
      return null;
    }
    return Secret(id: _secret.id, name: _secret.name, wish: _secret.wish);
  }

  Secret get theirSecret {
    if (_theirSecret == null) {
      return null;
    }
    return Secret(
        id: _theirSecret.id, name: _theirSecret.name, wish: _theirSecret.wish);
  }

  bool get linksDrawn {
    return _linksDrawn;
  }

  bool get isAdmin {
    return _isAdmin;
  }

  bool get isSuperadmin {
    return _isSuperadmin;
  }

  int get appState {
    return _appState;
  }

  bool get isLoading {
    return _isLoading;
  }

  Future<bool> addSecret(String name, String wish) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> secretData = {
      'name': name,
      'wish': wish,
      'id': _id,
    };
    try {
      final http.Response response = await http.post(
          _link + '/secret/add',
          headers: {"Content-Type": "application/json"},
          body: json.encode(secretData));
      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final Map<String, dynamic> responseData = json.decode(response.body);

      _secret = Secret(
        name: name,
        wish: wish,
        id: _id,
      );

      final List<Secret> fetchedSecrets = [];
      responseData['secrets'].forEach((dynamic data) {
        fetchedSecrets.add(Secret(
          id: data['secretId'],
          name: data['name'],
          wish: data['wish'],
        ));
      });
      _secretList = fetchedSecrets;

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      print(error);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> addLink(String giver, String taker) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> linkData = {
      'giver': giver,
      'taker': taker,
    };
    try {
      final http.Response response = await http.post(
          _link + '/link/add',
          headers: {"Content-Type": "application/json"},
          body: json.encode(linkData));
      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<SecretLink> fetchedLinks = [];
      responseData['secretLinks'].forEach((dynamic data) {
        fetchedLinks.add(SecretLink(
          giverId: data['giverId'],
          takerId: data['takerId'],
          isTemp: data['isTemp'],
          giverName: data['giverName'],
          takerName: data['takerName'],
        ));
      });
      _secretLinkList = fetchedLinks;

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      print(error);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteLink(String giver, int index) async {
    _isLoading = true;
    notifyListeners();
    _secretLinkList.removeAt(index);
    final Map<String, dynamic> linkData = {
      'giver': giver,
    };
    try {
      final http.Response response = await http.post(
          _link + '/link/delete',
          headers: {"Content-Type": "application/json"},
          body: json.encode(linkData));
      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<SecretLink> fetchedLinks = [];
      responseData['secretLinks'].forEach((dynamic data) {
        fetchedLinks.add(SecretLink(
          giverId: data['giverId'],
          takerId: data['takerId'],
          isTemp: data['isTemp'],
          giverName: data['giverName'],
          takerName: data['takerName'],
        ));
      });
      _secretLinkList = fetchedLinks;

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      print(error);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> drawLinks() async {
    _isLoading = true;
    notifyListeners();
    try {
      final http.Response response =
          await http.get(_link + '/links/draw');
      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<SecretLink> fetchedLinks = [];
      responseData['secretLinks'].forEach((dynamic data) {
        fetchedLinks.add(SecretLink(
          giverId: data['giverId'],
          takerId: data['takerId'],
          isTemp: data['isTemp'],
          giverName: data['giverName'],
          takerName: data['takerName'],
        ));
      });
      _secretLinkList = fetchedLinks;
      _linksDrawn = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      print(error);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> resetLinks() async {
    _isLoading = true;
    notifyListeners();
    try {
      final http.Response response =
          await http.get(_link + '/links/reset');
      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<SecretLink> fetchedLinks = [];
      responseData['secretLinks'].forEach((dynamic data) {
        fetchedLinks.add(SecretLink(
          giverId: data['giverId'],
          takerId: data['takerId'],
          isTemp: data['isTemp'],
          giverName: data['giverName'],
          takerName: data['takerName'],
        ));
      });
      _secretLinkList = fetchedLinks;
      _linksDrawn = false;
      _theirSecret = null;

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      print(error);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<Null> fetchData() async {
    try {
      _isLoading = true;
      notifyListeners();
      // final HttpClient client = new HttpClient();
      // client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      // final ioclient.IOClient ioClient = ioclient.IOClient(client);

      String uuid;
      final prefs = await SharedPreferences.getInstance();
      uuid = prefs.getString('secretsanta_uuid') ?? 'none';

      await http
          .get(_link + '/info/' + uuid)
          .then<Null>((http.Response response) {
        final Map<String, dynamic> fetchedData = json.decode(response.body);
        if (fetchedData == null) {
          _isLoading = false;
          notifyListeners();
          return;
        }
        _secret = fetchedData['yourSecret'] == null
            ? null
            : Secret(
                id: fetchedData['userId'],
                name: fetchedData['yourSecret']['name'],
                wish: fetchedData['yourSecret']['wish']);
        _theirSecret = fetchedData['theirSecret'] == null
            ? null
            : Secret(
                id: fetchedData['userId'],
                name: fetchedData['theirSecret']['name'],
                wish: fetchedData['theirSecret']['wish']);
        _id = fetchedData['userId'];

        uuid = _id;
        prefs.setString('secretsanta_uuid', uuid);

        _isAdmin = fetchedData['authLevel'] == 2;
        _isSuperadmin = fetchedData['authLevel'] == 3;
        _linksDrawn = fetchedData['secretsDrawn'];

        final List<Secret> fetchedSecrets = [];
        if (fetchedData['secretList'] != null) {
          fetchedData['secretList'].forEach((dynamic data) {
            fetchedSecrets.add(Secret(
              id: data['secretId'],
              name: data['name'],
              wish: data['wish'],
            ));
          });
          _secretList = fetchedSecrets;
        }

        if (fetchedData['secretLinkList'] != null) {
          final List<SecretLink> fetchedLinks = [];
          fetchedData['secretLinkList'].forEach((dynamic data) {
            fetchedLinks.add(SecretLink(
              giverId: data['giverId'],
              takerId: data['takerId'],
              isTemp: data['isTemp'],
              giverName: data['giverName'],
              takerName: data['takerName'],
            ));
          });
          _secretLinkList = fetchedLinks;
        }

        _isLoading = false;
        notifyListeners();
      });
    } catch (err) {
      print(err);
      _isLoading = false;
      notifyListeners();
    }
  }
}

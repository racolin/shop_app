import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:section__8/config/api.dart';
import 'package:section__8/exception/http_exception.dart';

class Auth with ChangeNotifier {
  String _idToken = '';
  String _email = '';
  String _refreshToken = '';
  DateTime? _expiresIn = null;
  String _localId = '';
  bool _registered = false;

  String get token {
    if (_expiresIn != null &&
        _expiresIn!.isAfter(DateTime.now()) &&
        _idToken != '') {
      return _idToken;
    }
    return '';
  }

  String get localId => _localId;

  bool get isAuth => token != '';

  String get idToken => _idToken;

  Future<void> signin(String email, String password) async {
    var res = await http.post(Uri.parse(SIGNIN),
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }));
    var result = json.decode(res.body) as Map<String, dynamic>;
    if (result['error'] != null) {
      throw HttpException(result['error']['message']);
    }
    if (res.statusCode == 200) {
      _idToken = result['idToken'];
      _email = result['email'];
      _refreshToken = result['refreshToken'];
      _expiresIn = DateTime.now().add(
        Duration(
          seconds: int.parse(
            result['expiresIn'],
          ),
        ),
      );
      _localId = result['localId'];
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    var res = await http.post(Uri.parse(LOGIN),
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }));
    var result = json.decode(res.body) as Map<String, dynamic>;
    if (result['error'] != null) {
      throw HttpException(result['error']['message']);
    }
    if (res.statusCode == 200) {
      _idToken = result['idToken'];
      _email = result['email'];
      _refreshToken = result['refreshToken'];
      _expiresIn = DateTime.now().add(
        Duration(
          seconds: int.parse(
            result['expiresIn'],
          ),
        ),
      );
      _localId = result['localId'];
      _registered = result['registered'];
      notifyListeners();
    }
  }

  void logout() {
    _idToken = '';
    _email = '';
    _refreshToken = '';
    _expiresIn = null;
    _localId = '';
    _registered = false;
    notifyListeners();
  }
}

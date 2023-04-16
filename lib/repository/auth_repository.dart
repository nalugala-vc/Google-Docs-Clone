import 'dart:convert';

import 'package:amazonclone/constraints.dart';
import 'package:amazonclone/models/error_model.dart';
import 'package:amazonclone/models/user_model.dart';
import 'package:amazonclone/repository/local_storage_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    googleSignIn: GoogleSignIn(),
    client: Client(),
    localStorageRepository: LocalStorageRepository()));

final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;
  final LocalStorageRepository _localStorageRepository;

  AuthRepository(
      {required GoogleSignIn googleSignIn,
      required Client client,
      required LocalStorageRepository localStorageRepository})
      : _googleSignIn = googleSignIn,
        _client = client,
        _localStorageRepository = localStorageRepository;

  Future<ErrorModel> signInWithGoogle() async {
    ErrorModel error =
        ErrorModel(error: "Some unexpected error occurred", data: null);

    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        print(user.email);
        final userAcc = UserModel(
            email: user.email,
            name: user.displayName ?? '',
            profileURL: user.photoUrl ?? '',
            uid: '',
            token: '');

        var res = await _client.post(Uri.parse('$host/user/signup'),
            body: userAcc.toJson(),
            headers: {'Content-Type': 'application/json; charset=utf-8'});

        var statusCode = res.statusCode;
        var message = res.body;

        print("status code $statusCode");
        print("response $message");

        switch (res.statusCode) {
          case 200:
            final newUser = userAcc.copyWith(
              uid: jsonDecode(res.body)['user']['_id'],
              token: jsonDecode(res.body)['token'],
            );
            error = ErrorModel(error: null, data: newUser);
            _localStorageRepository.setToken(newUser.token);
            break;
          case 403:
            error = ErrorModel(error: "User already Exists", data: null);
            break;
        }
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
      print("catch error: " + e.toString());
    }

    return error;
  }

  Future<ErrorModel> getUserData() async {
    ErrorModel error =
        ErrorModel(error: "Some unexpected error occurred", data: null);

    try {
      String? token = await _localStorageRepository.getToken();

      if (token != null) {
        var res = await _client.get(Uri.parse('$host/user'), headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'x-auth-token': token
        });
        var statusCode = res.statusCode;
        var message = res.body;

        print("status code $statusCode");
        print("response $message");

        switch (res.statusCode) {
          case 200:
            final newUser = UserModel.fromJson(
              jsonEncode(
                jsonDecode(res.body)['user'],
              ),
            ).copyWith(token: token);
            error = ErrorModel(error: null, data: newUser);
            _localStorageRepository.setToken(newUser.token);
            break;
          case 403:
            error = ErrorModel(error: "User already Exists", data: null);
            break;
        }
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
      print("catch error: " + e.toString());
    }

    return error;
  }

  void signOut() async {
    await _googleSignIn.signOut();
    _localStorageRepository.setToken('');
  }
}

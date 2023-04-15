import 'dart:convert';

import 'package:amazonclone/constraints.dart';
import 'package:amazonclone/models/error_model.dart';
import 'package:amazonclone/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

final authRepositoryProvider = Provider(
    (ref) => AuthRepository(googleSignIn: GoogleSignIn(), client: Client()));

final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;

  AuthRepository({required GoogleSignIn googleSignIn, required Client client})
      : _googleSignIn = googleSignIn,
        _client = client;

  Future<ErrorModel> signInWithGoogle() async {
    ErrorModel error =
        ErrorModel(error: "Some unexpected error occurred", data: null);

    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        print(user.email);
        final userAcc = UserModel(
            email: user.email,
            name: user.displayName!,
            profileURL: user.photoUrl!,
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
            );
            error = ErrorModel(error: null, data: newUser);
            break;
        }
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
      print("catch error: " + e.toString());
    }

    return error;
  }
}

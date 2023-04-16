import 'dart:convert';

import 'package:amazonclone/models/document_model.dart';
import 'package:amazonclone/models/error_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import '../constraints.dart';

final documentRepositoryProvier = Provider(
  (ref) => DocumentREpository(
    client: Client(),
  ),
);

class DocumentREpository {
  final Client _client;

  DocumentREpository({required Client client}) : _client = client;

  Future<ErrorModel> createDocument(String token) async {
    ErrorModel error =
        ErrorModel(error: "Some unexpected error occurred", data: null);

    try {
      var res = await _client.post(
        Uri.parse('$host/document/create'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'x-auth-token': token
        },
        body: jsonEncode(
          {
            'createdAt': DateTime.now().millisecondsSinceEpoch,
          },
        ),
      );
      var statusCode = res.statusCode;
      var message = res.body;

      print("status code $statusCode");
      print("response $message");
      print("token $token");

      switch (res.statusCode) {
        case 200:
          error =
              ErrorModel(error: null, data: DocumentModel.fromJson(res.body));
          break;
        case 403:
          error = ErrorModel(error: "User already Exists", data: null);
          break;
        default:
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
      print("catch error: " + e.toString());
    }

    return error;
  }

  Future<ErrorModel> getDocuments(String token) async {
    ErrorModel error =
        ErrorModel(error: "Some unexpected error occurred", data: null);

    try {
      var res = await _client.get(
        Uri.parse('$host/document/mydocs'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'x-auth-token': token
        },
      );
      var statusCode = res.statusCode;
      var message = res.body;

      print("status code $statusCode");
      print("response $message");
      print("token $token");

      switch (res.statusCode) {
        case 200:
          List<DocumentModel> documents = [];

          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            documents.add(
                DocumentModel.fromJson(jsonEncode(jsonDecode(res.body)[i])));
          }
          error = ErrorModel(error: null, data: documents);
          break;
        case 403:
          error = ErrorModel(error: "User already Exists", data: null);
          break;
        default:
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
      print("catch error: " + e.toString());
    }

    return error;
  }
}

import 'package:app_atletica/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String backendUrl = 'localhost:8080';

Future<http.Response> makeHttpRequest(BuildContext context, String endpoint, {String method = 'GET', dynamic body, dynamic parameters}) async {
  Uri url;
  if (parameters != null) {
    url = Uri.http(backendUrl, endpoint, parameters);
  } else {
    url = Uri.http(backendUrl, endpoint);
  }

  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  http.Response response;

  try {
    switch (method.toUpperCase()) {
      case 'POST':
        response = await http.post(url, headers: headers, body: body);
        break;
      case 'PUT':
        response = await http.put(url, headers: headers, body: body);
        break;
      case 'DELETE':
        response = await http.delete(url, headers: headers, body: body);
        break;
      case 'GET':
      default:
        response = await http.get(url, headers: headers);
        break;
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else if (response.statusCode == 401 && url.path != '/api/login') {
      
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: const Text('Sessão expirada ou token inválido, faça login novamente.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      // Navigate to login page after dialog is closed
      await Navigator.of(context)
        .pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => LoginScreen()
          ), (Route<dynamic> route) => false
        );
        
      throw Exception('Unauthorized');
    }else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  } catch (e) {
    print('Error making HTTP request: $e');
    rethrow;
  }
}

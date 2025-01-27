import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'api_response.dart';
import 'dart:convert';
import 'get_storage.dart';

class Api extends GetConnect {
  final String baseUrl = Platform.isAndroid? 'http://10.0.2.2:3000/' : 'http://127.0.0.1:3000/';

  Future<dynamic> getRequest(String endpoint) async {
    var token = StorageService.getToken();
    final response = await http.get(Uri.parse("$baseUrl$endpoint"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        });
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decodedBody = utf8.decode(response.bodyBytes);
      return ApiResponse(success: true, data: jsonDecode(decodedBody));
    } else if (response.statusCode == 403 || response.statusCode == 401){
      await refreshToken();
      token = StorageService.getToken();
      final response = await http.get(Uri.parse("$baseUrl$endpoint"),
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json"
          });
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decodedBody = utf8.decode(response.bodyBytes);
        return ApiResponse(success: true, data: jsonDecode(decodedBody));
      }
      else {
        return ApiResponse(success: false, message:  "${response.statusCode}");
      }
    }
    else {
      return ApiResponse(success: false, message:  "${response.statusCode}");
    }
  }

  Future<dynamic> postRequest(String endpoint, dynamic body) async {
    var token = StorageService.getToken();
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    http.Response response;

    try {
      if (body != null) {
        // Include body only if it's not null
        response = await http.post(
          Uri.parse("$baseUrl$endpoint"),
          headers: headers,
          body: jsonEncode(body),
        );
      } else {
        // No body in the request
        response = await http.put(
          Uri.parse("$baseUrl$endpoint"),
          headers: headers,
        );
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decodedBody = utf8.decode(response.bodyBytes);
        return ApiResponse(success: true, data: jsonDecode(decodedBody));
      } else if (response.statusCode == 403 || response.statusCode == 401) {
        // Handle token refresh and retry
        await refreshToken();
        token = StorageService.getToken();
        return postRequest(endpoint, body); // Retry after refreshing token
      } else {
        return ApiResponse(success: false, message: "${response.statusCode}");
      }
    } catch (e) {
      return ApiResponse(success: false, message: "An error occurred: $e");
    }
  }


  Future<dynamic> putRequest(String endpoint, dynamic body) async {
    var token = StorageService.getToken();
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    http.Response response;

    try {
      if (body != null) {
        // Include body only if it's not null
        response = await http.put(
          Uri.parse("$baseUrl$endpoint"),
          headers: headers,
          body: jsonEncode(body),
        );
      } else {
        // No body in the request
        response = await http.put(
          Uri.parse("$baseUrl$endpoint"),
          headers: headers,
        );
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decodedBody = utf8.decode(response.bodyBytes);
        return ApiResponse(success: true, data: jsonDecode(decodedBody));
      } else if (response.statusCode == 408) {
        // Retry logic for timeout
        for (int i = 0; i < 3; i++) {
          Get.snackbar('Response Timeout', 'Please Wait ${i + 1}');
          response = body != null
              ? await http.put(
            Uri.parse("$baseUrl$endpoint"),
            headers: headers,
            body: jsonEncode(body),
          )
              : await http.put(
            Uri.parse("$baseUrl$endpoint"),
            headers: headers,
          );

          if (response.statusCode >= 200 && response.statusCode < 300) {
            final decodedBody = utf8.decode(response.bodyBytes);
            return ApiResponse(success: true, data: jsonDecode(decodedBody));
          }
        }
      } else if (response.statusCode == 403 || response.statusCode == 401) {
        // Handle token refresh and retry
        await refreshToken();
        token = StorageService.getToken();
        return putRequest(endpoint, body); // Retry after refreshing token
      } else {
        return ApiResponse(success: false, message: "${response.statusCode}");
      }
    } catch (e) {
      return ApiResponse(success: false, message: "An error occurred: $e");
    }
  }


  Future<dynamic> deleteRequest(String endpoint) async {
    var token = StorageService.getToken();
    final response = await http.delete(
      Uri.parse("$baseUrl$endpoint"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decodedBody = utf8.decode(response.bodyBytes);
      return ApiResponse(success: true, data: jsonDecode(decodedBody));
    } else if (response.statusCode == 408) {
      for (int i = 0; i < 3; i++) {
        Get.snackbar('Response Timeout', 'Please Wait${i + 1}');
        final response = await http.delete(
          Uri.parse("$baseUrl$endpoint"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        );
        if (response.statusCode >= 200 && response.statusCode < 300) {
          final decodedBody = utf8.decode(response.bodyBytes);
          return ApiResponse(success: true, data: jsonDecode(decodedBody));
        }
      }
    } else if (response.statusCode == 403 || response.statusCode == 401) {
      await refreshToken();
      token = StorageService.getToken();
      return deleteRequest(endpoint); // Retry after refreshing token
    } else {
      return ApiResponse(success: false, message: "${response.statusCode}");
    }
  }

  Future refreshToken() async {
    final token = StorageService.getRefreshToken();
    final response = await http.post(
      Uri.parse("${baseUrl}refresh"),
      headers: {"Content-Type": "application/json"}, // Ensure JSON format
      body: jsonEncode(<String, String>{
        'refreshToken': token.toString(),
      }),
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      // Get.snackbar('data', '${data['data']['access_token']}');
      StorageService.saveToken(data['data']['accessToken']);
    }
  }

}


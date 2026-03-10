import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as client;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../app_url/app_url.dart';

class ApiService extends GetxService {
  Future<Map<String, dynamic>> fetchCompany(int id, String token) async {
    try {
      final url = Uri.parse('${Api.getCompanyUrl}$id');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // Log the raw response for debugging
      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.body.isEmpty) {
        return {
          'statusCode': response.statusCode,
          'data': null,
          'error': 'Empty response body',
        };
      }

      final responseData = jsonDecode(response.body);
      if (responseData == null) {
        return {
          'statusCode': response.statusCode,
          'data': null,
          'error': 'Null response data',
        };
      }

      return {
        'statusCode': response.statusCode,
        'data': responseData as Map<String, dynamic>,
      };
    } catch (e) {
      print('API Error: $e');
      throw Exception('Failed to fetch company: $e');
    }
  }

  Future<Map<String, dynamic>> fetchCars(String token) async {
    try {
      final url = Uri.parse(Api.getCarsUrl);
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = jsonDecode(response.body);
      return {
        'statusCode': response.statusCode,
        'data': responseData is List<dynamic>
            ? {'cars': responseData}
            : responseData as Map<String, dynamic>,
      };
    } catch (e) {
      throw Exception('Failed to fetch cars: $e');
    }
  }

  Future<Map<String, dynamic>> fetchCompanyCars(String token, int id) async {
    try {
      final url = Uri.parse('${Api.getCompanyUrl}$id/cars/ ');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = jsonDecode(response.body);
      return {
        'statusCode': response.statusCode,
        'cars': responseData is List<dynamic>
            ? {'cars': responseData}
            : responseData as Map<String, dynamic>,
      };
    } catch (e) {
      throw Exception('Failed to fetch cars: $e');
    }
  }

  Future<Map<String, dynamic>> fetchDrivers(String token) async {
    try {
      final url = Uri.parse(Api.getDriversUrl);
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = jsonDecode(response.body);
      return {
        'statusCode': response.statusCode,
        'data': responseData is List<dynamic>
            ? {'drivers': responseData}
            : responseData as Map<String, dynamic>,
      };
    } catch (e) {
      throw Exception('Failed to fetch drivers: $e');
    }
  }

  Future<Map<String, dynamic>> postUserProfile(
      Map<String, dynamic> payload,
      String token,
      ) async {
    try {
      final url = Uri.parse(Api.employeeRequestsUrl);
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      );

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      return {
        'statusCode': response.statusCode,
        'data': responseData,
      };
    } catch (e) {
      throw Exception('Failed to post user profile: $e');
    }
  }
  Future<Map<String, dynamic>> fetchCompanies(String token) async {
    try {
      final response = await http.get(
        Uri.parse(Api.companyNameUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'statusCode': response.statusCode,
          'data': data,
        };
      } else if (response.statusCode == 401) {
        return {
          'statusCode': response.statusCode,
          'data': {'detail': 'Unauthorized: Invalid or expired token'},
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'data': {'detail': 'Failed to fetch companies'},
        };
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Future<Map<String, dynamic>> fetchProfile(String token) async {
  //   try {
  //     print("started 1");
  //     final response = await http.get(
  //       Uri.parse(Api.getProfileUrl),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Content-Type': 'application/json',
  //       },
  //     );
  //     debugPrint('Request: GET ${Api.getProfileUrl}');
  //     debugPrint(
  //       'Headers: {Authorization: Bearer $token, Content-Type: application/json}',
  //     );
  //     debugPrint('Response status: ${response.statusCode}');
  //     debugPrint('Response body: ${response.body}');
  //     final responseData = jsonDecode(
  //       response.body.isNotEmpty ? response.body : '{}',
  //     );
  //     return {'statusCode': response.statusCode, 'data': responseData};
  //   } catch (e) {
  //     debugPrint('API error: $e');
  //     return {
  //       'statusCode': 500,
  //       'data': {'detail': 'Error: $e'},
  //     };
  //   }
  // }
  // Future<Map<String, dynamic>> updateDriverProfileWithPatch(
  //     DriverProfileUpdateRequest request,
  //     Map<String, String> imagePaths, // fieldName -> path, e.g., {'profile_picture': '/path/to/file.jpg'}
  //     String token,
  //     ) async {
  //   final url = Uri.parse(Api.updateDriverProfileUrl); // e.g., '/api/driver/profile/update/'
  //   try {
  //     final multipartRequest = http.MultipartRequest('PATCH', url);
  //     multipartRequest.headers.addAll({
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     });
  //
  //     final jsonData = request.toJson();
  //     for (var entry in jsonData.entries) {
  //       if (entry.value != null && (entry.value is! List || (entry.value as List).isNotEmpty)) {
  //         if (entry.value is List) {
  //           multipartRequest.fields[entry.key] = jsonEncode(entry.value);
  //         } else {
  //           multipartRequest.fields[entry.key] = entry.value.toString();
  //         }
  //       }
  //     }
  //
  //     debugPrint('Serialized fields: ${multipartRequest.fields}');
  //
  //     // Add images with field-specific names
  //     for (var entry in imagePaths.entries) {
  //       final fieldName = entry.key; // e.g., 'profile_picture'
  //       final path = entry.value;
  //       final file = await http.MultipartFile.fromPath(
  //         fieldName, // Use field name as the part name (backend expects this)
  //         path,
  //         filename: path.split('/').last,
  //         contentType: MediaType('image', path.endsWith('.png') ? 'png' : 'jpeg'), // Detect MIME
  //       );
  //       multipartRequest.files.add(file);
  //       debugPrint('Added image for $fieldName: ${file.filename}');
  //     }
  //
  //     debugPrint('Request: PATCH $url');
  //     debugPrint('Headers: ${multipartRequest.headers}');
  //     debugPrint('Files: ${multipartRequest.files.map((f) => '${f.field}: ${f.filename}').toList()}');
  //
  //     final streamedResponse = await multipartRequest.send();
  //     final response = await http.Response.fromStream(streamedResponse);
  //     debugPrint('Response status: ${response.statusCode}');
  //     debugPrint('Response body: ${response.body}');
  //
  //     final responseData = response.body.isNotEmpty ? jsonDecode(response.body) : {};
  //     return {'statusCode': response.statusCode, 'data': responseData};
  //   } catch (e) {
  //     debugPrint('API error in updateDriverProfileWithPatch: $e');
  //     return {
  //       'statusCode': 500,
  //       'data': {'detail': e.toString()},
  //     };
  //   }
  // }
  //
  // Future<Map<String, dynamic>> updateUserProfileWithPatch(
  //     UserProfileUpdateRequest request,
  //     Map<String, String> imagePaths,
  //     String token,
  //     ) async {
  //   final url = Uri.parse(Api.updateUserProfileUrl); // e.g., '/api/driver/profile/update/'
  //   try {
  //     final multipartRequest = http.MultipartRequest('patch', url);
  //     multipartRequest.headers.addAll({
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     });
  //
  //     final jsonData = request.toJson();
  //     for (var entry in jsonData.entries) {
  //       if (entry.value != null && (entry.value is! List || (entry.value as List).isNotEmpty)) {
  //         if (entry.value is List) {
  //           multipartRequest.fields[entry.key] = jsonEncode(entry.value);
  //         } else {
  //           multipartRequest.fields[entry.key] = entry.value.toString();
  //         }
  //       }
  //     }
  //
  //     debugPrint('Serialized fields: ${multipartRequest.fields}');
  //
  //     // Add images with field-specific names
  //     for (var entry in imagePaths.entries) {
  //       final fieldName = entry.key; // e.g., 'profile_picture'
  //       final path = entry.value;
  //       final file = await http.MultipartFile.fromPath(
  //         fieldName, // Use field name as the part name (backend expects this)
  //         path,
  //         filename: path.split('/').last,
  //         contentType: MediaType('image', path.endsWith('.png') ? 'png' : 'jpeg'), // Detect MIME
  //       );
  //       multipartRequest.files.add(file);
  //       debugPrint('Added image for $fieldName: ${file.filename}');
  //     }
  //
  //     debugPrint('Request: PATCH $url');
  //     debugPrint('Headers: ${multipartRequest.headers}');
  //     debugPrint('Files: ${multipartRequest.files.map((f) => '${f.field}: ${f.filename}').toList()}');
  //
  //     final streamedResponse = await multipartRequest.send();
  //     final response = await http.Response.fromStream(streamedResponse);
  //     debugPrint('Response status: ${response.statusCode}');
  //     debugPrint('Response body: ${response.body}');
  //
  //     final responseData = response.body.isNotEmpty ? jsonDecode(response.body) : {};
  //     return {'statusCode': response.statusCode, 'data': responseData};
  //   } catch (e) {
  //     debugPrint('API error in updateDriverProfileWithPatch: $e');
  //     return {
  //       'statusCode': 500,
  //       'data': {'detail': e.toString()},
  //     };
  //   }
  // }


  Future<Map<String, dynamic>> login(String number, String userType,bool employee) async {
    final url = Uri.parse(Api.loginUrl);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'mobile_number': number, 'user_type': userType, 'is_company_user': employee}),
      );
      debugPrint('Request: POST $url');
      debugPrint('Body: ${jsonEncode({'mobile_number': number, 'user_type': userType, 'is_company_user': employee})}');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      return {
        'statusCode': response.statusCode,
        'data': response.statusCode == 200
            ? jsonDecode(response.body)
            : jsonDecode(response.body.isNotEmpty ? response.body : '{}'),
      };
    } catch (e) {
      debugPrint('API error: $e');
      return {
        'statusCode': 500,
        'data': {'error': e.toString()},
      };
    }
  }

  Future<Map<String, dynamic>> resendOtp(String number, String userType) async {
    final url = Uri.parse(Api.resendOtp);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'mobile_number': number, 'user_type': userType}),
      );
      debugPrint('Request: POST $url');
      debugPrint('Body: ${jsonEncode({'mobile_number': number, 'user_type': userType})}');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      return {
        'statusCode': response.statusCode,
        'data': response.statusCode == 200
            ? jsonDecode(response.body)
            : jsonDecode(response.body.isNotEmpty ? response.body : '{}'),
      };
    } catch (e) {
      debugPrint('API error: $e');
      return {
        'statusCode': 500,
        'data': {'error': e.toString()},
      };
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String number, String otpCode) async {
    final url = Uri.parse(Api.verifyOtp);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'mobile_number': number, 'otp_code': otpCode,
          "otp_type":"login"}),
      );
      debugPrint('Request: POST $url');
      debugPrint('Body: ${jsonEncode({'number': number, 'otp_code': otpCode})}');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      return {
        'statusCode': response.statusCode,
        'data': response.statusCode == 200
            ? jsonDecode(response.body)
            : jsonDecode(response.body.isNotEmpty ? response.body : '{}'),
      };
    } catch (e) {
      debugPrint('API error: $e');
      return {
        'statusCode': 500,
        'data': {'error': e.toString()},
      };
    }
  }

  Future<bool> requestStoragePermission() async {
    if (await Permission.manageExternalStorage.isGranted) {
      return true;
    }

    var status = await Permission.manageExternalStorage.request();
    return status.isGranted;
  }

  Future<void> downloadFile(String url, String fileName) async {
    try {
      bool hasPermission = await requestStoragePermission();
      if (!hasPermission) {
        Get.snackbar(
          "Permission Denied",
          "Storage permission is required to download files.",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      Directory dir;
      if (Platform.isAndroid) {
        dir = Directory("/storage/emulated/0/Download");
        if (!dir.existsSync()) {
          dir = await getExternalStorageDirectory() ?? await getApplicationDocumentsDirectory();
        }
      } else {
        dir = await getApplicationDocumentsDirectory();
      }

      final filePath = "${dir.path}/$fileName";

      Dio dio = Dio();
      await dio.download(url, filePath);

      Get.snackbar(
        "Download Complete",
        "Saved to ${dir.path}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Download Failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      final response = await http.post(
        Uri.parse(Api.refreshTokenUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': refreshToken}),
      );
      debugPrint(
        'url _____________________ ${Api.refreshTokenUrl} _____________',
      );
      debugPrint(
        "refresh token _____________________ $refreshToken _________________",
      );
      if (response.statusCode == 200) {
        debugPrint("status______ ${response.statusCode}");
        return {'statusCode': 200, 'data': jsonDecode(response.body)};
      } else {
        debugPrint("status______ ${response.statusCode}");
        throw Exception('Failed to refresh token');
      }
    } catch (e) {
      throw Exception('Error refreshing token: $e');
    }
  }

  Future<Map<String, dynamic>> createOrGetChatRoom(
      String token, {
        required List<int> participants,
      }) async {
    final url = Uri.parse(Api.getMessagesUrl);
    try {
      final resp = await client.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'participants': participants}),
      );

      debugPrint('createOrGetChatRoom URL: $url');
      debugPrint('createOrGetChatRoom Status: ${resp.statusCode}');
      debugPrint('createOrGetChatRoom Response: ${resp.body}');

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        final data = resp.body.isNotEmpty ? jsonDecode(resp.body) : {};
        return {'statusCode': 200, 'data': data};
      } else {
        final err = resp.body.isNotEmpty ? jsonDecode(resp.body) : {};
        return {
          'statusCode': resp.statusCode,
          'data': {
            'error':
            err['detail'] ?? err['message'] ?? 'Failed to open chat room',
          },
        };
      }
    } catch (e, st) {
      debugPrint('createOrGetChatRoom Error: $e\n$st');
      return {
        'statusCode': 500,
        'data': {'error': e.toString()},
      };
    }
  }

  Future<Map<String, dynamic>> getChats(String token, {String? pageUrl}) async {
    final url = pageUrl != null ? Uri.parse(pageUrl) : Uri.parse(Api.getChatsUrl);
    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      debugPrint('Request: GET $url');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      final decodedBody = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : {'count': 0, 'next': null, 'previous': null, 'results': []};

      return {
        'statusCode': response.statusCode,
        'data': decodedBody,
      };
    } catch (e) {
      debugPrint('GetChats API error: $e');
      return {
        'statusCode': 500,
        'data': {'detail': 'Network error: $e'},
      };
    }
  }

  Future<Map<String, dynamic>> fetchMessages(
      String roomId,
      String token, {
        int page = 1,
        int pageSize = 50,
      }) async {
    final url = Uri.parse(
      '${Api.getMessagesUrl}$roomId/messages/?page=$page&page_size=$pageSize',
    );

    try {
      final response = await client.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      debugPrint('fetchMessages URL: $url');
      debugPrint('fetchMessages Status: ${response.statusCode}');
      debugPrint('fetchMessages Response: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        // Expecting {"messages": [...], "page": 1, "page_size": 50, "total_messages": 81}
        if (decoded is Map<String, dynamic> && decoded.containsKey('messages')) {
          final List<dynamic> messages = decoded['messages'] ?? [];

          debugPrint("✅ Messages parsed: ${messages.length}");
          return {
            'statusCode': 200,
            'data': {
              'messages': messages,
              'page': decoded['page'] ?? page,
              'page_size': decoded['page_size'] ?? pageSize,
              'total_messages': decoded['total_messages'],
              'next': decoded['next'], // in case your API provides next URL
            },
          };
        } else if (decoded is List) {
          // Fallback: sometimes backend might just send a list
          debugPrint("✅ Messages parsed (list): ${decoded.length}");
          return {
            'statusCode': 200,
            'data': {
              'messages': decoded,
              'page': page,
              'page_size': pageSize,
              'total_messages': decoded.length,
            },
          };
        } else {
          throw Exception('Unexpected response format: $decoded');
        }
      } else {
        final errorData =
        response.body.isNotEmpty ? jsonDecode(response.body) : {};
        return {
          'statusCode': response.statusCode,
          'data': {
            'error': errorData['detail'] ??
                errorData['message'] ??
                'Failed to fetch messages',
          },
        };
      }
    } catch (e, st) {
      debugPrint('fetchMessages Exception: $e\n$st');
      return {
        'statusCode': 500,
        'data': {'error': e.toString()},
      };
    }
  }

  Future<http.Response> signUpWithOther(String email, String userType, String fcmToken) async {
    final url = Uri.parse(Api.signUpGoogleUrl);
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final body = {'email': email, 'user_type': userType, 'fcm_token': fcmToken};
    try {
      final response = await client.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      debugPrint('Request: POST $url');
      debugPrint('Body: ${jsonEncode(body)}');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      return response;
    } catch (e) {
      debugPrint('API error: $e');
      rethrow;
    }
  }











  Future<Map<String, dynamic>> getMessages(String roomId, String token, {int page = 1}) async {
    final response = await http.get(
      Uri.parse('${Api.getMessagesUrl}/$roomId/messages/?page=$page'),
      headers: {'Authorization': 'Bearer $token'},
    );
    debugPrint('Request: GET ${Api.getMessagesUrl}/$roomId/messages/?page=$page');
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');
    return {
      'statusCode': response.statusCode,
      'data': jsonDecode(response.body),
    };
  }

  Future<Map<String, dynamic>> createChat(String token, List<String> participantIds) async {
    final url = Uri.parse(Api.createChatRoomUrl);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'participant_ids': participantIds}),
      );
      debugPrint('Request: POST $url');
      debugPrint('Body: ${jsonEncode({'participant_ids': participantIds})}');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      return {
        'statusCode': response.statusCode,
        'data': jsonDecode(response.body.isNotEmpty ? response.body : '{}'),
      };
    } catch (e) {
      debugPrint('CreateChat API error: $e');
      return {
        'statusCode': 500,
        'data': {'detail': 'Network error: $e'},
      };
    }
  }

  Future<Map<String, dynamic>> sendChatInvitation({
    required String token,
    required int receiverId,
    required String message,
  }) async {
    final url = Uri.parse(Api.sendChatInvitationUrl);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'receiver_id': receiverId,
          'message': message,
        }),
      );
      debugPrint('Request: POST $url');
      debugPrint('Body: ${jsonEncode({'receiver_id': receiverId, 'message': message})}');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      return {
        'statusCode': response.statusCode,
        'data': jsonDecode(response.body.isNotEmpty ? response.body : '{}'),
      };
    } catch (e) {
      debugPrint('SendChatInvitation API error: $e');
      return {
        'statusCode': 500,
        'data': {'detail': 'Network error: $e'},
      };
    }
  }


  Future<Map<String, dynamic>> getInvitations(String token) async {
    final url = Uri.parse(Api.getInvitationsUrl);
    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      debugPrint('Request: GET $url');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      return {
        'statusCode': response.statusCode,
        'data': jsonDecode(response.body.isNotEmpty ? response.body : '[]'),
      };
    } catch (e) {
      debugPrint('GetInvitations API error: $e');
      return {
        'statusCode': 500,
        'data': {'detail': 'Network error: $e'},
      };
    }
  }

  Future<Map<String, dynamic>> respondToInvitation(String token, String invitationId, String action) async {
    final int? id = int.tryParse(invitationId);
    if (id == null) {
      debugPrint('Invalid invitation ID: $invitationId');
    }
    final url = Uri.parse('${Api.respondToInvitationUrl}/$id/respond/');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'action': action}),
      );
      debugPrint('Request: POST $url');
      debugPrint('Body: ${jsonEncode({'action': action})}');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      return {
        'statusCode': response.statusCode,
        'data': jsonDecode(response.body.isNotEmpty ? response.body : '{}'),
      };
    } catch (e) {
      debugPrint('RespondToInvitation API error: $e');
      return {
        'statusCode': 500,
        'data': {'detail': 'Network error: $e'},
      };
    }
  }

  Future<Map<String, dynamic>> registerFcmToken({
    required String accessToken,
    required String fcmToken,
  }) async {
    try {
      final url = Api.registerFcmTokenUrl;
      final headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };
      final body = jsonEncode({
        'token': fcmToken,
      });
      debugPrint('Request: POST $url');
      debugPrint('Headers: $headers');
      debugPrint('Body: $body');
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      if (response.statusCode == 404) {
        return {
          'statusCode': 404,
          'data': {'detail': 'FCM registration endpoint not found'},
        };
      }
      return {
        'statusCode': response.statusCode,
        'data': response.body.isNotEmpty ? jsonDecode(response.body) : {},
      };
    } catch (e) {
      debugPrint('Error registering FCM token: $e');
      return {
        'statusCode': 500,
        'data': {'detail': 'Network error: $e'},
      };
    }
  }

  Future<Map<String, dynamic>> getProfileById(String id, String token) async {
    try {
      final response = await http.get(
        Uri.parse('${Api.getProfileByIdUrl}/$id/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      debugPrint('Request: GET ${Api.getProfileByIdUrl}/$id/');
      debugPrint('Headers: {Authorization: Bearer $token, Content-Type: application/json}');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      return {
        'statusCode': response.statusCode,
        'data': jsonDecode(response.body.isNotEmpty ? response.body : '{}'),
      };
    } catch (e) {
      debugPrint('API error: $e');
      return {
        'statusCode': 500,
        'data': {'detail': 'Error: $e'},
      };
    }
  }

  Future<Map<String, dynamic>> getProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse(Api.getProfileUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      debugPrint('Request: GET ${Api.getProfileUrl}');
      debugPrint('Headers: {Authorization: Bearer $token, Content-Type: application/json}');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      final responseData = jsonDecode(response.body.isNotEmpty ? response.body : '{}');
      return {
        'statusCode': response.statusCode,
        'data': responseData,
      };
    } catch (e) {
      debugPrint('API error: $e');
      return {
        'statusCode': 500,
        'data': {'detail': 'Error: $e'},
      };
    }
  }

  Future<Map<String, dynamic>> fetchProfiles(String token) async {
    final url = Uri.parse(Api.fetchProfilesUrl);
    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      debugPrint('Request: GET $url');
      debugPrint('Headers: {Accept: application/json, Authorization: Bearer $token}');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      return {
        'statusCode': response.statusCode,
        'data': response.statusCode == 200
            ? jsonDecode(response.body)
            : jsonDecode(response.body.isNotEmpty ? response.body : '{}'),
      };
    } catch (e) {
      debugPrint('API error: $e');
      return {
        'statusCode': 500,
        'data': {'error': e.toString()},
      };
    }
  }

  Future<Map<String, dynamic>> fetchFilteredProfiles({
    required String token,
    String? searchTerm,
    double? minAge,
    double? maxAge,
    double? minHeight,
    double? maxHeight,
    List<String>? bodyTypes,
    List<String>? maritalStatuses,
    List<String>? marriageTimelines,
    List<String>? educationalLevels,
    List<String>? religions,
    List<String>? occupations,
    List<String>? familyTypes,
    List<String>? drinks,
    List<String>? smoke,
    List<String>? relationshipGoals,
    List<String>? countries,
  }) async {
    final queryParams = <String, String>{};
    if (searchTerm != null && searchTerm.isNotEmpty) queryParams['search'] = searchTerm;
    if (minAge != null) queryParams['min_age'] = minAge.toString();
    if (maxAge != null) queryParams['max_age'] = maxAge.toString();
    if (minHeight != null) queryParams['min_height'] = minHeight.toString();
    if (maxHeight != null) queryParams['max_height'] = maxHeight.toString();
    if (bodyTypes != null && bodyTypes.isNotEmpty) queryParams['body_types'] = bodyTypes.join(',');
    if (maritalStatuses != null && maritalStatuses.isNotEmpty) queryParams['marital_statuses'] = maritalStatuses.join(',');
    if (marriageTimelines != null && marriageTimelines.isNotEmpty) queryParams['marriage_timelines'] = marriageTimelines.join(',');
    if (educationalLevels != null && educationalLevels.isNotEmpty) queryParams['educational_levels'] = educationalLevels.join(',');
    if (religions != null && religions.isNotEmpty) queryParams['religions'] = religions.join(',');
    if (occupations != null && occupations.isNotEmpty) queryParams['occupations'] = occupations.join(',');
    if (familyTypes != null && familyTypes.isNotEmpty) queryParams['family_types'] = familyTypes.join(',');
    if (drinks != null && drinks.isNotEmpty) queryParams['drinks'] = drinks.join(',');
    if (smoke != null && smoke.isNotEmpty) queryParams['smoke'] = smoke.join(',');
    if (relationshipGoals != null && relationshipGoals.isNotEmpty) queryParams['relationship_goals'] = relationshipGoals.join(',');
    if (countries != null && countries.isNotEmpty) queryParams['countries'] = countries.join(',');
    final url = Uri.parse(Api.profilesFilterUrl).replace(queryParameters: queryParams);
    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      debugPrint('Request: GET $url');
      debugPrint('Headers: {Accept: application/json, Authorization: Bearer $token}');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      return {
        'statusCode': response.statusCode,
        'data': response.statusCode == 200
            ? jsonDecode(response.body)
            : jsonDecode(response.body.isNotEmpty ? response.body : '{}'),
      };
    } catch (e) {
      debugPrint('API error: $e');
      return {
        'statusCode': 500,
        'data': {'error': e.toString()},
      };
    }
  }

  Future<Map<String, dynamic>> getUserProfile(String token) async {
    final url = Uri.parse(Api.getProfileUrl);
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      debugPrint('Request: GET $url');
      debugPrint('Headers: {Authorization: Bearer $token, Accept: application/json}');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      return {
        'statusCode': response.statusCode,
        'data': jsonDecode(response.body.isNotEmpty ? response.body : '{}'),
      };
    } catch (e) {
      debugPrint('API error: $e');
      return {
        'statusCode': 500,
        'data': {'detail': 'Error: $e'},
      };
    }
  }

  // Future<Map<String, dynamic>> updateProfile(
  //     ProfileUpdateRequest request,
  //     List<String> imagePaths,
  //     String? token,
  //     ) async {
  //   final url = Uri.parse(Api.updateProfileUrl);
  //   try {
  //     final multipartRequest = http.MultipartRequest('PATCH', url);
  //     multipartRequest.headers.addAll({
  //       'Accept': 'application/json',
  //       if (token != null) 'Authorization': 'Bearer $token',
  //     });
  //     final jsonData = request.toJson();
  //     for (var entry in jsonData.entries) {
  //       if (entry.value is String && entry.value.isNotEmpty) {
  //         multipartRequest.fields[entry.key] = entry.value as String;
  //       }
  //     }
  //     multipartRequest.fields['family_origin'] = jsonEncode(request.familyOrigin);
  //     multipartRequest.fields['dating_goal'] = jsonEncode(request.datingGoal);
  //     multipartRequest.fields['interests'] = jsonEncode(request.interests);
  //     multipartRequest.fields['languages'] = jsonEncode(request.languages);
  //     debugPrint('Serialized fields: ${multipartRequest.fields}');
  //     for (var path in imagePaths) {
  //       final file = await http.MultipartFile.fromPath(
  //         'signup_images',
  //         path,
  //         filename: path.split('/').last,
  //       );
  //       multipartRequest.files.add(file);
  //       debugPrint('Added gallery image: ${file.filename}');
  //     }
  //     debugPrint('Request: PATCH $url');
  //     debugPrint('Headers: ${multipartRequest.headers}');
  //     debugPrint('Files: ${multipartRequest.files.map((f) => f.filename).toList()}');
  //     final streamedResponse = await multipartRequest.send();
  //     final response = await http.Response.fromStream(streamedResponse);
  //     debugPrint('Response status: ${response.statusCode}');
  //     debugPrint('Response body: ${response.body}');
  //     final responseData = response.body.isNotEmpty ? jsonDecode(response.body) : {};
  //     return {
  //       'statusCode': response.statusCode,
  //       'data': responseData,
  //     };
  //   } catch (e) {
  //     debugPrint('API error: $e');
  //     return {
  //       'statusCode': 500,
  //       'data': {'error': e.toString()},
  //     };
  //   }
  // }
  //
  // Future<Map<String, dynamic>> updateProfileWithPatch(
  //     ProfileUpdateRequest request,
  //     List<String> imagePaths,
  //     String? token,
  //     ) async {
  //   final url = Uri.parse(Api.updateProfileUrl);
  //   try {
  //     final multipartRequest = http.MultipartRequest('PATCH', url);
  //     multipartRequest.headers.addAll({
  //       'Accept': 'application/json',
  //       if (token != null) 'Authorization': 'Bearer $token',
  //     });
  //     final jsonData = request.toJson();
  //     for (var entry in jsonData.entries) {
  //       if (entry.value is String && entry.value.isNotEmpty) {
  //         multipartRequest.fields[entry.key] = entry.value as String;
  //       }
  //     }
  //     multipartRequest.fields['family_origin'] = jsonEncode(request.familyOrigin);
  //     multipartRequest.fields['dating_goal'] = jsonEncode(request.datingGoal);
  //     multipartRequest.fields['interests'] = jsonEncode(request.interests);
  //     multipartRequest.fields['languages'] = jsonEncode(request.languages);
  //     debugPrint('Serialized fields: ${multipartRequest.fields}');
  //     for (var path in imagePaths) {
  //       final file = await http.MultipartFile.fromPath(
  //         'gallery',
  //         path,
  //         filename: path.split('/').last,
  //       );
  //       multipartRequest.files.add(file);
  //       debugPrint('Added gallery image: ${file.filename}');
  //     }
  //     debugPrint('Request: PATCH $url');
  //     debugPrint('Headers: ${multipartRequest.headers}');
  //     debugPrint('Files: ${multipartRequest.files.map((f) => f.filename).toList()}');
  //     final streamedResponse = await multipartRequest.send();
  //     final response = await http.Response.fromStream(streamedResponse);
  //     debugPrint('Response status: ${response.statusCode}');
  //     debugPrint('Response body: ${response.body}');
  //     final responseData = response.body.isNotEmpty ? jsonDecode(response.body) : {};
  //     return {
  //       'statusCode': response.statusCode,
  //       'data': responseData,
  //     };
  //   } catch (e) {
  //     debugPrint('API error: $e');
  //     return {
  //       'statusCode': 500,
  //       'data': {'error': e.toString()},
  //     };
  //   }
  // }
  //
  // Future<Map<String, dynamic>> updateProfilePictureWithPatch(
  //     ProfileUpdateRequest request,
  //     List<String> imagePaths,
  //     String? token,
  //     ) async {
  //   final url = Uri.parse(Api.updateProfileUrl);
  //   try {
  //     final multipartRequest = http.MultipartRequest('PATCH', url);
  //     multipartRequest.headers.addAll({
  //       'Accept': 'application/json',
  //       if (token != null) 'Authorization': 'Bearer $token',
  //     });
  //     final jsonData = request.toJson();
  //     for (var entry in jsonData.entries) {
  //       if (entry.value is String && entry.value.isNotEmpty) {
  //         multipartRequest.fields[entry.key] = entry.value as String;
  //       }
  //     }
  //     multipartRequest.fields['family_origin'] = jsonEncode(request.familyOrigin);
  //     multipartRequest.fields['dating_goal'] = jsonEncode(request.datingGoal);
  //     multipartRequest.fields['interests'] = jsonEncode(request.interests);
  //     multipartRequest.fields['languages'] = jsonEncode(request.languages);
  //     debugPrint('Serialized fields: ${multipartRequest.fields}');
  //     for (var path in imagePaths) {
  //       final file = await http.MultipartFile.fromPath(
  //         'profile_image',
  //         path,
  //         filename: path.split('/').last,
  //       );
  //       multipartRequest.files.add(file);
  //       debugPrint('Added gallery image: ${file.filename}');
  //     }
  //     debugPrint('Request: PATCH $url');
  //     debugPrint('Headers: ${multipartRequest.headers}');
  //     debugPrint('Files: ${multipartRequest.files.map((f) => f.filename).toList()}');
  //     final streamedResponse = await multipartRequest.send();
  //     final response = await http.Response.fromStream(streamedResponse);
  //     debugPrint('Response status: ${response.statusCode}');
  //     debugPrint('Response body: ${response.body}');
  //     final responseData = response.body.isNotEmpty ? jsonDecode(response.body) : {};
  //     return {
  //       'statusCode': response.statusCode,
  //       'data': responseData,
  //     };
  //   } catch (e) {
  //     debugPrint('API error: $e');
  //     return {
  //       'statusCode': 500,
  //       'data': {'error': e.toString()},
  //     };
  //   }
  // }

  Future<Map<String, dynamic>> deleteGalleryImage(int photoId, String token) async {
    final url = Uri.parse('${Api.deleteGalleryImageUrl}/$photoId/');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      debugPrint('Request: DELETE $url');
      debugPrint('Headers: {Authorization: Bearer $token, Accept: application/json}');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      return {
        'statusCode': response.statusCode,
        'data': response.body.isNotEmpty ? jsonDecode(response.body) : {},
      };
    } catch (e) {
      debugPrint('API error: $e');
      return {
        'statusCode': 500,
        'data': {'error': e.toString()},
      };
    }
  }


  Future<Map<String, dynamic>> setPassword(
      String email,
      String password,
      ) async {
    final url = Uri.parse(Api.setPassword);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );
      debugPrint('Request: POST $url');
      debugPrint('Body: ${jsonEncode({'email': email, 'password': password})}');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      return {
        'statusCode': response.statusCode,
        'data': response.statusCode == 201
            ? jsonDecode(response.body)
            : jsonDecode(response.body.isNotEmpty ? response.body : '{}'),
      };
    } catch (e) {
      debugPrint('API error: $e');
      return {
        'statusCode': 500,
        'data': {'error': e.toString()},
      };
    }
  }

  Future<Map<String, dynamic>> signup(String email) async {
    final url = Uri.parse(Api.signup);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email}),
      );
      debugPrint('Request: POST $url');
      debugPrint('Body: ${jsonEncode({'email': email})}');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      return {
        'statusCode': response.statusCode,
        'data': response.statusCode == 200
            ? jsonDecode(response.body)
            : jsonDecode(response.body.isNotEmpty ? response.body : '{}'),
      };
    } catch (e) {
      debugPrint('API error: $e');
      return {
        'statusCode': 500,
        'data': {'error': e.toString()},
      };
    }
  }

  Future<Map<String, dynamic>> forget(String email) async {
    final url = Uri.parse(Api.forget);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email}),
      );
      debugPrint('Request: POST $url');
      debugPrint('Body: ${jsonEncode({'email': email})}');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      return {
        'statusCode': response.statusCode,
        'data': response.statusCode == 200
            ? jsonDecode(response.body)
            : jsonDecode(response.body.isNotEmpty ? response.body : '{}'),
      };
    } catch (e) {
      debugPrint('API error: $e');
      return {
        'statusCode': 500,
        'data': {'error': e.toString()},
      };
    }
  }



  Future<Map<String, dynamic>> createChatRoom(String recipientId, String token) async {
    if (recipientId.isEmpty || recipientId == 'null') {
      debugPrint('Invalid recipientId: $recipientId');
      return {
        'statusCode': 400,
        'data': {'detail': 'Invalid recipient ID'},
      };
    }

    final url = Uri.parse(Api.createChatRoomUrl);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'participant_ids': [recipientId]}),
      );
      debugPrint('Request: POST $url');
      debugPrint('Body: ${jsonEncode({'participant_ids': [recipientId]})}');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      final responseBody = response.body.isNotEmpty ? jsonDecode(response.body) : {};
      return {
        'statusCode': response.statusCode,
        'data': responseBody,
      };
    } catch (e) {
      debugPrint('CreateChatRoom API error: $e');
      return {
        'statusCode': 500,
        'data': {'detail': 'Network error: $e'},
      };
    }
  }

  Future<Map<String, dynamic>> sendMessage({
    required String roomId,
    required String content,
    required bool isImage,
    String? imagePath,
    required String token,
  }) async {
    final url = Uri.parse('${Api.sendMessageUrl}/$roomId/messages/');
    try {
      if (isImage && imagePath != null) {
        final multipartRequest = http.MultipartRequest('POST', url);
        multipartRequest.headers.addAll({
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
        final file = await http.MultipartFile.fromPath(
          'image',
          imagePath,
          filename: imagePath.split('/').last,
        );
        multipartRequest.files.add(file);
        debugPrint('Added image: ${file.filename}');
        debugPrint('Request: POST $url');
        debugPrint('Headers: ${multipartRequest.headers}');
        final streamedResponse = await multipartRequest.send();
        final response = await http.Response.fromStream(streamedResponse);
        debugPrint('Response status: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        final responseBody = response.body.isNotEmpty ? jsonDecode(response.body) : {};
        return {
          'statusCode': response.statusCode,
          'data': responseBody,
        };
      } else {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'content': content, 'is_image': isImage}),
        );
        debugPrint('Request: POST $url');
        debugPrint('Body: ${jsonEncode({'content': content, 'is_image': isImage})}');
        debugPrint('Response status: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        final responseBody = response.body.isNotEmpty ? jsonDecode(response.body) : {};
        return {
          'statusCode': response.statusCode,
          'data': responseBody,
        };
      }
    } catch (e) {
      debugPrint('SendMessage API error: $e');
      return {
        'statusCode': 500,
        'data': {'detail': 'Network error: $e'},
      };
    }
  }

  Future<Map<String, dynamic>> deleteMessage(String roomId, String messageId, String token) async {
    final url = Uri.parse('${Api.deleteMessageUrl}/$roomId/messages/$messageId/');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      debugPrint('Request: DELETE $url');
      debugPrint('Headers: {Accept: application/json, Authorization: Bearer $token}');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      return {
        'statusCode': response.statusCode,
        'data': jsonDecode(response.body.isNotEmpty ? response.body : '{}'),
      };
    } catch (e) {
      debugPrint('API error: $e');
      return {
        'statusCode': 500,
        'data': {'detail': 'Error: $e'},
      };
    }
  }
}
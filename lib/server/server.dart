import 'dart:convert' as convert;
import 'package:raven_verification/app_data_helper.dart';
import 'package:dio/dio.dart' as di;
import "package:http/http.dart" as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class Server {
  final String key;
  final bool isFull;
  final Function(bool)? onFinishDownload;
  Map<String, String>? header;
  final int timeout;
  static http.Client client = http.Client();
  static bool forceLogout = false;
  static const String _mainBaseUrl = "https://baas.getraventest.com";

  /// base class for making http request[Server]
  Server(
      {required this.key,
      this.timeout = 55,
      this.isFull = false,
      this.onFinishDownload,
      this.header});

  Future<dynamic> uploadFile(String filePath, Map<String, dynamic> form) async {
    try {
      var dio = di.Dio();
      dio.options.baseUrl = _mainBaseUrl;
      dio.options.connectTimeout = const Duration(seconds: 35000);
      dio.options.receiveTimeout = const Duration(seconds: 35000);
      dio.options.headers = await _getHeader();
      final mimeTypeData =
          lookupMimeType(filePath, headerBytes: [0xFF, 0xD8])?.split('/');

      return dio
          .post("/image/match",
              data: di.FormData.fromMap({
                ...form,
                'image': await di.MultipartFile.fromFile(filePath,
                    contentType: MediaType(mimeTypeData![0], mimeTypeData[1])),
              }),
              options: di.Options(
                  validateStatus: (_) => true,
                  method: "POST",
                  responseType: di.ResponseType.plain),
              onSendProgress: (int sent, int total) {})
          .then((response) {
        if (response.statusCode == 200) {
          return convert.jsonDecode(response.data.toString());
        }
        return "failed";
      });
    } catch (ex) {
      return "failed";
    }
  }

  ///private method to return header   [_getHeader]
  Future<Map<String, String>> _getHeader() async {
    var value = <String, String>{
      'content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${VerificationPlugin.getBearer()}',
    };
    return value;
  }

  Future<dynamic> getRequest() async {
    try {
      return await client
          .get(Uri.parse(isFull ? key : _mainBaseUrl + key),
              headers: await _getHeader())
          .then((response) async {
        if (response.statusCode == 406) {}

        if (response.body.isEmpty) {
          return "oops, something went wrong...";
        }

        return convert.jsonDecode(response.body);
      }).timeout(Duration(seconds: timeout), onTimeout: () {
        return "failed";
      });
    } catch (ex) {
      return "failed";
    } finally {}
  }
}

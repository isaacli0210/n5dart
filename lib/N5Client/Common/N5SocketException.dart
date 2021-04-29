import 'package:n5client/N5Client/interface/IRequestBody.dart';
import 'package:n5client/N5Client/interface/IResponseBody.dart';

enum N5ExceptionType { REQUEST_FAILED, TIMEOUT, CLIENT_IN_USE, UNKNOWN_ERROR }

class N5Exception implements Exception {
  N5Exception({
    //this.request,
    //this.response,
    this.type = N5ExceptionType.UNKNOWN_ERROR,
    this.error,
  });

  //IRequestBody request;
  //IResponseBody response;
  N5ExceptionType type;
  dynamic error;

  String get message => (error?.toString() ?? '');

  @override
  String toString() {
    var msg = 'N5Exception [$type]: $message';
    if (error is Error) {
      msg += '\n${error.stackTrace}';
    }
    return msg;
  }
}

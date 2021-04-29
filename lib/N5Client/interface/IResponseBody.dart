import 'package:n5client/N5Client/Constant/ResponseEvent.dart';
import 'package:n5client/N5Client/Constant/ResponseStatusType.dart';

abstract class IResponseBody {
  // ignore: non_constant_identifier_names
  ResponseEvent EVENT_NAME;
  String RAW_JSON;

  List<String> allowedStatus = [];

  fillFromJson(Map<String, dynamic> json) {
    if (json['EVENT_NAME'] != EVENT_NAME.toShortString()) {
      throw new Exception('Response json not match.');
    }

    if (!allowedStatus.contains(json['STATUS'])) {
      throw new Exception('Unexpected response status returned.');
    }
  }

  ResponseStatusType getResponseStatusType();
}

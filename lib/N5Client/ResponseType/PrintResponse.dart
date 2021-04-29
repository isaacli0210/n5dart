import 'dart:convert';

import 'package:n5client/N5Client/Constant/ResponseEvent.dart';
import 'package:n5client/N5Client/Constant/ResponseStatus.dart';
import 'package:n5client/N5Client/Constant/ResponseStatusType.dart';
import 'package:n5client/N5Client/interface/IResponseBody.dart';

class PrintResponse extends IResponseBody {
  List<String> allowedStatus = [
    ResponseStatus.ApprovedOrAcceptedByHost,
    ResponseStatus.DeclinedByHost,
    ResponseStatus.ECRBusy,
  ];

  @override
  ResponseEvent EVENT_NAME = ResponseEvent.PRINT_RESP;
  String STATUS;

  PrintResponse(String jsonString) {
    RAW_JSON = jsonString;
    fillFromJson(jsonDecode(jsonString));
  }

  fillFromJson(Map<String, dynamic> json) {
    super.fillFromJson(json);
    STATUS = json['STATUS'];
  }

  @override
  ResponseStatusType getResponseStatusType() {
    switch (STATUS) {
      case ResponseStatus.ApprovedOrAcceptedByHost:
        return ResponseStatusType.Success;
      case ResponseStatus.DeclinedByHost:
        return ResponseStatusType.Error;
      case ResponseStatus.ECRBusy:
        return ResponseStatusType.ProcessingAnotherRequest;
    }
  }
}

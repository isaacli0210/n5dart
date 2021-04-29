import 'dart:convert';

import 'package:n5client/N5Client/Constant/ResponseEvent.dart';
import 'package:n5client/N5Client/Constant/ResponseStatus.dart';
import 'package:n5client/N5Client/Constant/ResponseStatusType.dart';
import 'package:n5client/N5Client/interface/IResponseBody.dart';

class BatchEnquiryResponse extends IResponseBody {
  List<String> allowedStatus = [
    ResponseStatus.ApprovedOrAcceptedByHost,
    ResponseStatus.CommunicationOrFormatError,
    ResponseStatus.ECRBusy,
    ResponseStatus.UnknownError,
    ResponseStatus.TransactionNotFind
  ];

  @override
  ResponseEvent EVENT_NAME = ResponseEvent.BATCH_ENQUIRY_RESP;
  String STATUS;
  List<String> RESULT;

  BatchEnquiryResponse(String jsonString) {
    RAW_JSON = jsonString;
    fillFromJson(jsonDecode(jsonString));
  }

  fillFromJson(Map<String, dynamic> json) {
    super.fillFromJson(json);
    STATUS = json['STATUS'];
    if (json['STATUS'] == "00") {
      RESULT = json['RESULT'].cast<String>();
    }
  }

  @override
  ResponseStatusType getResponseStatusType() {
    switch (STATUS) {
      case ResponseStatus.ApprovedOrAcceptedByHost:
        return ResponseStatusType.Success;
      case ResponseStatus.ECRBusy:
        return ResponseStatusType.ProcessingAnotherRequest;
      default:
        return ResponseStatusType.Error;
    }
  }
}

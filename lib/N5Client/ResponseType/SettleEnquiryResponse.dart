import 'dart:convert';

import 'package:n5client/N5Client/Constant/ResponseEvent.dart';
import 'package:n5client/N5Client/Constant/ResponseStatus.dart';
import 'package:n5client/N5Client/Constant/ResponseStatusType.dart';
import 'package:n5client/N5Client/interface/IResponseBody.dart';
import 'package:n5client/N5Client/interface/ISettleBody.dart';

class SettleEnquiryResponse extends IResponseBody {
  List<String> allowedStatus = [
    ResponseStatus.ApprovedOrAcceptedByHost,
    ResponseStatus.CommunicationOrFormatError,
    ResponseStatus.ECRBusy,
    ResponseStatus.UnknownError
  ];

  @override
  ResponseEvent EVENT_NAME = ResponseEvent.SETTLE_ENQUIRY_RESP;
  String STATUS;
  List<SettleEnquiryResult> RESULT;

  SettleEnquiryResponse(String jsonString) {
    RAW_JSON = jsonString;
    fillFromJson(jsonDecode(jsonString));
  }

  fillFromJson(Map<String, dynamic> json) {
    super.fillFromJson(json);
    STATUS = json['STATUS'];
    if (json['STATUS'] == '00') {
      RESULT = (json['RESULT'] as List)
          .map((i) => SettleEnquiryResult.fromJson(i))
          .toList();
    }
  }

  @override
  ResponseStatusType getResponseStatusType() {
    switch (STATUS) {
      case ResponseStatus.ApprovedOrAcceptedByHost:
        return ResponseStatusType.Success;
      case ResponseStatus.ECRBusy:
        return ResponseStatusType.ProcessingAnotherRequest;
      case ResponseStatus.CancelledByUser:
      case ResponseStatus.CommunicationOrFormatError:
      case ResponseStatus.FunctionOrPaymentTypeNotSupport:
      case ResponseStatus.Timeout:
      case ResponseStatus.UnknownError:
        return ResponseStatusType.Error;
    }
  }
}

class SettleEnquiryResult extends ISettleBody {
  /// Merchant ID
  String mID;

  SettleEnquiryResult.fromJson(Map<String, dynamic> json) {
    mID = json['MID'];
    rC = json['RC'];
    oC = json['OC'];
    tYPE = json['TYPE'];
    vRC = json['VRC'];
    rA = json['RA'];
    sC = json['SC'];
    oA = json['OA'];
    sA = json['SA'];
    vSC = json['VSC'];
    vOC = json['VOC'];
    vSA = json['VSA'];
    tID = json['TID'];
    vRA = json['VRA'];
    vOA = json['VOA'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MID'] = this.mID;
    data['RC'] = this.rC;
    data['OC'] = this.oC;
    data['TYPE'] = this.tYPE;
    data['VRC'] = this.vRC;
    data['RA'] = this.rA;
    data['SC'] = this.sC;
    data['OA'] = this.oA;
    data['SA'] = this.sA;
    data['VSC'] = this.vSC;
    data['VOC'] = this.vOC;
    data['VSA'] = this.vSA;
    data['TID'] = this.tID;
    data['VRA'] = this.vRA;
    data['VOA'] = this.vOA;
    return data;
  }
}

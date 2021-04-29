import 'dart:convert';
import 'dart:html';

import 'package:n5client/N5Client/Constant/PaymentType.dart';
import 'package:n5client/N5Client/Constant/ResponseEvent.dart';
import 'package:n5client/N5Client/Constant/ResponseStatus.dart';
import 'package:n5client/N5Client/Constant/ResponseStatusType.dart';
import 'package:n5client/N5Client/Helper/PaymentHelper.dart';
import 'package:n5client/N5Client/interface/IResponseBody.dart';

class RefundResponse extends IResponseBody {
  List<String> allowedStatus = [
    ResponseStatus.ApprovedOrAcceptedByHost,
    ResponseStatus.RefundProcessingOrAccepted,
    ResponseStatus.ConfirmingOrProcessing,
    ResponseStatus.CancelledByUser,
    ResponseStatus.DeclinedByHost,
    ResponseStatus.CommunicationOrFormatError,
    ResponseStatus.FunctionOrPaymentTypeNotSupport,
    ResponseStatus.ECRBusy,
    ResponseStatus.Timeout,
    ResponseStatus.UnknownError
  ];

  @override
  ResponseEvent EVENT_NAME = ResponseEvent.REFUND_RESP;
  String TXN_ID;
  String STATUS;
  double TXN_AMT;
  PaymentType PAYMENT_TYPE;
  String RESP_CODE;
  String TRACE_NO;
  String TXN_DATE;
  String TXN_TIME;
  String HOST_REF;
  String AUTH_CODE;
  String LOCAL_CUR;
  String FOREIGN_CUR;
  double FXRATE;
  double FOREIGN_AMT;
  String MID;
  String TID;
  String PAN;
  String EXPIRY_DATE;
  String AID;
  String ENTRY_MODE;
  String BATCH_NO;
  String ACQUIRER;
  String CARD_HOLDER;

  RefundResponse(String jsonString) {
    RAW_JSON = jsonString;
    fillFromJson(jsonDecode(jsonString));
  }

  fillFromJson(Map<String, dynamic> json) {
    super.fillFromJson(json);
    TXN_ID = json['TXN_ID'];
    STATUS = json['STATUS'];
    TXN_AMT = json.containsKey("TXN_AMT") ? json['TXN_AMT'].toDouble() : null;
    PAYMENT_TYPE = PaymentType.values.firstWhere(
        (type) => type.toShortString() == json['PAYMENT_TYPE'],
        orElse: () => null);
    RESP_CODE = json['RESP_CODE'];
    TRACE_NO = json['TRACE_NO'];
    TXN_DATE = json['TXN_DATE'];
    TXN_TIME = json['TXN_TIME'];
    HOST_REF = json['HOST_REF'];
    AUTH_CODE = json['AUTH_CODE'];
    LOCAL_CUR = json['LOCAL_CUR'];
    FOREIGN_CUR = json['FOREIGN_CUR'];
    FXRATE = json.containsKey("FXRATE") ? json['FXRATE'].toDouble() : null;
    FOREIGN_AMT =
        json.containsKey("FOREIGN_AMT") ? json['FOREIGN_AMT'].toDouble() : null;
    MID = json['MID'];
    TID = json['TID'];
    PAN = json['PAN'];
    EXPIRY_DATE = json['EXPIRY_DATE'];
    AID = json['AID'];
    ENTRY_MODE = json['ENTRY_MODE'];
    BATCH_NO = json['BATCH_NO'];
    ACQUIRER = json['ACQUIRER'];
    CARD_HOLDER = json['CARD_HOLDER'];
  }

  @override
  ResponseStatusType getResponseStatusType() {
    switch (STATUS) {
      case ResponseStatus.ApprovedOrAcceptedByHost:
        return ResponseStatusType.Success;
      case ResponseStatus.RefundProcessingOrAccepted:
        return PAYMENT_TYPE.isQRCodePaymentTypes()
            ? ResponseStatusType.Success
            : ResponseStatusType.ProcessingAnotherRequest;
      case ResponseStatus.ConfirmingOrProcessing:
      case ResponseStatus.ECRBusy:
        return ResponseStatusType.ProcessingAnotherRequest;
      case ResponseStatus.CancelledByUser:
      case ResponseStatus.DeclinedByHost:
      case ResponseStatus.CommunicationOrFormatError:
      case ResponseStatus.FunctionOrPaymentTypeNotSupport:
      case ResponseStatus.Timeout:
      case ResponseStatus.UnknownError:
        return ResponseStatusType.Error;
    }
  }
}

import 'dart:convert';

import 'package:n5client/N5Client/Constant/PaymentType.dart';
import 'package:n5client/N5Client/Constant/ResponseEvent.dart';
import 'package:n5client/N5Client/Constant/ResponseStatus.dart';
import 'package:n5client/N5Client/Constant/ResponseStatusType.dart';
import 'package:n5client/N5Client/interface/IResponseBody.dart';

class VoidResponse extends IResponseBody {
  List<String> allowedStatus = [
    ResponseStatus.ApprovedOrAcceptedByHost,
    ResponseStatus.ConfirmingOrProcessing,
    ResponseStatus.CancelledByUser,
    ResponseStatus.DeclinedByHost,
    ResponseStatus.TransactionCompleted,
    ResponseStatus.TransactionNotFind,
    ResponseStatus.CommunicationOrFormatError,
    ResponseStatus.FunctionOrPaymentTypeNotSupport,
    ResponseStatus.ECRBusy,
    ResponseStatus.Timeout,
    ResponseStatus.UnknownError
  ];

  @override
  ResponseEvent EVENT_NAME = ResponseEvent.VOID_RESP;
  String TXN_ID;
  String STATUS;
  PaymentType PAYMENT_TYPE;
  String RESP_CODE;
  String TXN_DATE;
  String TXN_TIME;
  String HOST_REF;
  String BATCH_NO;
  String MID;
  String TID;
  String PAN;
  double TXN_AMT;
  String TRACE_NO;
  String AUTH_CODE;
  String CARD_HOLDER;
  String APP;
  String ACQUIRER;
  String TERMS;
  String DCC_VISA_TERMS;
  String DCC_MID;
  String LMS_ORIGINAL_BAL;
  String LMS_BAL;
  String LMS_USED;
  String LMS_BATCH_NO;
  String LMS_APPRV;

  VoidResponse(String jsonString) {
    RAW_JSON = jsonString;
    fillFromJson(jsonDecode(jsonString));
  }

  fillFromJson(Map<String, dynamic> json) {
    super.fillFromJson(json);
    TXN_ID = json['TXN_ID'];
    STATUS = json['STATUS'];
    PAYMENT_TYPE = PaymentType.values.firstWhere(
        (type) => type.toShortString() == json['PAYMENT_TYPE'],
        orElse: () => null);
    RESP_CODE = json['RESP_CODE'];
    if (json['STATUS'] == '00') {
      TXN_DATE = json['TXN_DATE'];
      TXN_TIME = json['TXN_TIME'];
      HOST_REF = json['HOST_REF'];
      BATCH_NO = json['BATCH_NO'];
      MID = json['MID'];
      TID = json['TID'];
      PAN = json['PAN'];
      TXN_AMT = json.containsKey("TXN_AMT") ? json['TXN_AMT'].toDouble() : null;
      TRACE_NO = json['TRACE_NO'];
      AUTH_CODE = json['AUTH_CODE'];
      CARD_HOLDER = json['CARD_HOLDER'];
      APP = json['APP'];
      ACQUIRER = json['ACQUIRER'];
      TERMS = json['TERMS'];
      DCC_VISA_TERMS = json['DCC_VISA_TERMS'];
      DCC_MID = json['DCC_MID'];
      LMS_ORIGINAL_BAL = json['LMS_ORIGINAL_BAL'];
      LMS_BAL = json['LMS_BAL'];
      LMS_USED = json['LMS_USED'];
      LMS_BATCH_NO = json['LMS_BATCH_NO'];
      LMS_APPRV = json['LMS_APPRV'];
    }
  }

  @override
  ResponseStatusType getResponseStatusType() {
    switch (STATUS) {
      case ResponseStatus.ApprovedOrAcceptedByHost:
      case ResponseStatus.TransactionCompleted:
        return ResponseStatusType.Success;
      case ResponseStatus.ConfirmingOrProcessing:
        return ResponseStatusType.TransactionProcessing;
      case ResponseStatus.CancelledByUser:
      case ResponseStatus.DeclinedByHost:
      case ResponseStatus.TransactionNotFind:
      case ResponseStatus.CommunicationOrFormatError:
      case ResponseStatus.FunctionOrPaymentTypeNotSupport:
      case ResponseStatus.Timeout:
      case ResponseStatus.UnknownError:
        return ResponseStatusType.Error;
      case ResponseStatus.ECRBusy:
        return ResponseStatusType.ProcessingAnotherRequest;
    }
  }
}

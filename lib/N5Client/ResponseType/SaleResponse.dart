import 'dart:convert';

import 'package:n5client/N5Client/Constant/PaymentType.dart';
import 'package:n5client/N5Client/Constant/ResponseEvent.dart';
import 'package:n5client/N5Client/Constant/ResponseStatus.dart';
import 'package:n5client/N5Client/Constant/ResponseStatusType.dart';
import 'package:n5client/N5Client/interface/IResponseBody.dart';

class SaleResponse extends IResponseBody {
  List<String> allowedStatus = [
    ResponseStatus.ApprovedOrAcceptedByHost,
    ResponseStatus.ConfirmingOrProcessing,
    ResponseStatus.CancelledByUser,
    ResponseStatus.DeclinedByHost,
    ResponseStatus.ReversalByUser,
    ResponseStatus.CommunicationOrFormatError,
    ResponseStatus.FunctionOrPaymentTypeNotSupport,
    ResponseStatus.ECRBusy,
    ResponseStatus.Timeout,
    ResponseStatus.UnknownError
  ];

  @override
  ResponseEvent EVENT_NAME = ResponseEvent.SALE_RESP;
  String TXN_ID;
  String STATUS;
  double TXN_AMT;
  double TIPS;
  PaymentType PAYMENT_TYPE;
  String RESP_CODE;
  String LOYALTY_TYPE;
  String CAMPAIGN_ID;
  String TRACE_NO;
  String TXN_DATE;
  String TXN_TIME;
  String HOST_REF;
  String COUPON_ID;
  String AUTH_CODE;
  double AUTH_AMT;
  double DISCOUNT;
  String LOCAL_CUR;
  String FOREIGN_CUR;
  double FXRATE;
  double FOREIGN_AMT;
  String MID;
  String TID;
  String PAN;
  String EXPIRY_DATE;
  String LOYALTY_REF;
  String AID;
  String BATCH_NO;
  String TC;
  String APP;
  String ACQUIRER;
  String IF_SIGN;
  String CARD_TAG;
  String CARD_TYPE;
  String ENTRY_MODE;
  String SIGN_DESC;
  String TVR;
  String TSI;
  String CARD_HOLDER;
  String TERMS;
  String DCC_VISA_TERMS;
  String DCC_MID;
  String REMAINED_VALUE;
  String SERIAL_NO;
  String LMS_ORIGINAL_BAL;
  String LMS_BAL;
  String LMS_USED;
  String LMS_BATCH_NO;
  String LMS_APPRV;

  SaleResponse(String jsonString) {
    RAW_JSON = jsonString;
    fillFromJson(jsonDecode(jsonString));
  }

  fillFromJson(Map<String, dynamic> json) {
    super.fillFromJson(json);
    TXN_ID = json['TXN_ID'];
    STATUS = json['STATUS'];
    TXN_AMT = json.containsKey("TXN_AMT") ? json['TXN_AMT'].toDouble() : null;
    TIPS = json.containsKey("TIPS") ? json['TIPS'].toDouble() : null;
    PAYMENT_TYPE = PaymentType.values.firstWhere(
        (type) => type.toShortString() == json['PAYMENT_TYPE'],
        orElse: () => null);
    RESP_CODE = json['RESP_CODE'];
    if (json['STATUS'] == '00') {
      LOYALTY_TYPE = json['LOYALTY_TYPE'];
      CAMPAIGN_ID = json['CAMPAIGN_ID'];
      TRACE_NO = json['TRACE_NO'];
      TXN_DATE = json['TXN_DATE'];
      TXN_TIME = json['TXN_TIME'];
      HOST_REF = json['HOST_REF'];
      COUPON_ID = json['COUPON_ID'];
      AUTH_CODE = json['AUTH_CODE'];
      AUTH_AMT =
          json.containsKey("AUTH_AMT") ? json['AUTH_AMT'].toDouble() : null;
      DISCOUNT =
          json.containsKey("DISCOUNT") ? json['DISCOUNT'].toDouble() : null;
      LOCAL_CUR = json['LOCAL_CUR'];
      FOREIGN_CUR = json['FOREIGN_CUR'];
      FXRATE = json.containsKey("FXRATE") ? json['FXRATE'].toDouble() : null;
      FOREIGN_AMT = json.containsKey("FOREIGN_AMT")
          ? json['FOREIGN_AMT'].toDouble()
          : null;
      MID = json['MID'];
      TID = json['TID'];
      PAN = json['PAN'];
      EXPIRY_DATE = json['EXPIRY_DATE'];
      LOYALTY_REF = json['LOYALTY_REF'];
      AID = json['AID'];
      BATCH_NO = json['BATCH_NO'];
      TC = json['TC'];
      APP = json['APP'];
      ACQUIRER = json['ACQUIRER'];
      IF_SIGN = json['IF_SIGN'];
      CARD_TAG = json['CARD_TAG'];
      CARD_TYPE = json['CARD_TYPE'];
      ENTRY_MODE = json['ENTRY_MODE'];
      SIGN_DESC = json['SIGN_DESC'];
      TVR = json['TVR'];
      TSI = json['TSI'];
      CARD_HOLDER = json['CARD_HOLDER'];
      TERMS = json['TERMS'];
      DCC_VISA_TERMS = json['DCC_VISA_TERMS'];
      DCC_MID = json['DCC_MID'];
      REMAINED_VALUE = json['REMAINED_VALUE'];
      SERIAL_NO = json['SERIAL_NO'];
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
        return ResponseStatusType.Success;
      case ResponseStatus.ConfirmingOrProcessing:
        return ResponseStatusType.TransactionProcessing;
      case ResponseStatus.ECRBusy:
        return ResponseStatusType.ProcessingAnotherRequest;
      case ResponseStatus.CancelledByUser:
      case ResponseStatus.DeclinedByHost:
      case ResponseStatus.ReversalByUser:
      case ResponseStatus.Timeout:
        return ResponseStatusType.Failed;
      case ResponseStatus.CommunicationOrFormatError:
      case ResponseStatus.FunctionOrPaymentTypeNotSupport:
      case ResponseStatus.UnknownError:
        return ResponseStatusType.Error;
    }
  }

/*
  SaleResponse.fromJson(Map<String, dynamic> json)
      : TXN_ID = json['TXN_ID'],
        STATUS = json['STATUS'],
        TXN_AMT =
            json.containsKey("TXN_AMT") ? json['TXN_AMT'].toDouble() : null,
        TIPS = json.containsKey("TIPS") ? json['TIPS'].toDouble() : null,
        PAYMENT_TYPE = PaymentType.values.firstWhere(
            (type) => type.toShortString() == json['PAYMENT_TYPE'],
            orElse: () => null),
        RESP_CODE = json['RESP_CODE'],
        LOYALTY_TYPE = json['LOYALTY_TYPE'],
        CAMPAIGN_ID = json['CAMPAIGN_ID'],
        TRACE_NO = json['TRACE_NO'],
        TXN_DATE = json['TXN_DATE'],
        TXN_TIME = json['TXN_TIME'],
        HOST_REF = json['HOST_REF'],
        COUPON_ID = json['COUPON_ID'],
        AUTH_CODE = json['AUTH_CODE'],
        AUTH_AMT =
            json.containsKey("AUTH_AMT") ? json['AUTH_AMT'].toDouble() : null,
        DISCOUNT =
            json.containsKey("DISCOUNT") ? json['DISCOUNT'].toDouble() : null,
        LOCAL_CUR = json['LOCAL_CUR'],
        FOREIGN_CUR = json['FOREIGN_CUR'],
        FXRATE = json.containsKey("FXRATE") ? json['FXRATE'].toDouble() : null,
        FOREIGN_AMT = json.containsKey("FOREIGN_AMT")
            ? json['FOREIGN_AMT'].toDouble()
            : null,
        MID = json['MID'],
        TID = json['TID'],
        PAN = json['PAN'],
        EXPIRY_DATE = json['EXPIRY_DATE'],
        LOYALTY_REF = json['LOYALTY_REF'],
        AID = json['AID'],
        BATCH_NO = json['BATCH_NO'],
        TC = json['TC'],
        APP = json['APP'],
        ACQUIRER = json['ACQUIRER'],
        IF_SIGN = json['IF_SIGN'],
        CARD_TAG = json['CARD_TAG'],
        CARD_TYPE = json['CARD_TYPE'],
        ENTRY_MODE = json['ENTRY_MODE'],
        SIGN_DESC = json['SIGN_DESC'],
        TVR = json['TVR'],
        TSI = json['TSI'],
        CARD_HOLDER = json['CARD_HOLDER'],
        TERMS = json['TERMS'],
        DCC_VISA_TERMS = json['DCC_VISA_TERMS'],
        DCC_MID = json['DCC_MID'],
        REMAINED_VALUE = json['REMAINED_VALUE'],
        SERIAL_NO = json['SERIAL_NO'],
        LMS_ORIGINAL_BAL = json['LMS_ORIGINAL_BAL'],
        LMS_BAL = json['LMS_BAL'],
        LMS_USED = json['LMS_USED'],
        LMS_BATCH_NO = json['LMS_BATCH_NO'],
        LMS_APPRV = json['LMS_APPRV'];
        */
}

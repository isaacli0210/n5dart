import 'package:n5client/N5Client/Constant/ResponseStatus.dart';
import 'package:n5client/N5Client/Constant/ResponseStatusType.dart';
import '../Constant/PaymentType.dart';
import '../ResponseType/LastTransactionRetrievalResponse.dart';
import '../ResponseType/SaleResponse.dart';
import '../interface/IResponseBody.dart';

class ClientSaleResponse {
  String TXN_TYPE;
  String TXN_ID;
  String STATUS;
  String TXN_STATUS;
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

  ClientSaleResponse(IResponseBody responseBody) {
    if (responseBody is SaleResponse) {
      _convertFromSaleResponse(responseBody);
    } else if (responseBody is LastTransactionRetrievalResponse) {
      _convertFromLastTransactionRetrievalResponse(responseBody);
    } else {
      throw Exception('Failed to convert the response (data type: ' +
          responseBody.runtimeType.toString() +
          ') to ClientSaleResponse.');
    }
  }

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
      case ResponseStatus.TransactionNotFind:
        return ResponseStatusType.Failed;
      case ResponseStatus.CommunicationOrFormatError:
      case ResponseStatus.FunctionOrPaymentTypeNotSupport:
      case ResponseStatus.UnknownError:
        return ResponseStatusType.Error;
      default:
        return ResponseStatusType.Error;
    }
  }

  _convertFromSaleResponse(SaleResponse responseBody) {
    this.TXN_TYPE = 'SALE';
    this.TXN_ID = responseBody.TXN_ID;
    this.STATUS = responseBody.STATUS;
    switch (responseBody.STATUS) {
      case '00':
        {
          this.TXN_STATUS = 'A';
        }
        break;
      case '03':
        {
          this.TXN_STATUS = 'P';
        }
        break;
      default:
        {
          this.TXN_STATUS = 'F';
        }
    }

    this.TXN_AMT = responseBody.TXN_AMT;
    this.TIPS = responseBody.TIPS;
    this.PAYMENT_TYPE = responseBody.PAYMENT_TYPE;
    this.RESP_CODE = responseBody.RESP_CODE;
    this.LOYALTY_TYPE = responseBody.LOYALTY_TYPE;
    this.CAMPAIGN_ID = responseBody.CAMPAIGN_ID;
    this.TRACE_NO = responseBody.TRACE_NO;
    this.TXN_DATE = responseBody.TXN_DATE;
    this.TXN_TIME = responseBody.TXN_TIME;
    this.HOST_REF = responseBody.HOST_REF;
    this.COUPON_ID = responseBody.COUPON_ID;
    this.AUTH_CODE = responseBody.AUTH_CODE;
    this.AUTH_AMT = responseBody.AUTH_AMT;
    this.DISCOUNT = responseBody.DISCOUNT;
    this.LOCAL_CUR = responseBody.LOCAL_CUR;
    this.FOREIGN_CUR = responseBody.FOREIGN_CUR;
    this.FXRATE = responseBody.FXRATE;
    this.FOREIGN_AMT = responseBody.FOREIGN_AMT;
    this.MID = responseBody.MID;
    this.TID = responseBody.TID;
    this.PAN = responseBody.PAN;
    this.EXPIRY_DATE = responseBody.EXPIRY_DATE;
    this.LOYALTY_REF = responseBody.LOYALTY_REF;
    this.AID = responseBody.AID;
    this.BATCH_NO = responseBody.BATCH_NO;
    this.TC = responseBody.TC;
    this.APP = responseBody.APP;
    this.ACQUIRER = responseBody.ACQUIRER;
    this.IF_SIGN = responseBody.IF_SIGN;
    this.CARD_TAG = responseBody.CARD_TAG;
    this.CARD_TYPE = responseBody.CARD_TYPE;
    this.ENTRY_MODE = responseBody.ENTRY_MODE;
    this.SIGN_DESC = responseBody.SIGN_DESC;
    this.TVR = responseBody.TVR;
    this.TSI = responseBody.TSI;
    this.CARD_HOLDER = responseBody.CARD_HOLDER;
    this.TERMS = responseBody.TERMS;
    this.DCC_VISA_TERMS = responseBody.DCC_VISA_TERMS;
    this.DCC_MID = responseBody.DCC_MID;
    this.REMAINED_VALUE = responseBody.REMAINED_VALUE;
    this.SERIAL_NO = responseBody.SERIAL_NO;
    this.LMS_ORIGINAL_BAL = responseBody.LMS_ORIGINAL_BAL;
    this.LMS_BAL = responseBody.LMS_BAL;
    this.LMS_USED = responseBody.LMS_USED;
    this.LMS_BATCH_NO = responseBody.LMS_BATCH_NO;
    this.LMS_APPRV = responseBody.LMS_APPRV;
  }

  _convertFromLastTransactionRetrievalResponse(
      LastTransactionRetrievalResponse responseBody) {
    this.TXN_TYPE = responseBody.TXN_TYPE;
    this.TXN_ID = responseBody.TXN_ID;
    this.STATUS = responseBody.STATUS;
    this.TXN_STATUS = responseBody.TXN_STATUS;
    this.TXN_AMT = responseBody.TXN_AMT;
    this.TIPS = responseBody.TIPS;
    this.PAYMENT_TYPE = responseBody.PAYMENT_TYPE;
    this.RESP_CODE = responseBody.RESP_CODE;
    this.LOYALTY_TYPE = responseBody.LOYALTY_TYPE;
    this.CAMPAIGN_ID = responseBody.CAMPAIGN_ID;
    this.TRACE_NO = responseBody.TRACE_NO;
    this.TXN_DATE = responseBody.TXN_DATE;
    this.TXN_TIME = responseBody.TXN_TIME;
    this.HOST_REF = responseBody.HOST_REF;
    this.COUPON_ID = responseBody.COUPON_ID;
    this.AUTH_CODE = responseBody.AUTH_CODE;
    this.AUTH_AMT = responseBody.AUTH_AMT;
    this.DISCOUNT = responseBody.DISCOUNT;
    this.LOCAL_CUR = responseBody.LOCAL_CUR;
    this.FOREIGN_CUR = responseBody.FOREIGN_CUR;
    this.FXRATE = responseBody.FXRATE;
    this.FOREIGN_AMT = responseBody.FOREIGN_AMT;
    this.MID = responseBody.MID;
    this.TID = responseBody.TID;
    this.PAN = responseBody.PAN;
    this.EXPIRY_DATE = responseBody.EXPIRY_DATE;
    this.LOYALTY_REF = responseBody.LOYALTY_REF;
    this.AID = responseBody.AID;
    this.BATCH_NO = responseBody.BATCH_NO;
    this.TC = responseBody.TC;
    this.APP = responseBody.APP;
    this.ACQUIRER = responseBody.ACQUIRER;
    this.IF_SIGN = responseBody.IF_SIGN;
    this.CARD_TAG = responseBody.CARD_TAG;
    this.CARD_TYPE = responseBody.CARD_TYPE;
    this.ENTRY_MODE = responseBody.ENTRY_MODE;
    this.SIGN_DESC = responseBody.SIGN_DESC;
    this.TVR = responseBody.TVR;
    this.TSI = responseBody.TSI;
    this.CARD_HOLDER = responseBody.CARD_HOLDER;
    this.TERMS = responseBody.TERMS;
    this.DCC_VISA_TERMS = responseBody.DCC_VISA_TERMS;
    this.DCC_MID = responseBody.DCC_MID;
    this.REMAINED_VALUE = responseBody.REMAINED_VALUE;
    this.SERIAL_NO = responseBody.SERIAL_NO;
    this.LMS_ORIGINAL_BAL = responseBody.LMS_ORIGINAL_BAL;
    this.LMS_BAL = responseBody.LMS_BAL;
    this.LMS_USED = responseBody.LMS_USED;
    this.LMS_BATCH_NO = responseBody.LMS_BATCH_NO;
    this.LMS_APPRV = responseBody.LMS_APPRV;
  }
}

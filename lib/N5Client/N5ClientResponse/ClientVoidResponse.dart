import 'package:n5client/N5Client/Constant/PaymentType.dart';
import 'package:n5client/N5Client/Constant/ResponseStatus.dart';
import 'package:n5client/N5Client/Constant/ResponseStatusType.dart';
import 'package:n5client/N5Client/ResponseType/LastTransactionRetrievalResponse.dart';
import 'package:n5client/N5Client/ResponseType/VoidResponse.dart';
import 'package:n5client/N5Client/interface/IResponseBody.dart';

class ClientVoidResponse {
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

  ClientVoidResponse(IResponseBody responseBody) {
    if (responseBody is VoidResponse) {
      _convertFromVoidResponse(responseBody);
    } else if (responseBody is LastTransactionRetrievalResponse) {
      _convertFromLastTransactionRetrievalResponse(responseBody);
    } else {
      throw Exception('Failed to convert the response (data type: ' +
          responseBody.runtimeType.toString() +
          ') to ClientVoidResponse.');
    }
  }

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
        return ResponseStatusType.Failed;
      case ResponseStatus.CommunicationOrFormatError:
      case ResponseStatus.FunctionOrPaymentTypeNotSupport:
      case ResponseStatus.Timeout:
      case ResponseStatus.UnknownError:
        return ResponseStatusType.Error;
      case ResponseStatus.ECRBusy:
        return ResponseStatusType.ProcessingAnotherRequest;
    }
  }

  _convertFromVoidResponse(VoidResponse responseBody) {
    this.TXN_ID = responseBody.TXN_ID;
    this.STATUS = responseBody.STATUS;
    this.PAYMENT_TYPE = responseBody.PAYMENT_TYPE;
    this.RESP_CODE = responseBody.RESP_CODE;
    this.TXN_DATE = responseBody.TXN_DATE;
    this.TXN_TIME = responseBody.TXN_TIME;
    this.HOST_REF = responseBody.HOST_REF;
    this.BATCH_NO = responseBody.BATCH_NO;
    this.MID = responseBody.MID;
    this.TID = responseBody.TID;
    this.PAN = responseBody.PAN;
    this.TXN_AMT = responseBody.TXN_AMT;
    this.TRACE_NO = responseBody.TRACE_NO;
    this.AUTH_CODE = responseBody.AUTH_CODE;
    this.CARD_HOLDER = responseBody.CARD_HOLDER;
    this.APP = responseBody.APP;
    this.ACQUIRER = responseBody.ACQUIRER;
    this.TERMS = responseBody.TERMS;
    this.DCC_VISA_TERMS = responseBody.DCC_VISA_TERMS;
    this.DCC_MID = responseBody.DCC_MID;
    this.LMS_ORIGINAL_BAL = responseBody.LMS_ORIGINAL_BAL;
    this.LMS_BAL = responseBody.LMS_BAL;
    this.LMS_USED = responseBody.LMS_USED;
    this.LMS_BATCH_NO = responseBody.LMS_BATCH_NO;
    this.LMS_APPRV = responseBody.LMS_APPRV;
  }

  _convertFromLastTransactionRetrievalResponse(
      LastTransactionRetrievalResponse responseBody) {
    this.TXN_ID = responseBody.TXN_ID;
    this.STATUS = responseBody.STATUS;
    this.PAYMENT_TYPE = responseBody.PAYMENT_TYPE;
    this.RESP_CODE = responseBody.RESP_CODE;
    this.TXN_DATE = responseBody.TXN_DATE;
    this.TXN_TIME = responseBody.TXN_TIME;
    this.HOST_REF = responseBody.HOST_REF;
    this.BATCH_NO = responseBody.BATCH_NO;
    this.MID = responseBody.MID;
    this.TID = responseBody.TID;
    this.PAN = responseBody.PAN;
    this.TXN_AMT = responseBody.TXN_AMT;
    this.TRACE_NO = responseBody.TRACE_NO;
    this.AUTH_CODE = responseBody.AUTH_CODE;
    this.CARD_HOLDER = responseBody.CARD_HOLDER;
    this.APP = responseBody.APP;
    this.ACQUIRER = responseBody.ACQUIRER;
    this.TERMS = responseBody.TERMS;
    this.DCC_VISA_TERMS = responseBody.DCC_VISA_TERMS;
    this.DCC_MID = responseBody.DCC_MID;
    this.LMS_ORIGINAL_BAL = responseBody.LMS_ORIGINAL_BAL;
    this.LMS_BAL = responseBody.LMS_BAL;
    this.LMS_USED = responseBody.LMS_USED;
    this.LMS_BATCH_NO = responseBody.LMS_BATCH_NO;
    this.LMS_APPRV = responseBody.LMS_APPRV;
  }
}

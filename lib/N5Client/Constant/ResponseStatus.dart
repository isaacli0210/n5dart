abstract class ResponseStatus {
  static const String ApprovedOrAcceptedByHost = "00";
  static const String RefundProcessingOrAccepted = "02";
  static const String ConfirmingOrProcessing = "03";
  static const String CancelledByUser = "09";
  static const String DeclinedByHost = "10";
  static const String ReversalByUser = "11";
  static const String TransactionCompleted = "12";
  static const String TransactionNotFind = "13";
  static const String TenderNotSupport = "14";
  static const String CommunicationOrFormatError = "90";
  static const String FunctionOrPaymentTypeNotSupport = "91";
  static const String ECRBusy = "97";
  static const String Timeout = "98";
  static const String UnknownError = "99";
}

/*
enum ResponseStatus {
  ApprovedOrAcceptedByHost, //00
  RefundProcessingOrAccepted, //02
  ConfirmingOrProcessing, //03
  CancelledByUser, //09
  DeclinedByHost, //10
  ReversalByUser, //11
  TransactionCompleted, //12
  TransactionNotFind, //13
  TenderNotSupport, //14
  CommunicationOrFormatError, //90
  FunctionOrPaymentTypeNotSupport, //91
  ECRBusy, //97
  Timeout, //98
  UnknownError //99
}
*/

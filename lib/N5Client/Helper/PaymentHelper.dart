import 'package:n5client/N5Client/Constant/PaymentType.dart';
import 'package:n5client/N5Client/Constant/ResponseStatus.dart';

class PaymentHelper {
  static PaymentType getPaymentTypeFromCode(String code) {
    if (code != null) {
      PaymentType.values.forEach((name) {
        if (name.toShortString() == code.toUpperCase().replaceAll('-', ''))
          return name;
      });
    }
    return null;
  }

  static String getResponseStatusDescription(String status) {
    switch (status) {
      case ResponseStatus.ApprovedOrAcceptedByHost:
        return 'Approved/Accepted by host';
      case ResponseStatus.RefundProcessingOrAccepted:
        return 'Refund Processing/ Accepted by host (Only for QRC)';
      case ResponseStatus.ConfirmingOrProcessing:
        return 'Confirming/ Processing';
      case ResponseStatus.CancelledByUser:
        return 'Cancelled by user';
      case ResponseStatus.DeclinedByHost:
        return 'Declined by host';
      case ResponseStatus.ReversalByUser:
        return 'Reversal by User (Applied for Wechat/Alipay Only)';
      case ResponseStatus.TransactionCompleted:
        return 'Transaction has already voided/completed/reversed';
      case ResponseStatus.TransactionNotFind:
        return 'Transaction does not find';
      case ResponseStatus.TenderNotSupport:
        return 'Tender does not support';
      case ResponseStatus.CommunicationOrFormatError:
        return 'Communication/Format Error';
      case ResponseStatus.FunctionOrPaymentTypeNotSupport:
        return 'Function or Payment Type does not supported';
      case ResponseStatus.ECRBusy:
        return 'ECR busy';
      case ResponseStatus.Timeout:
        return 'Timeout';
      case ResponseStatus.UnknownError:
        return 'Unknown Error';
      default:
        return '';
    }
  }
}

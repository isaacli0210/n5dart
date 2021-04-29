import 'package:n5client/N5Client/Constant/PaymentApplication.dart';
import 'package:n5client/N5Client/Constant/RequestEvent.dart';
import 'package:n5client/N5Client/interface/IRequestBody.dart';

class RefundRequest implements IRequestBody {
  @override
  // ignore: non_constant_identifier_names
  RequestEvent EVENT_NAME = RequestEvent.REFUND;
  String TXN_ID;
  double TXN_AMT;
  String PAYMENT_APP_ID;
  String QRC_VALUE;
  String MERCHANT_REF;
  String TXN_DATE;
  String HOST_REF;

  RefundRequest(String txn_id, double txn_amt,
      {PaymentApplication paymentApp,
      String qrCode,
      String merchant_ref,
      String txn_date,
      String host_ref}) {
    this.TXN_ID = txn_id;
    this.TXN_AMT = txn_amt;
    this.PAYMENT_APP_ID = paymentApp.toShortString();
    this.QRC_VALUE = qrCode;
    this.MERCHANT_REF = merchant_ref;
    this.TXN_DATE = txn_date;
    this.HOST_REF = host_ref;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {
      'EVENT_NAME': this.EVENT_NAME.toShortString(),
      'TXN_ID': this.TXN_ID,
      'TXN_AMT': this.TXN_AMT,
      'PAYMENT_APP_ID': this.PAYMENT_APP_ID,
      'QRC_VALUE': this.QRC_VALUE,
      'MERCHANT_REF': this.MERCHANT_REF,
      'TXN_DATE': this.TXN_DATE,
      'HOST_REF': this.HOST_REF
    };
    jsonMap.removeWhere((key, value) => value == null);
    return jsonMap;
  }
}

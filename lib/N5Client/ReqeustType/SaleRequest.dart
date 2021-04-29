import 'package:n5client/N5Client/Constant/PaymentApplication.dart';
import 'package:n5client/N5Client/Constant/RequestEvent.dart';
import 'package:n5client/N5Client/ResponseType/SaleResponse.dart';
import 'package:n5client/N5Client/interface/IRequestBody.dart';

class SaleRequest implements IRequestBody {
  @override
  // ignore: non_constant_identifier_names
  RequestEvent EVENT_NAME = RequestEvent.SALE;
  String TXN_ID;
  double TXN_AMT;
  String PAYMENT_APP_ID;

  SaleRequest(String txn_id, double txn_amt, PaymentApplication paymentApp) {
    this.TXN_ID = txn_id;
    this.TXN_AMT = txn_amt;
    this.PAYMENT_APP_ID = paymentApp.toShortString();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {
      'EVENT_NAME': this.EVENT_NAME.toShortString(),
      'TXN_ID': this.TXN_ID,
      'TXN_AMT': this.TXN_AMT,
      'PAYMENT_APP_ID': this.PAYMENT_APP_ID
    };
    jsonMap.removeWhere((key, value) => value == null);
    return jsonMap;
  }
}

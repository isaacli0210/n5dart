import 'package:n5client/N5Client/Constant/RequestEvent.dart';
import 'package:n5client/N5Client/interface/IRequestBody.dart';

class PrintRequest implements IRequestBody {
  @override
  // ignore: non_constant_identifier_names
  RequestEvent EVENT_NAME = RequestEvent.PRINT;
  String TXN_ID;
  bool IS_REPRINT;
  String MERCHANT_REF;

  PrintRequest(bool is_reprint, {String txn_id, String merchant_ref}) {
    this.TXN_ID = txn_id;
    this.IS_REPRINT = is_reprint;
    this.MERCHANT_REF = merchant_ref;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {
      'EVENT_NAME': this.EVENT_NAME.toShortString(),
      'TXN_ID': this.TXN_ID,
      'IS_REPRINT': this.IS_REPRINT,
      'MERCHANT_REF': this.MERCHANT_REF
    };
    jsonMap.removeWhere((key, value) => value == null);
    return jsonMap;
  }
}

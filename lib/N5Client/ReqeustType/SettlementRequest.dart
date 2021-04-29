import 'package:intl/intl.dart';
import 'package:n5client/N5Client/Constant/RequestEvent.dart';
import 'package:n5client/N5Client/interface/IRequestBody.dart';

class SettlementRequest implements IRequestBody {
  @override
  // ignore: non_constant_identifier_names
  RequestEvent EVENT_NAME = RequestEvent.SETTLE;
  String MERCHANT_REF;

  SettlementRequest([String merchant_ref]) {
    this.MERCHANT_REF = merchant_ref;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {
      'EVENT_NAME': this.EVENT_NAME.toShortString(),
      'MERCHANT_REF': this.MERCHANT_REF
    };
    jsonMap.removeWhere((key, value) => value == null);
    return jsonMap;
  }
}

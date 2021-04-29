import 'package:intl/intl.dart';
import 'package:n5client/N5Client/Constant/RequestEvent.dart';
import 'package:n5client/N5Client/interface/IRequestBody.dart';

class SettleEnquiryRequest implements IRequestBody {
  @override
  // ignore: non_constant_identifier_names
  RequestEvent EVENT_NAME = RequestEvent.SETTLE_ENQUIRY;
  String BATCH_ID;

  SettleEnquiryRequest(String batch_id) {
    this.BATCH_ID = batch_id;
  }

  Map<String, dynamic> toJson() => {
        'EVENT_NAME': this.EVENT_NAME.toShortString(),
        'BATCH_ID': this.BATCH_ID
      };
}

import 'package:intl/intl.dart';
import 'package:n5client/N5Client/Constant/RequestEvent.dart';
import 'package:n5client/N5Client/interface/IRequestBody.dart';

class BatchEnquiryRequest implements IRequestBody {
  @override
  // ignore: non_constant_identifier_names
  RequestEvent EVENT_NAME = RequestEvent.BATCH_ENQUIRY;
  String SETTLE_DATE;

  BatchEnquiryRequest(DateTime settle_date) {
    this.SETTLE_DATE = DateFormat("yyyyMMdd").format(settle_date);
  }

  Map<String, dynamic> toJson() => {
        'EVENT_NAME': this.EVENT_NAME.toShortString(),
        'SETTLE_DATE': this.SETTLE_DATE
      };
}

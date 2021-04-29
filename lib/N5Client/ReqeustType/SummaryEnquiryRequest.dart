import 'package:intl/intl.dart';
import 'package:n5client/N5Client/Constant/RequestEvent.dart';
import 'package:n5client/N5Client/interface/IRequestBody.dart';

class SummaryEnquiryRequest implements IRequestBody {
  @override
  // ignore: non_constant_identifier_names
  RequestEvent EVENT_NAME = RequestEvent.SUMMARY_ENQUIRY;
  String TXN_DATE_START_TO_END = '';

  SummaryEnquiryRequest([DateTime txn_start_date, DateTime txn_end_date]) {
    if (txn_start_date != null) {
      txn_end_date = txn_end_date != null ? txn_end_date : DateTime.now();
      String startDate = DateFormat("yyyyMMdd").format(txn_start_date);
      String endDate = DateFormat("yyyyMMdd").format(txn_end_date);
      this.TXN_DATE_START_TO_END = startDate + '-' + endDate;
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {
      'EVENT_NAME': this.EVENT_NAME.toShortString(),
      'TXN_DATE_START_TO_END': this.TXN_DATE_START_TO_END
    };
    jsonMap.removeWhere((key, value) => value == null);
    return jsonMap;
  }
}

import 'package:n5client/N5Client/Constant/RequestEvent.dart';
import 'package:n5client/N5Client/interface/IRequestBody.dart';

class LastTransactionRetrievalRequest implements IRequestBody {
  @override
  // ignore: non_constant_identifier_names
  RequestEvent EVENT_NAME = RequestEvent.RETRIEVAL;
  String TXN_ID;

  LastTransactionRetrievalRequest(String txn_id) {
    this.TXN_ID = txn_id;
  }

  Map<String, dynamic> toJson() =>
      {'EVENT_NAME': this.EVENT_NAME.toShortString(), 'TXN_ID': this.TXN_ID};
}

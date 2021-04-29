import 'package:n5client/N5Client/Constant/RequestEvent.dart';
import 'package:n5client/N5Client/interface/IRequestBody.dart';

class AbortRequest implements IRequestBody {
  @override
  // ignore: non_constant_identifier_names
  RequestEvent EVENT_NAME = RequestEvent.ABORT;

  Map<String, dynamic> toJson() =>
      {'EVENT_NAME': this.EVENT_NAME.toShortString()};
}

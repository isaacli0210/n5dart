import 'package:n5client/N5Client/Constant/RequestEvent.dart';

abstract class IRequestBody {
  // ignore: non_constant_identifier_names
  RequestEvent EVENT_NAME;

  Map<String, dynamic> toJson();
}

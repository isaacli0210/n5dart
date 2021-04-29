import 'package:n5client/N5Client/Constant/ResponseEvent.dart';
import 'package:n5client/N5Client/Constant/ResponseStatus.dart';
import 'package:n5client/N5Client/Constant/ResponseStatusType.dart';
import 'package:n5client/N5Client/interface/IResponseBody.dart';

class SettlementResponse extends IResponseBody {
  List<String> allowedStatus = [
    ResponseStatus.ApprovedOrAcceptedByHost,
    ResponseStatus.CancelledByUser,
    ResponseStatus.CommunicationOrFormatError,
    ResponseStatus.FunctionOrPaymentTypeNotSupport,
    ResponseStatus.ECRBusy,
    ResponseStatus.Timeout,
    ResponseStatus.UnknownError
  ];

  @override
  ResponseEvent EVENT_NAME = ResponseEvent.SETTLE_RESP;
  String STATUS;

  SettlementResponse(Map<String, dynamic> json) {
    fillFromJson(json);
  }

  fillFromJson(Map<String, dynamic> json) {
    super.fillFromJson(json);
    STATUS = json['STATUS'];
  }

  @override
  ResponseStatusType getResponseStatusType() {
    switch (STATUS) {
      case ResponseStatus.ApprovedOrAcceptedByHost:
        return ResponseStatusType.Success;
      case ResponseStatus.ECRBusy:
        return ResponseStatusType.ProcessingAnotherRequest;
      case ResponseStatus.DeclinedByHost:
        return ResponseStatusType.Failed;
      case ResponseStatus.CancelledByUser:
      case ResponseStatus.CommunicationOrFormatError:
      case ResponseStatus.FunctionOrPaymentTypeNotSupport:
      case ResponseStatus.Timeout:
      case ResponseStatus.UnknownError:
        return ResponseStatusType.Error;
    }
  }
}

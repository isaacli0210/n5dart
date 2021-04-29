enum ResponseEvent {
  SALE_RESP,
  VOID_RESP,
  REFUND_RESP,
  ADJUST_RESP,
  PREAUTH_RESP,
  OFFLINE_RESP,
  INSTL_RESP,
  SETTLE_RESP,
  SCAN_RESP,
  RETRIEVAL_RESP,
  ECHO_RESP,
  PRINT_RESP,
  ABORT_RESP,
  PARAM_RESP,
  BATCH_ENQUIRY_RESP,
  SETTLE_ENQUIRY_RESP,
  SUMMARY_ENQUIRY_RESP,
  UNSETTLED_ENQUIRY_RESP
}

extension ResponseEventHelper on ResponseEvent {
  String toShortString() {
    return this.toString().split('.').last;
  }

  ResponseEvent getRequestEventFromCode(String code) {
    if (code != null) {
      ResponseEvent.values.forEach((name) {
        if (name.toShortString() == code.toUpperCase()) return name;
      });
    }
    return null;
  }
}

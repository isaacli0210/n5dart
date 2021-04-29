enum RequestEvent {
  SALE,
  VOID,
  REFUND,
  //ADJUST,
  //PREAUTH,
  //OFFLINE,
  //INSTL,
  SETTLE,
  SCAN,
  RETRIEVAL,
  ECHO,
  PRINT,
  ABORT,
  PARAM,
  BATCH_ENQUIRY,
  SETTLE_ENQUIRY,
  SUMMARY_ENQUIRY,
  UNSETTLED_ENQUIRY
}

extension RequestEventHelper on RequestEvent {
  String toShortString() {
    return this.toString().split('.').last;
  }

  RequestEvent getRequestEventFromCode(String code) {
    if (code != null) {
      RequestEvent.values.forEach((name) {
        if (name.toShortString() == code.toUpperCase()) return name;
      });
    }
    return null;
  }
}

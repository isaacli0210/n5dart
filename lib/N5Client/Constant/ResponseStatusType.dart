/// The ResponseStatusType is created by the N5 client library to simplify
/// and classify different response statuses from N5 Terminal.
/// So that the client can quickly determine the response status type.
/// There are 4 differents status type
///  - Error
///  - ProcessingAnotherRequest
///  - TransactionProcessing
///  - Success
enum ResponseStatusType {
  /// N5 terminal return an error, client should based on the response [STATUS] field
  /// find the correspording ResponseStatus and further processing.
  Error,

  /// Failed indicates that the N5 terminal has sent the request to backend gateway and the
  /// response back to the N5 terminal within the limited timeframe.
  Failed,

  /// N5 terminal is now handling another request, client should prompt message to ask user
  /// to complete current transaction before send another request.
  ProcessingAnotherRequest,

  /// TransactionProcessing indicates that the N5 terminal has sent the request to backend gateway.
  /// but it is still waiting backend gateway for a response.
  /// Client should be keep polling to the N5 terminal to check the latest transaction status.
  /// Vendor recommends polling (Transaction Retrieval) every 3 seconds, max 30 times.
  /// If the polling limit is exceeded, the client should judged as payment failure.
  TransactionProcessing,

  /// Success indicates that the N5 terminal has sent the request to backend gateway and the
  /// response back to the N5 terminal within the limited timeframe.
  Success,
}

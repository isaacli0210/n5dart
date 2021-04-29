abstract class TransactionStatus {
  static const String ApprovedAccepted = "A";
  static const String ConfirmingProcessing = "P";
  static const String Voided = "V";
  static const String Settled = "S";
  static const String DeclinedCancelled = "F";
  static const String OctopusTimeout = "T";

  static String getDescription(String status) {
    switch (status) {
      case TransactionStatus.ApprovedAccepted:
        return "Approved/Accepted by host";
      case TransactionStatus.ConfirmingProcessing:
        return "Confirming/Processing";
      case TransactionStatus.Voided:
        return "Voided";
      case TransactionStatus.Settled:
        return "Settled";
      case TransactionStatus.DeclinedCancelled:
        return "Declined/Cancelled/Reversed/Operational Timeout";
      case TransactionStatus.OctopusTimeout:
        return "Octopus read card timeout";
      default:
        return "";
    }
  }
}

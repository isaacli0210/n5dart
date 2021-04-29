enum PaymentApplication { CC, QRC, CPN, AE, DC, FPS, OPS, EPS }

extension PaymentApplicationHelper on PaymentApplication {
  String toShortString() {
    return this.toString().split('.').last;
  }

  PaymentApplication getRequestEventFromCode(String code) {
    if (code != null) {
      PaymentApplication.values.forEach((name) {
        if (name.toShortString() == code.toUpperCase()) return name;
      });
    }
    return null;
  }

  String getDescription() {
    switch (this) {
      case PaymentApplication.CC:
        return 'Credit Card';
      case PaymentApplication.QRC:
        return 'QR/Barcode Payment';
      case PaymentApplication.CPN:
        return 'Coupon Usage';
      case PaymentApplication.AE:
        return 'AMEX';
      case PaymentApplication.DC:
        return 'Diner Club';
      case PaymentApplication.FPS:
        return 'Fast Payment Service';
      case PaymentApplication.OPS:
        return 'Octopus';
      case PaymentApplication.EPS:
        return 'Easy Pay System';
      default:
        return '';
    }
  }
}

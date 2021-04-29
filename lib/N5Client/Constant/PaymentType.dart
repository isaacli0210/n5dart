enum PaymentType {
  VC,
  VCQR,
  MC,
  MCQR,
  JCB,
  JCBQR,
  UP,
  UPQR,
  AE,
  DC,
  ALP,
  WCP,
  FPS,
  OPS,
  EPS
}

extension PaymentTypeHelper on PaymentType {
  String toShortString() {
    return this.toString().split('.').last;
  }

  bool isQRCodePaymentTypes() {
    return [
      PaymentType.VCQR,
      PaymentType.MCQR,
      PaymentType.JCBQR,
      PaymentType.UPQR,
      PaymentType.ALP,
      PaymentType.WCP
    ].contains(this);
  }

  bool getCCPaymentTypes() {
    return [
      PaymentType.VC,
      PaymentType.MC,
      PaymentType.JCB,
      PaymentType.UP,
      PaymentType.AE
    ].contains(this);
  }

  String getDescription() {
    switch (this) {
      case PaymentType.VC:
        return 'Visa Card';
      case PaymentType.VCQR:
        return 'Visa Card QR';
      case PaymentType.MC:
        return 'Master Card';
      case PaymentType.MCQR:
        return 'Master Card QR';
      case PaymentType.JCB:
        return 'JCB';
      case PaymentType.JCBQR:
        return 'JCB QR';
      case PaymentType.UP:
        return 'Unionpay';
      case PaymentType.UPQR:
        return 'Unionpay QR';
      case PaymentType.AE:
        return 'American Express';
      case PaymentType.DC:
        return 'Diners Club';
      case PaymentType.ALP:
        return 'Alipay';
      case PaymentType.WCP:
        return 'Wechat Pay';
      case PaymentType.FPS:
        return 'FPS';
      case PaymentType.OPS:
        return 'Octopus';
      case PaymentType.EPS:
        return 'EPS';
      default:
        return '';
    }
  }
}

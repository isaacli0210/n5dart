import 'package:flutter/material.dart';
import 'package:n5client/N5Client/Constant/RequestEvent.dart';
import 'package:n5client/N5Client/interface/IRequestBody.dart';

class VoidRequest implements IRequestBody {
  @override
  // ignore: non_constant_identifier_names
  RequestEvent EVENT_NAME = RequestEvent.VOID;
  String TXN_ID;
  String QRC_VALUE;
  String MERCHANT_REF;

  VoidRequest({String txn_id, String qrCode, String merchantRef}) {
    this.TXN_ID = txn_id;
    this.QRC_VALUE = qrCode;
    this.MERCHANT_REF = merchantRef;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {
      'EVENT_NAME': this.EVENT_NAME.toShortString(),
      'TXN_ID': this.TXN_ID,
      'QRC_VALUE': this.QRC_VALUE,
      'MERCHANT_REF': this.MERCHANT_REF
    };
    jsonMap.removeWhere((key, value) => value == null);
    return jsonMap;
  }
}

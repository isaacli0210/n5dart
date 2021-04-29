import 'dart:convert';
import 'dart:typed_data';

import 'package:intl/intl.dart';

class ResponseMsg {
  Uint8List byteData;
  int msgLen;
  String msgBody;
  Map<String, dynamic> responseBodyInJson;

  ResponseMsg(Uint8List data) {
    this.byteData = data;
    this.msgLen = _getMsgLen(data[1], data[2]);
    this.msgBody = _getMsgBody(data, msgLen);
    this.responseBodyInJson = jsonDecode(this.msgBody);
    //print("byteData:${this.byteData}");
    //print("msgLen:${this.msgLen}");
    print("msgBody:${this.msgBody}");
  }

  int _getMsgLen(int len1, int len2) {
    String strMsgLen, strMsgLen1, strMsgLen2, strMsgLen3, strMsgLen4;
    int result;
    var f = new NumberFormat("0", "en_US");
    strMsgLen1 = f.format(((len1 & 0xf0) >> 4) & 0x0f);
    strMsgLen2 = f.format(len1 & 0x0f);
    strMsgLen3 = f.format(((len2 & 0xf0) >> 4) & 0x0f);
    strMsgLen4 = f.format(len2 & 0x0f);
    strMsgLen = strMsgLen1 + strMsgLen2 + strMsgLen3 + strMsgLen4;
    result = int.parse(strMsgLen);
    return result;
  }

  String _getMsgBody(Uint8List data, int len) {
    Uint8List uData = new Uint8List(len);

    for (int i = 0; i < len; i++) {
      uData[i] = data[i + 3];
    }
    String result = new Utf8Decoder().convert(uData);
    return result;
  }
}

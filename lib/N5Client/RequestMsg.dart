import 'dart:convert';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:crypto/crypto.dart';
import 'package:n5client/N5Client/interface/IRequestBody.dart';

class RequestMsg {
  IRequestBody requestBody;
  String requestBodyInJson;
  Int8List _composedMsg;

  RequestMsg(IRequestBody requestBody) {
    this.requestBody = requestBody;
    this.requestBodyInJson = jsonEncode(requestBody);
    this._composedMsg = _composeMsg(this.requestBodyInJson);
    print("msgBody:${requestBodyInJson}");
  }

  Int8List getComposedMsg() {
    return _composedMsg;
  }

  Int8List _composeMsg(String msgBody) {
    Int8List _digestBytes = _getDigestBytes(msgBody);
    Int8List _bcdBytes = _getMsgLengthBCD(msgBody.length);
    Int8List _msgBodyBytes = _getMsgBytes(msgBody);
    int stx = 0x02;
    int etx = 0x03;
    int _msgLen =
        1 + _bcdBytes.length + _msgBodyBytes.length + _digestBytes.length + 1;
    Int8List result = Int8List(_msgLen);
    result[0] = stx;
    result[1] = _bcdBytes[0];
    result[2] = _bcdBytes[1];
    for (var i = 0; i < _msgBodyBytes.length; i++) {
      result[i + 3] = _msgBodyBytes[i];
    }
    for (var i = 0; i < _digestBytes.length; i++) {
      result[i + 3 + _msgBodyBytes.length] = _digestBytes[i];
    }
    result[_msgLen - 1] = etx;
    return result;
  }

  Int8List _getDigestBytes(String msgBody) {
    String macKey = "0EAEA18F7A46B9C8765B3DB313267C75";
    var _msgBodyPlusKeyBytes = utf8.encode(msgBody + '&' + macKey);
    var _digest = md5.convert(_msgBodyPlusKeyBytes);
    Int8List result = _hexStr2BCD(_digest.toString());
    return result;
  }

  Int8List _getMsgLengthBCD(int msgLen) {
    Int8List result = new Int8List(2);
    var f = new NumberFormat("0000", "en_US");
    String lengthStr = f.format(msgLen);
    int i0 = int.parse(lengthStr.substring(0, 1));
    int i1 = int.parse(lengthStr.substring(1, 2));
    int i2 = int.parse(lengthStr.substring(2, 3));
    int i3 = int.parse(lengthStr.substring(3, 4));
    // print('i0-3: $i0, $i1, $i2, $i3');
    result[0] = i0 << 4 | i1;
    result[1] = i2 << 4 | i3;
    //print('result: $result');
    return result;
  }

  Int8List _getMsgBytes(String msgBody) {
    Int8List result = Int8List(msgBody.length);

    Uint8List _msgBodyBytes = new Utf8Encoder().convert(msgBody);
    for (var i = 0; i < msgBody.length; i++) {
      result[i] = _msgBodyBytes[i];
    }
    return result;
  }

  Int8List _hexStr2BCD(String hexString) {
    Int8List result = new Int8List(hexString.length ~/ 2);
    for (int i = 0; i < hexString.length; i += 2) {
      int h = int.parse(hexString[i], radix: 16);
      int l = int.parse(hexString[i + 1], radix: 16);
      result[i ~/ 2] = h << 4 | l;
      // print("i:$i, h:$h, l:$l");
    }
    return result;
  }
}

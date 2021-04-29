import 'dart:io';
import 'dart:async';
import 'package:n5client/N5Client/Common/N5SocketException.dart';
import 'package:n5client/N5Client/Constant/RequestEvent.dart';
import 'package:n5client/N5Client/Constant/ResponseStatus.dart';
import 'package:n5client/N5Client/Constant/TransactionStatus.dart';
import 'package:n5client/N5Client/N5ClientResponse/ClientSaleResponse.dart';
import 'package:n5client/N5Client/ReqeustType/AbortRequest.dart';
import 'package:n5client/N5Client/ReqeustType/BatchEnquiryRequest.dart';
import 'package:n5client/N5Client/ReqeustType/LinkTestRequest.dart';
import 'package:n5client/N5Client/ReqeustType/ParamsRequest.dart';
import 'package:n5client/N5Client/ReqeustType/PrintRequest.dart';
import 'package:n5client/N5Client/ReqeustType/ScanRequest.dart';
import 'package:n5client/N5Client/ReqeustType/SettleEnquiryRequest.dart';
import 'package:n5client/N5Client/ReqeustType/SettlementRequest.dart';
import 'package:n5client/N5Client/ReqeustType/SummaryEnquiryRequest.dart';
import 'package:n5client/N5Client/ReqeustType/VoidRequest.dart';
import 'package:n5client/N5Client/ResponseType/AbortResponse.dart';
import 'package:n5client/N5Client/ResponseType/BatchEnquiryResponse.dart';
import 'package:n5client/N5Client/ResponseType/ParamsResponse.dart';
import 'package:n5client/N5Client/ResponseType/PrintResponse.dart';
import 'package:n5client/N5Client/ResponseType/SaleResponse.dart';
import 'package:n5client/N5Client/ResponseType/ScanResponse.dart';
import 'package:n5client/N5Client/ResponseType/SettleEnquiryResponse.dart';
import 'package:n5client/N5Client/ResponseType/SettlementResponse.dart';
import 'package:n5client/N5Client/ResponseType/SummaryEnquiryResponse.dart';
import 'package:n5client/N5Client/ResponseType/VoidResponse.dart';
import 'package:n5client/N5Client/interface/IRequestBody.dart';
import 'Constant/PaymentApplication.dart';
import 'Constant/ResponseStatusType.dart';
import 'N5ClientResponse/ClientVoidResponse.dart';
import 'ReqeustType/LastTransactionRetrievalRequest.dart';
import 'ReqeustType/SaleRequest.dart';
import 'RequestMsg.dart';
import 'ResponseMsg.dart';
import 'ResponseType/LastTransactionRetrievalResponse.dart';
import 'ResponseType/LinkTestResponse.dart';

class N5Client {
  Socket _socket;
  dynamic _ipAddress;
  int _port;
  int _timeoutDuration;
  static bool _processingRequest;
  String debugMsg = "";
  static const int _maxRetrievalRetryCount = 2;

  N5Client(dynamic ipAddress, int port, {int timeoutDuration = 120}) {
    _ipAddress = ipAddress;
    _port = port;
    _timeoutDuration = timeoutDuration;
    _processingRequest = false;
  }

  Future<bool> _linkTest() async {
    try {
      LinkTestRequest linkTestRequest = new LinkTestRequest();
      ResponseMsg response = await _request(linkTestRequest)
          .timeout(Duration(seconds: _timeoutDuration));
      LinkTestResponse linkTestResponse =
          new LinkTestResponse(response.msgBody);
      return linkTestResponse.getResponseStatusType() ==
          ResponseStatusType.Success;
    } catch (e) {
      if (e is TimeoutException) {
        _onRequestTimeout();
      }
      rethrow;
    }
  }

  Future<ParamsResponse> params(ParamsRequest paramsRequest) async {
    try {
      ResponseMsg response = await _request(paramsRequest)
          .timeout(Duration(seconds: _timeoutDuration));
      ParamsResponse paramsResponse = new ParamsResponse(response.msgBody);
      return paramsResponse;
    } on TimeoutException catch (e) {
      _onRequestTimeout();
      throw N5Exception(
        //request: paramsRequest,
        error:
            'Does not receive any response from N5 terminal in ${_timeoutDuration}s',
        type: N5ExceptionType.TIMEOUT,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<AbortResponse> abort() async {
    AbortRequest abortRequest = new AbortRequest();
    try {
      ResponseMsg response = await _request(abortRequest, true)
          .timeout(Duration(seconds: _timeoutDuration));
      AbortResponse abortResponse = new AbortResponse(response.msgBody);
      return abortResponse;
    } on TimeoutException catch (e) {
      _onRequestTimeout();
      throw N5Exception(
        //request: abortRequest,
        error:
            'Does not receive any response from N5 terminal in ${_timeoutDuration}s',
        type: N5ExceptionType.TIMEOUT,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<ScanResponse> scan() async {
    ScanRequest scanRequest = new ScanRequest();
    try {
      ResponseMsg response = await _request(scanRequest)
          .timeout(Duration(seconds: _timeoutDuration));
      ScanResponse scanResponse = new ScanResponse(response.msgBody);
      return scanResponse;
    } on TimeoutException catch (e) {
      _onRequestTimeout();
      throw N5Exception(
        //request: scanRequest,
        error:
            'Does not receive any response from N5 terminal in ${_timeoutDuration}s',
        type: N5ExceptionType.TIMEOUT,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Send sale request to the N5 terminal with [txn_id], [txn_amt] and [paymentApp] parameters.
  /// Max. waiting time: _timeoutDuration (default: 35s) x 3 = 105s
  Future<ClientSaleResponse> sendSaleRequest(
      String txn_id, double txn_amt, PaymentApplication paymentApp) async {
    try {
      SaleRequest saleRequest = new SaleRequest(txn_id, txn_amt, paymentApp);
      SaleResponse response = await _sale(saleRequest);

      ClientSaleResponse clientSaleResponse = new ClientSaleResponse(response);
      if (clientSaleResponse.getResponseStatusType() ==
          ResponseStatusType.TransactionProcessing) {
        await Future.delayed(Duration(seconds: _timeoutDuration));
        throw TimeoutException(
            'Return transaction processing, trigger sale retrival.');
      }
      return clientSaleResponse;
    } catch (ex) {
      if (ex is SocketException || ex is TimeoutException) {
        try {
          if (ex is SocketException) {
            bool linkTestResult = await _linkTest();
          }

          int maxRetryCount = _maxRetrievalRetryCount;
          while (maxRetryCount >= 0) {
            maxRetryCount--;
            try {
              LastTransactionRetrievalResponse retrievalResponse =
                  await _lastSaleRetrival(txn_id);

              if ([
                ResponseStatus.ApprovedOrAcceptedByHost,
                ResponseStatus.TransactionNotFind,
                ResponseStatus.FunctionOrPaymentTypeNotSupport
              ].contains(retrievalResponse.STATUS)) {
                ClientSaleResponse clientSaleResponse =
                    new ClientSaleResponse(retrievalResponse);
                return clientSaleResponse;
              }

              if (maxRetryCount == 0) {
                throw Exception(
                    'Transaction still confirming / processing after retry ${_maxRetrievalRetryCount} times.');
              }
            } catch (e) {
              if (maxRetryCount == 0) {
                rethrow;
              }
            }
          }
        } catch (e) {
          if (ex is N5Exception) {
            rethrow;
          }

          throw N5Exception(
            error: e.toString(),
            type: N5ExceptionType.REQUEST_FAILED,
          );
        }
      } else {
        if (ex is N5Exception) {
          rethrow;
        }

        throw N5Exception(
          error: ex.toString(),
          type: N5ExceptionType.REQUEST_FAILED,
        );
      }
    }
  }

  /// Send void request to the N5 terminal with [txn_id] parameter.
  /// Max. waiting time: _timeoutDuration (default: 35s) x 3 = 105s
  Future<ClientVoidResponse> sendVoidRequest(String txn_id) async {
    try {
      VoidRequest voidRequest = new VoidRequest(txn_id: txn_id);
      VoidResponse response = await _void(voidRequest);

      ClientVoidResponse clientVoidResponse = new ClientVoidResponse(response);
      if (clientVoidResponse.getResponseStatusType() ==
          ResponseStatusType.TransactionProcessing) {
        await Future.delayed(Duration(seconds: _timeoutDuration));
        throw TimeoutException(
            'Return transaction processing, trigger sale retrival.');
      }
      return clientVoidResponse;
    } catch (ex) {
      if (ex is SocketException || ex is TimeoutException) {
        try {
          if (ex is SocketException) {
            bool linkTestResult = await _linkTest();
          }

          int maxRetryCount = _maxRetrievalRetryCount;
          while (maxRetryCount >= 0) {
            try {
              LastTransactionRetrievalResponse retrievalResponse =
                  await _lastSaleRetrival(txn_id);

              if (retrievalResponse.getResponseStatusType() ==
                      ResponseStatusType.Success &&
                  retrievalResponse.TXN_STATUS == TransactionStatus.Voided) {
                ClientVoidResponse clientVoidResponse =
                    new ClientVoidResponse(retrievalResponse);
                return clientVoidResponse;
              }
              if (maxRetryCount == 0) {
                throw Exception(
                    'Transaction still confirming / processing after retry ${_maxRetrievalRetryCount} times.');
              }
            } catch (e) {
              if (maxRetryCount == 0) {
                rethrow;
              }
            }
          }
        } catch (e) {
          if (ex is N5Exception) {
            rethrow;
          }

          throw N5Exception(
            error: e.toString(),
            type: N5ExceptionType.REQUEST_FAILED,
          );
        }
      } else {
        if (ex is N5Exception) {
          rethrow;
        }

        throw N5Exception(
          error: ex.toString(),
          type: N5ExceptionType.REQUEST_FAILED,
        );
      }
    }
  }

  Future<SaleResponse> _sale(SaleRequest saleRequest) async {
    try {
      ResponseMsg response = await _request(saleRequest)
          .timeout(Duration(seconds: _timeoutDuration));
      SaleResponse saleResponse = new SaleResponse(response.msgBody);
      return saleResponse;
    } catch (e) {
      if (e is TimeoutException) {
        _onRequestTimeout();
      }
      rethrow;
    }
  }

  Future<LastTransactionRetrievalResponse> _lastSaleRetrival(
      String txn_id) async {
    try {
      LastTransactionRetrievalRequest retrievalRequest =
          new LastTransactionRetrievalRequest(txn_id);
      ResponseMsg response = await _request(retrievalRequest)
          .timeout(Duration(seconds: _timeoutDuration));

      LastTransactionRetrievalResponse lastSaleResponse =
          new LastTransactionRetrievalResponse(response.msgBody);
      return lastSaleResponse;
    } catch (e) {
      if (e is TimeoutException) {
        _onRequestTimeout();
      }
      rethrow;
    }
  }

  Future<VoidResponse> _void(VoidRequest voidRequest) async {
    try {
      ResponseMsg response = await _request(voidRequest)
          .timeout(Duration(seconds: _timeoutDuration));
      VoidResponse voidResponse = new VoidResponse(response.msgBody);
      return voidResponse;
    } catch (e) {
      if (e is TimeoutException) {
        _onRequestTimeout();
      }
      rethrow;
    }
  }

  Future<PrintResponse> printReceipt(PrintRequest printRequest) async {
    try {
      ResponseMsg response = await _request(printRequest)
          .timeout(Duration(seconds: _timeoutDuration));
      PrintResponse printResponse = new PrintResponse(response.msgBody);
      return printResponse;
    } on TimeoutException catch (e) {
      _onRequestTimeout();
      throw N5Exception(
        //request: printRequest,
        error:
            'Does not receive any response from N5 terminal in ${_timeoutDuration}s',
        type: N5ExceptionType.TIMEOUT,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<BatchEnquiryResponse> sendBatchEnquiry(DateTime settleDate) async {
    try {
      BatchEnquiryRequest batchEnquiryRequest =
          new BatchEnquiryRequest(settleDate);
      ResponseMsg response = await _request(batchEnquiryRequest)
          .timeout(Duration(seconds: _timeoutDuration));
      BatchEnquiryResponse batchEnquiryResponse =
          new BatchEnquiryResponse(response.msgBody);
      return batchEnquiryResponse;
    } catch (e) {
      if (e is TimeoutException) {
        _onRequestTimeout();
      }

      if (e is N5Exception) {
        rethrow;
      }

      throw N5Exception(
        error: e.toString(),
        type: N5ExceptionType.REQUEST_FAILED,
      );
    }
  }

  Future<SummaryEnquiryResponse> sendSummaryEnquiry() async {
    try {
      SummaryEnquiryRequest summaryEnquiryRequest = new SummaryEnquiryRequest();
      ResponseMsg response = await _request(summaryEnquiryRequest)
          .timeout(Duration(seconds: _timeoutDuration));
      SummaryEnquiryResponse summaryEnquiryResponse =
          new SummaryEnquiryResponse(response.msgBody);
      return summaryEnquiryResponse;
    } catch (e) {
      if (e is TimeoutException) {
        _onRequestTimeout();
      }

      if (e is N5Exception) {
        rethrow;
      }

      throw N5Exception(
        error: e.toString(),
        type: N5ExceptionType.REQUEST_FAILED,
      );
    }
  }

  Future<SettleEnquiryResponse> sendSettleEnquiry(String batch_id) async {
    try {
      SettleEnquiryRequest settleEnquiryRequest =
          new SettleEnquiryRequest(batch_id);
      ResponseMsg response = await _request(settleEnquiryRequest)
          .timeout(Duration(seconds: _timeoutDuration));
      SettleEnquiryResponse settleEnquiryResponse =
          new SettleEnquiryResponse(response.msgBody);
      return settleEnquiryResponse;
    } catch (e) {
      if (e is TimeoutException) {
        _onRequestTimeout();
      }

      if (e is N5Exception) {
        rethrow;
      }

      throw N5Exception(
        error: e.toString(),
        type: N5ExceptionType.REQUEST_FAILED,
      );
    }
  }

  Future<SettlementResponse> sendSettleRequest() async {
    try {
      SettlementRequest settlementRequest = new SettlementRequest();
      ResponseMsg response = await _request(settlementRequest)
          .timeout(Duration(seconds: _timeoutDuration));
      SettlementResponse settlementResponse =
          new SettlementResponse(response.responseBodyInJson);
      return settlementResponse;
    } catch (e) {
      if (e is TimeoutException) {
        _onRequestTimeout();
      }

      if (e is N5Exception) {
        rethrow;
      }

      throw N5Exception(
        error: e.toString(),
        type: N5ExceptionType.REQUEST_FAILED,
      );
    }
  }

  void _onRequestTimeout() {
    if (_socket != null) {
      _socket.destroy();
    }
    _processingRequest = false;
  }

  Future<ResponseMsg> _request(IRequestBody request,
      [bool ignoreProcessingRequest = false]) async {
    debugMsg = '';
    if (_processingRequest && !ignoreProcessingRequest) {
      throw N5Exception(
        error: 'N5 client is in use by another request.',
        type: N5ExceptionType.CLIENT_IN_USE,
      );
    }

    if (ignoreProcessingRequest && _socket != null) {
      _socket.close();
    }

    Completer<ResponseMsg> _completer = new Completer<ResponseMsg>();

/*
    if (_socket != null) {
      _socket.destroy();
    }
*/

    try {
      _socket = await Socket.connect(_ipAddress, _port,
          timeout: Duration(seconds: 5));
      _processingRequest = true;

      RequestMsg reqMsg = new RequestMsg(request);

      /*
    Future.delayed(const Duration(seconds: 3), () async {
      var socketB = await Socket.connect(_ipAddress, _port,
          timeout: Duration(seconds: _timeoutDuration));
      if (request is SaleRequest) {
        DateFormat dateFormat = DateFormat("yyyyMMddkkmmss");
        String strTimeStamp = dateFormat.format(DateTime.now());
        request.TXN_ID = strTimeStamp;
        request.TXN_AMT = 0.2;
      }
      RequestMsg reqMsg = new RequestMsg(request);
      socketB.add(reqMsg.getComposedMsg());
      print(
          "Time: ${DateTime.now().toString()} reqMsg.reqMsgBody:${reqMsg.requestBodyInJson}");
    });
    */

/*
    _socket.timeout(Duration(seconds: 60), onTimeout: (EventSink sink) {
      sink.addError('timeout error');
      print("Time: ${DateTime.now().toString()} Socket timeout");
    });
    */

      _socket.listen((onData) {
        var respMsg = new ResponseMsg(onData);
        debugMsg +=
            "(${DateTime.now().toString()}): Response JSON: ${respMsg.msgBody}\r\n";

        RequestEvent re = reqMsg.requestBody.EVENT_NAME;

        if (!_completer.isCompleted &&
            respMsg.responseBodyInJson["EVENT_NAME"] ==
                (re.toShortString() + "_RESP")) {
          _processingRequest = false;
          _completer.complete(respMsg);
        }
      }, onError: ((error, StackTrace trace) {
        _socket.close();
        if (!_completer.isCompleted) {
          _processingRequest = false;
          _completer.completeError(error);
        }
      }), onDone: () {
        _socket.close();
      });

      debugMsg +=
          "(${DateTime.now().toString()}): Request JSON: ${reqMsg.requestBodyInJson}\r\n";
      _socket.add(reqMsg.getComposedMsg());
    } on SocketException catch (ex) {
      _completer.completeError(ex);
    }

    return _completer.future;
  }

/*
  Future<RespMsg> request(IRequestBody request) async {
    Completer<RespMsg> _completer = new Completer<RespMsg>();

    if (_socket != null) {
      return _completer.future;
    }

    RequestMsg reqMsg = new RequestMsg(request);
    Socket.connect(_ipAddress, _port,
            timeout: Duration(seconds: _timeoutDuration))
        .then((Socket socket) {
      _socket = socket;
      print("reqMsg.allMsg:${reqMsg.getComposedMsg()}");
      print("reqMsg.reqMsgBody:${reqMsg.requestBodyInJson}");
      _socket.add(reqMsg.getComposedMsg());
      _socket.listen((onData) {
        RespMsg respMsg = new RespMsg(onData);
        print(
            "Time: ${DateTime.now().toString()} (onData) respmsg.msgBody: ${respMsg.msgBody}");
        _completer.complete(respMsg);
      }, onError: ((error, StackTrace trace) {
        print(
            "Time: ${DateTime.now().toString()} (onError) ${error.toString()}");
        _completer.completeError(error);
      }), onDone: () {
        _socket.destroy();
        _socket = null;
        print("Time: ${DateTime.now().toString()} (onDone) Socket destroy");
      }, cancelOnError: false);
    });
  }
  */

  //Future get initializationDone => _doneFuture
}

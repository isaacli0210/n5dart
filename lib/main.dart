import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:crypto/crypto.dart';
import 'package:n5client/N5Client/Common/N5SocketException.dart';
import 'dart:convert';
import 'package:n5client/N5Client/N5Client.dart';
import 'package:n5client/N5Client/ReqeustType/AbortRequest.dart';
import 'package:n5client/N5Client/ReqeustType/BatchEnquiryRequest.dart';
import 'package:n5client/N5Client/ReqeustType/ParamsRequest.dart';
import 'package:n5client/N5Client/ReqeustType/PrintRequest.dart';
import 'package:n5client/N5Client/ReqeustType/ScanRequest.dart';
import 'package:n5client/N5Client/ReqeustType/SettleEnquiryRequest.dart';
import 'package:n5client/N5Client/ReqeustType/SettlementRequest.dart';
import 'package:n5client/N5Client/ReqeustType/SummaryEnquiryRequest.dart';
import 'package:n5client/N5Client/ReqeustType/VoidRequest.dart';
import 'package:n5client/N5Client/ResponseType/AbortResponse.dart';
import 'package:n5client/N5Client/ResponseType/BatchEnquiryResponse.dart';
import 'package:n5client/N5Client/ResponseType/LinkTestResponse.dart';
import 'package:n5client/N5Client/ResponseType/ParamsResponse.dart';
import 'package:n5client/N5Client/ResponseType/PrintResponse.dart';
import 'package:n5client/N5Client/ResponseType/ScanResponse.dart';
import 'package:n5client/N5Client/ResponseType/SettleEnquiryResponse.dart';
import 'package:n5client/N5Client/ResponseType/SettlementResponse.dart';
import 'package:n5client/N5Client/ResponseType/SummaryEnquiryResponse.dart';
import 'package:n5client/N5Client/ResponseType/VoidResponse.dart';
import 'N5Client/Constant/PaymentApplication.dart';
import 'N5Client/Constant/RequestEvent.dart';
import 'N5Client/Constant/ResponseStatus.dart';
import 'N5Client/Constant/ResponseStatusType.dart';
import 'N5Client/Constant/TransactionStatus.dart';
import 'N5Client/Helper/PaymentHelper.dart';
import 'N5Client/N5ClientResponse/ClientSaleResponse.dart';
import 'N5Client/N5ClientResponse/ClientVoidResponse.dart';
import 'N5Client/ReqeustType/LinkTestRequest.dart';
import 'N5Client/ReqeustType/LastTransactionRetrievalRequest.dart';
import 'N5Client/ReqeustType/SaleRequest.dart';
import 'N5Client/ResponseType/LastTransactionRetrievalResponse.dart';
import 'N5Client/ResponseType/SaleResponse.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _debugMsg = '';
  String _lastSuccessSaleTxnID = '';
  N5Client client = new N5Client("10.0.135.240", 9001, timeoutDuration: 35);
  //N5Client client = new N5Client("192.168.1.23", 9001, timeoutDuration: 35);

  void _appendDebugMsg(String text) {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _debugMsg += text + '\r\n';
    });
  }

  void _resetDebugMsg() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _debugMsg = '';
    });
  }

  void _demoSaleRequest() async {
    _resetDebugMsg();
    setState(() {});

    String txn_id = _getTxnID();
    double amount = 0.1;
    PaymentApplication paymentApplication = PaymentApplication.CC;

    try {
      ClientSaleResponse sr =
          await client.sendSaleRequest(txn_id, amount, paymentApplication);

      switch (sr.getResponseStatusType()) {
        case ResponseStatusType.Success:
          print('Success');
          print('TRACE_NO: ' + sr.TRACE_NO);
          _lastSuccessSaleTxnID = txn_id;
          break;
        case ResponseStatusType.Failed:
        case ResponseStatusType.ProcessingAnotherRequest:
          print('Transaction failed, ask customer to retry or cancel.');
          break;
        case ResponseStatusType.Error:
          print('Contact MIS (Status: ' + sr.STATUS + ')');
          break;
        default:
      }
    } catch (error) {
      print(error.toString());
      print('Ask customer to retry or cancel');
    }
  }

  void _demoVoidRequest() async {
    _resetDebugMsg();
    setState(() {});

    String txn_id = _lastSuccessSaleTxnID;
    try {
      ClientVoidResponse vr = await client.sendVoidRequest(txn_id);

      switch (vr.getResponseStatusType()) {
        case ResponseStatusType.Success:
          print('Success');
          print('TRACE_NO: ' + vr.TRACE_NO);
          _lastSuccessSaleTxnID = txn_id;
          break;
        case ResponseStatusType.Failed:
        case ResponseStatusType.ProcessingAnotherRequest:
          print('Transaction failed, ask customer to retry or cancel.');
          break;
        default:
          print('Contact MIS (Status: ' + vr.STATUS + ')');
          break;
      }
    } catch (error) {
      print(error.toString());
      print('Ask customer to retry or cancel');
    }
  }

  Future<SummaryEnquiryResponse> _demoSummaryEnquiryRequest() async {
    _resetDebugMsg();
    setState(() {});

    try {
      SummaryEnquiryResponse ser = await client.sendSummaryEnquiry();
      _appendDebugMsg(client.debugMsg);

      switch (ser.getResponseStatusType()) {
        case ResponseStatusType.Success:
          print("(${DateTime.now().toString()}): Summary Enquiry Successful");
          break;
        case ResponseStatusType.ProcessingAnotherRequest:
          print(
              "(${DateTime.now().toString()}): N5 terminal is now processing another request, please complete current transaction before send another request.");
          break;
        default:
          print(
              "Contact MIS (${PaymentHelper.getResponseStatusDescription(ser.STATUS)})");
      }

      return ser;
    } catch (error) {
      _appendDebugMsg(client.debugMsg);
      print("(${DateTime.now().toString()}): Exception:${error.toString()}");
    }
  }

  Future<BatchEnquiryResponse> _demoBatchEnquiryRequest() async {
    _resetDebugMsg();
    setState(() {});
    try {
      BatchEnquiryResponse ber = await client.sendBatchEnquiry(DateTime.now());
      _appendDebugMsg(client.debugMsg);

      switch (ber.getResponseStatusType()) {
        case ResponseStatusType.Success:
          print("(${DateTime.now().toString()}): Batch Enquiry Successful");
          break;
        case ResponseStatusType.ProcessingAnotherRequest:
          print(
              "(${DateTime.now().toString()}): N5 terminal is now processing another request, please complete current transaction before send another request.");
          break;
        default:
          print(
              "Contact MIS (${PaymentHelper.getResponseStatusDescription(ber.STATUS)})");
      }
      return ber;
    } catch (error) {
      _appendDebugMsg(client.debugMsg);
      print("(${DateTime.now().toString()}): Exception:${error.toString()}");
    }
  }

  void _demoSettleEnquiryRequest() async {
    _resetDebugMsg();
    setState(() {});

    BatchEnquiryResponse ber = await _demoBatchEnquiryRequest();
    if (ber.getResponseStatusType() != ResponseStatusType.Success) {
      print("(${DateTime.now().toString()}): Failed to get Batch Enquiry data");
      return;
    }
    print(
        "(${DateTime.now().toString()}): Latest Batch ID: ${ber.RESULT.last}");

    try {
      SettleEnquiryResponse ser =
          await client.sendSettleEnquiry(ber.RESULT.last);
      _appendDebugMsg(client.debugMsg);

      switch (ser.getResponseStatusType()) {
        case ResponseStatusType.Success:
          return print(
              "(${DateTime.now().toString()}): Settle Enquiry Successful");
        case ResponseStatusType.ProcessingAnotherRequest:
          return print(
              "(${DateTime.now().toString()}): N5 terminal is now processing another request, please complete current transaction before send another request.");
        default:
          print(
              "Contact MIS (${PaymentHelper.getResponseStatusDescription(ser.STATUS)})");
      }
    } catch (error) {
      _appendDebugMsg(client.debugMsg);
      print("(${DateTime.now().toString()}): Exception:${error.toString()}");
    }
  }

  void _demoSettleRequest() async {
    _resetDebugMsg();
    setState(() {});

    SettlementRequest settlementRequest = new SettlementRequest();
    try {
      SettlementResponse sr = await client.sendSettleRequest();
      _appendDebugMsg(client.debugMsg);

      switch (sr.getResponseStatusType()) {
        case ResponseStatusType.Success:
          print("(${DateTime.now().toString()}): Settlement Successful");
          break;
        case ResponseStatusType.Failed:
          print(
              "(${DateTime.now().toString()}): Partial Settlement, rerun settlement again.");
          break;
        case ResponseStatusType.ProcessingAnotherRequest:
          print(
              "(${DateTime.now().toString()}): N5 terminal is now processing another request, please complete current transaction before send another request.");
          break;
        default:
          print(
              "Contact MIS (${PaymentHelper.getResponseStatusDescription(sr.STATUS)})");
      }
    } catch (error) {
      _appendDebugMsg(client.debugMsg);
      print("(${DateTime.now().toString()}): Exception:${error.toString()}");
    }
  }

  String _getTxnID() {
    DateFormat dateFormat = DateFormat("yyyyMMddkkmmss");
    String strTimeStamp = dateFormat.format(DateTime.now());
    return strTimeStamp;
  }
/*
  Future<LastTransactionRetrievalResponse> onTransactionProcessing(
      String txn_id) async {
    try {
      LastTransactionRetrievalRequest retrievalRequest =
          new LastTransactionRetrievalRequest(txn_id);
      LastTransactionRetrievalResponse rr =
          await client.lastSaleRetrival(retrievalRequest);
      _appendDebugMsg(client.debugMsg);
      return rr;
    } catch (e) {
      rethrow;
    }
  }
  */

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _debugMsg = '';
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('$_debugMsg'),
          ],
        ),
      ),
      floatingActionButton: Container(child: _offsetPopup()
          /*
        onPressed: _n5clienttestjt,
        tooltip: 'Increment',
        child: Icon(Icons.add),
        */
          ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _offsetPopup() => PopupMenuButton<int>(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: RequestEvent.SALE.index,
            child: Text(
              RequestEvent.SALE.toShortString(),
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            ),
          ),
          PopupMenuItem(
            value: RequestEvent.VOID.index,
            child: Text(
              RequestEvent.VOID.toShortString(),
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            ),
          ),
          PopupMenuItem(
            value: RequestEvent.SUMMARY_ENQUIRY.index,
            child: Text(
              RequestEvent.SUMMARY_ENQUIRY.toShortString(),
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            ),
          ),
          PopupMenuItem(
            value: RequestEvent.BATCH_ENQUIRY.index,
            child: Text(
              RequestEvent.BATCH_ENQUIRY.toShortString(),
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            ),
          ),
          PopupMenuItem(
            value: RequestEvent.SETTLE.index,
            child: Text(
              RequestEvent.SETTLE.toShortString(),
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            ),
          ),
          PopupMenuItem(
            value: RequestEvent.SETTLE_ENQUIRY.index,
            child: Text(
              RequestEvent.SETTLE_ENQUIRY.toShortString(),
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            ),
          ),
        ],
        icon: Icon(Icons.add, color: Colors.blue),
        onSelected: (newValue) {
          if (newValue == RequestEvent.SALE.index) {
            _demoSaleRequest();
          } else if (newValue == RequestEvent.VOID.index) {
            if (_lastSuccessSaleTxnID == '') {
              return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('No pervious transaction found'),
                    content: const Text('Please try SALE before VOID'),
                    actions: [
                      FlatButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            } else {
              _demoVoidRequest();
            }
          } else if (newValue == RequestEvent.SUMMARY_ENQUIRY.index) {
            _demoSummaryEnquiryRequest();
          } else if (newValue == RequestEvent.BATCH_ENQUIRY.index) {
            _demoBatchEnquiryRequest();
          } else if (newValue == RequestEvent.SETTLE.index) {
            _demoSettleRequest();
          } else if (newValue == RequestEvent.SETTLE_ENQUIRY.index) {
            _demoSettleEnquiryRequest();
          }
        },
      );
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'dart:io';

import 'package:http/http.dart' as http;

class PaymentDemo extends StatefulWidget {
  @override
  _PaymentDemoState createState() => _PaymentDemoState();
}

class _PaymentDemoState extends State<PaymentDemo> {

  Token _paymentToken;
  PaymentMethod _paymentMethod;
  String _error;

  //this client secret is typically created by a backend system
  //check https://stripe.com/docs/payments/payment-intents#passing-to-client
  final String _paymentIntentClientSecret = null;

  PaymentIntentResult _paymentIntent;
  Source _source;

  ScrollController _controller = ScrollController();

  final CreditCard testCard = CreditCard(
    number: '4000002760003184',
    expMonth: 12,
    expYear: 21,
  );

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  initState() {
    super.initState();

    StripePayment.setOptions(StripeOptions(
        publishableKey: "pk_test_aSaULNS8cJU6Tvo20VAXy6rp",
        merchantId: "Test",
        androidPayMode: 'test'));
  }

  void setError(dynamic error) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(error.toString())));
    setState(() {
      _error = error.toString();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text('Plugin example app'),
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.clear),
          //   onPressed: () {
          //     setState(() {
          //       _source = null;
          //       _paymentIntent = null;
          //       _paymentMethod = null;
          //       _paymentToken = null;
          //     });
          //   },
          // )
        ],
      ),
      body: ListView(
        controller: _controller,
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          // RaisedButton(
          //   child: Text("Create Source"),
          //   onPressed: () {
          //     StripePayment.createSourceWithParams(SourceParams(
          //       type: 'ideal',
          //       amount: 1099,
          //       currency: 'eur',
          //       returnURL: 'example://stripe-redirect',
          //     )).then((source) {
          //       _scaffoldKey.currentState.showSnackBar(
          //           SnackBar(content: Text('Received ${source.sourceId}')));
          //       setState(() {
          //         _source = source;
          //       });
          //     }).catchError(setError);
          //   },
          // ),
          // Divider(),
          // RaisedButton(
          //   child: Text("Create Token with Card Form"),
          //   onPressed: () {
          //     StripePayment.paymentRequestWithCardForm(
          //         CardFormPaymentRequest())
          //         .then((paymentMethod) {
          //           print(paymentMethod.customerId);
          //           print(paymentMethod.id);
          //           print(paymentMethod.type);
          //           print(paymentMethod.billingDetails.name);
          //           print(paymentMethod.billingDetails.email);
          //           print(paymentMethod.billingDetails.phone);
          //           print(paymentMethod.billingDetails.address.state);
          //           print(paymentMethod.card.name);
          //           print(paymentMethod.card.token);
          //           print(paymentMethod.card.number);
          //           print(paymentMethod.card.addressCity);
          //           print(paymentMethod.card.expMonth);
          //           print(paymentMethod.card.expYear);
          //           print(paymentMethod.card.funding);
          //           print(paymentMethod.livemode);
          //           print(paymentMethod.created);
          //       _scaffoldKey.currentState.showSnackBar(
          //           SnackBar(content: Text('Received ${paymentMethod.id}')));
          //       setState(() {
          //         _paymentMethod = paymentMethod;
          //       });
          //     }).catchError(setError);
          //   },
          // ),
          // RaisedButton(
          //   child: Text("Create Token with Card"),
          //   onPressed: () {
          //     StripePayment.createTokenWithCard(
          //       testCard
          //     ).then((token) {
          //       _scaffoldKey.currentState.showSnackBar(
          //           SnackBar(content: Text('Received ${token.tokenId}')));
          //       setState(() {
          //         _paymentToken = token;
          //       });
          //     }).catchError(setError);
          //   },
          // ),
          // Divider(),
          // RaisedButton(
          //   child: Text("Create Payment Method with Card"),
          //   onPressed: () {
          //     StripePayment.createPaymentMethod(
          //       PaymentMethodRequest(
          //         card: testCard,
          //       ),
          //     ).then((paymentMethod) {
          //       _scaffoldKey.currentState.showSnackBar(
          //           SnackBar(content: Text('Received ${paymentMethod.id}')));
          //       setState(() {
          //         _paymentMethod = paymentMethod;
          //       });
          //     }).catchError(setError);
          //   },
          // ),
          // RaisedButton(
          //   child: Text("Create Payment Method with existing token"),
          //   onPressed: _paymentToken == null
          //       ? null
          //       : () {
          //     StripePayment.createPaymentMethod(
          //       PaymentMethodRequest(
          //         card: CreditCard(
          //           token: _paymentToken.tokenId,
          //         ),
          //       ),
          //     ).then((paymentMethod) {
          //       _scaffoldKey.currentState.showSnackBar(SnackBar(
          //           content: Text('Received ${paymentMethod.id}')));
          //       setState(() {
          //         _paymentMethod = paymentMethod;
          //       });
          //     }).catchError(setError);
          //   },
          // ),
          //
          // Divider(),
          RaisedButton(
            child: Text("Native payment"),
            onPressed: () {
              if (Platform.isIOS) {
                _controller.jumpTo(450);
              }
              StripePayment.paymentRequestWithNativePay(
                androidPayOptions: AndroidPayPaymentRequest(
                  totalPrice: "1.20",
                  currencyCode: "EUR",
                ),
                applePayOptions: ApplePayPaymentOptions(
                  countryCode: 'DE',
                  currencyCode: 'EUR',
                  items: [
                    ApplePayItem(
                      label: 'Test',
                      amount: '13',
                    )
                  ],
                ),
              ).then((token) {
                setState(() {
                  _scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text('Received ${token.tokenId}')));
                  _paymentToken = token;
                });
              }).catchError(setError);
            },
          ),
          // RaisedButton(
          //   child: Text("Complete Native Payment"),
          //   onPressed: () {
          //     StripePayment.completeNativePayRequest().then((_) {
          //       _scaffoldKey.currentState.showSnackBar(
          //           SnackBar(content: Text('Completed successfully')));
          //     }).catchError(setError);
          //   },
          // ),
          // Divider(),
          // Text('Current source:'),
          // Text(
          //   JsonEncoder.withIndent('  ').convert(_source?.toJson() ?? {}),
          //   style: TextStyle(fontFamily: "Monospace"),
          // ),
          // Divider(),
          // Text('Current token:'),
          // Text(
          //   JsonEncoder.withIndent('  ')
          //       .convert(_paymentToken?.toJson() ?? {}),
          //   style: TextStyle(fontFamily: "Monospace"),
          // ),
          // Divider(),
          // Text('Current payment method:'),
          // Text(
          //   JsonEncoder.withIndent('  ')
          //       .convert(_paymentMethod?.toJson() ?? {}),
          //   style: TextStyle(fontFamily: "Monospace"),
          // ),
          // Divider(),
          // Text('Current payment intent:'),
          // Text(
          //   JsonEncoder.withIndent('  ')
          //       .convert(_paymentIntent?.toJson() ?? {}),
          //   style: TextStyle(fontFamily: "Monospace"),
          // ),
          // Divider(),
          // Text('Current error: $_error'),
        ],
      ),
    );
  }
}


// class StripeDemoUSD extends StatefulWidget {
//   StripeDemoUSD({Key key}) : super(key: key);
//   @override
//   _StripeDemoUSDState createState() => _StripeDemoUSDState();
// }
//
// class _StripeDemoUSDState extends State<StripeDemoUSD> {
//   onItemPress(BuildContext context, int index) async {
//     switch (index) {
//       case 0:
//         payViaNewCard(context);
//         break;
//       case 1:
//         Navigator.push(context, MaterialPageRoute(builder: (context) => ExistingCardsPage(),));
//         break;
//     }
//   }
//   payViaNewCard(BuildContext context) async {
//     ProgressDialog dialog = new ProgressDialog(context);
//     dialog.style(message: 'Please wait...');
//     await dialog.show();
//     var response =
//     await StripeService.payWithNewCard(amount: '15000', currency: 'USD');
//     await dialog.hide();
//     Scaffold.of(context).showSnackBar(SnackBar(
//         content: Text(response.message),
//         duration: new Duration(
//             milliseconds: response.success == true ? 1200 : 3000)));
//   }
//   @override
//   void initState() {
//     super.initState();
//     StripeService.init();
//   }
//   @override
//   Widget build(BuildContext context) {
//     ThemeData theme = Theme.of(context);
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Home'),
//         ),
//         body: Container(
//             padding: EdgeInsets.all(20),
//             child: ListView.separated(
//                 itemBuilder: (context, index) {
//                   Icon icon;
//                   Text text;
//                   switch (index) {
//                     case 0:
//                       icon = Icon(Icons.add_circle, color: theme.primaryColor);
//                       text = Text('Pay via new card');
//                       break;
//                     case 1:
//                       icon = Icon(Icons.credit_card, color: theme.primaryColor);
//                       text = Text('Pay via existing card');
//                       break;
//                   }
//                   return InkWell(
//                       onTap: () {
//                         onItemPress(context, index);
//                       },
//                       child: ListTile(title: text, leading: icon));
//                 },
//                 separatorBuilder: (context, index) =>
//                     Divider(color: theme.primaryColor),
//                 itemCount: 2)));
//   }
// }
//
//
// class StripeTransactionResponse {
//   String message;
//   bool success;
//   StripeTransactionResponse({this.message, this.success});
// }
// class StripeService {
//   static String apiBase = 'https://api.stripe.com/v1';
//   static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
//   static String secret = 'sk_test_4eC39HqLyjWDarjtT1zdp7dc';
//   static Map<String, String> headers = {
//     'Authorization': 'Bearer ${StripeService.secret}',
//     'Content-Type': 'application/x-www-form-urlencoded'
//   };
//   static init() {
//     StripePayment.setOptions(StripeOptions(
//         publishableKey: "pk_test_TYooMQauvdEDq54NiTphI7jx",
//         merchantId: "Test",
//         androidPayMode: 'test'));
//   }
//   static Future<StripeTransactionResponse> payViaExistingCard(
//       {String amount, String currency, CreditCard card}) async {
//     try {
//       var paymentMethod = await StripePayment.createPaymentMethod(
//           PaymentMethodRequest(card: card));
//       var paymentIntent =
//       await StripeService.createPaymentIntent(amount, currency);
//       var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
//           clientSecret: paymentIntent['client_secret'],
//           paymentMethodId: paymentMethod.id));
//       if (response.status == 'succeeded') {
//         return new StripeTransactionResponse(
//             message: 'Transaction successful', success: true);
//       } else {
//         return new StripeTransactionResponse(
//             message: 'Transaction failed', success: false);
//       }
//     } on PlatformException catch (err) {
//       return StripeService.getPlatformExceptionErrorResult(err);
//     } catch (err) {
//       return new StripeTransactionResponse(
//           message: 'Transaction failed: ${err.toString()}', success: false);
//     }
//   }
//   static Future<StripeTransactionResponse> payWithNewCard(
//       {String amount, String currency}) async {
//     try {
//       var paymentMethod = await StripePayment.paymentRequestWithCardForm(
//           CardFormPaymentRequest());
//       var paymentIntent =
//       await StripeService.createPaymentIntent(amount, currency);
//       var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
//           clientSecret: paymentIntent['client_secret'],
//           paymentMethodId: paymentMethod.id));
//       if (response.status == 'succeeded') {
//         return new StripeTransactionResponse(
//             message: 'Transaction successful', success: true);
//       } else {
//         return new StripeTransactionResponse(
//             message: 'Transaction failed', success: false);
//       }
//     } on PlatformException catch (err) {
//       return StripeService.getPlatformExceptionErrorResult(err);
//     } catch (err) {
//       return new StripeTransactionResponse(
//           message: 'Transaction failed: ${err.toString()}', success: false);
//     }
//   }
//   static getPlatformExceptionErrorResult(err) {
//     String message = 'Something went wrong';
//     if (err.code == 'cancelled') {
//       message = 'Transaction cancelled';
//     }
//     return new StripeTransactionResponse(message: message, success: false);
//   }
//   static Future<Map<String, dynamic>> createPaymentIntent(
//       String amount, String currency) async {
//     try {
//       Map<String, dynamic> body = {
//         'amount': amount,
//         'currency': currency,
//         'payment_method_types[]': 'card'
//       };
//       var response = await http.post(StripeService.paymentApiUrl,
//           body: body, headers: StripeService.headers);
//       return jsonDecode(response.body);
//     } catch (err) {
//       print('err charging user: ${err.toString()}');
//     }
//     return null;
//   }
// }
//
//
// class ExistingCardsPage extends StatefulWidget {
//   ExistingCardsPage({Key key}) : super(key: key);
//   @override
//   ExistingCardsPageState createState() => ExistingCardsPageState();
// }
// class ExistingCardsPageState extends State<ExistingCardsPage> {
//   List cards = [
//     {
//       'cardNumber': '4242424242424242',
//       'expiryDate': '04/24',
//       'cardHolderName': 'Muhammad Ahsan Ayaz',
//       'cvvCode': '424',
//       'showBackView': false
//     },
//     {
//       'cardNumber': '5555555566554444',
//       'expiryDate': '04/23',
//       'cardHolderName': 'Tracer',
//       'cvvCode': '123',
//       'showBackView': false
//     }
//   ];
//   payViaExistingCard(BuildContext context, card) async {
//     ProgressDialog dialog = new ProgressDialog(context);
//     dialog.style(message: 'Please wait...');
//     await dialog.show();
//     var expiryArr = card['expiryDate'].split('/');
//     CreditCard stripeCard = CreditCard(
//       number: card['cardNumber'],
//       expMonth: int.parse(expiryArr[0]),
//       expYear: int.parse(expiryArr[1]),
//     );
//     var response = await StripeService.payViaExistingCard(
//         amount: '36', currency: 'USD', card: stripeCard);
//     await dialog.hide();
//     Scaffold.of(context)
//         .showSnackBar(SnackBar(
//       content: Text(response.message),
//       duration: new Duration(milliseconds: 1200),
//     ))
//         .closed
//         .then((_) {
//       Navigator.pop(context);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(title: Text('Choose existing card')),
//         body: Container(
//             padding: EdgeInsets.all(20),
//             child: ListView.builder(
//                 itemCount: cards.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   var card = cards[index];
//                   return InkWell(
//                       onTap: () {
//                         payViaExistingCard(context, card);
//                       },
//                       // child: CreditCardWidget(
//                       //     cardNumber: card['cardNumber'],
//                       //     expiryDate: card['expiryDate'],
//                       //     cardHolderName: card['cardHolderName'],
//                       //     cvvCode: card['cvvCode'],
//                       //     showBackView: false)
//                     child:  Card(
//                       child: Container(
//                         child: Column(
//                           children: [
//                             Text(card['cardNumber']),
//                             Text(card['expiryDate']),
//                             Text(card['cardHolderName']),
//                             Text(card['cvvCode']),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 })));
//   }
// }
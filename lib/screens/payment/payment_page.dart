import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentPage extends StatefulWidget {
  final double totalAmount;

  const PaymentPage({super.key, required this.totalAmount});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _startPayment();
  }

  void _startPayment() {
    var options = {
      'key': 'rzp_test_QP4YAHIWFxQErA',
      'amount': (widget.totalAmount * 100).toInt(), // in paise
      'currency': 'INR',
      'name': 'Clot',
      'description': 'Purchase Products',
      'prefill': {
        'contact': '9876543210',
        'email': 'test@example.com',
      },
      'theme': {'color': '#F37254'},
      'external': {'wallets': ['paytm']},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("✅ Payment Successful\nPayment ID: ${response.paymentId}"),
      backgroundColor: Colors.green,
    ));
    Navigator.pop(context);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("❌ Payment Failed\nReason: ${response.message}"),
      backgroundColor: Colors.red,
    ));
    Navigator.pop(context);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("External Wallet: ${response.walletName}"),
      backgroundColor: Colors.blue,
    ));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

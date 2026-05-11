import 'package:flutter/material.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_strings.dart';

enum PaymentMethod { card, mobileMoney }

class PaymentResult {
  final bool success;
  final String? transactionRef;
  final String? errorMessage;

  const PaymentResult({
    required this.success,
    this.transactionRef,
    this.errorMessage,
  });
}

class PaymentService {
  static final PaymentService _instance = PaymentService._internal();
  factory PaymentService() => _instance;
  PaymentService._internal();

  Future<PaymentResult> initiatePayment({
    required BuildContext context,
    required double amount,
    required String email,
    required String phone,
    required String name,
    required PaymentMethod method,
  }) async {
    final txRef = 'FB-${const Uuid().v4().substring(0, 12).toUpperCase()}';

    try {
      final customer = Customer(
        name: name,
        email: email,
        phoneNumber: phone,
      );

      final flutterwave = Flutterwave(
        publicKey: AppStrings.flwPublicKey,
        currency: 'RWF',
        txRef: txRef,
        amount: amount.toStringAsFixed(0),
        customer: customer,
        paymentOptions: method == PaymentMethod.card ? 'card' : 'mobilemoney',
        customization: Customization(
          title: 'FreshBasket',
          description: 'Fresh produce delivery payment',
          logo: 'https://i.imgur.com/freshbasket.png',
        ),
        isTestMode: true,
        redirectUrl: 'https://freshbasket.app/payment/callback',
      );

      final response = await flutterwave.charge(context);

      if (response.status == 'successful') {
        return PaymentResult(
          success: true,
          transactionRef: response.transactionId,
        );
      }
      return PaymentResult(
        success: false,
        errorMessage: response.status ?? 'Payment was not completed.',
      );
    } catch (e) {
      return PaymentResult(success: false, errorMessage: e.toString());
    }
  }
}

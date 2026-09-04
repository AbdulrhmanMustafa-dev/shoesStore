import 'package:dio/dio.dart';

class PaymobManager {
  PaymobManager({Dio? dio})
    : _dio = dio ?? Dio(BaseOptions(baseUrl: 'https://accept.paymob.com/api'));

  static const _apiKey = String.fromEnvironment('PAYMOB_API_KEY');
  static const _cardIntegrationId = String.fromEnvironment(
    'PAYMOB_CARD_INTEGRATION_ID',
  );
  static const _walletIntegrationId = String.fromEnvironment(
    'PAYMOB_WALLET_INTEGRATION_ID',
  );
  static const iframeId = String.fromEnvironment('PAYMOB_IFRAME_ID');

  final Dio _dio;

  bool isConfiguredFor(String paymentMethod) {
    final isWallet =
        paymentMethod == 'Vodafone Cash' || paymentMethod == 'Instapay';
    return _apiKey.isNotEmpty &&
        (isWallet
            ? _walletIntegrationId.isNotEmpty
            : _cardIntegrationId.isNotEmpty && iframeId.isNotEmpty);
  }

  Future<String> getPaymentKey({
    required double amountInEgp,
    required String paymentMethod,
    required String email,
    required String phoneNumber,
  }) async {
    _ensureConfiguredFor(paymentMethod);

    if (amountInEgp <= 0) {
      throw ArgumentError('The payment amount must be positive.');
    }

    try {
      // 1. Authentication
      final authResponse = await _dio.post(
        '/auth/tokens',
        data: {'api_key': _apiKey},
      );
      final authToken = authResponse.data['token'] as String?;
      if (authToken == null || authToken.isEmpty) {
        throw const FormatException('Missing payment token.');
      }

      final amountInCents = (amountInEgp * 100).round().toString();

      // 2. Order Registration
      final orderResponse = await _dio.post(
        '/ecommerce/orders',
        data: {
          'auth_token': authToken,
          'delivery_needed': false,
          'amount_cents': amountInCents,
          'currency': 'EGP',
          'items': [],
        },
      );
      final orderId = orderResponse.data['id']?.toString();
      if (orderId == null || orderId.isEmpty) {
        throw const FormatException('Missing payment order.');
      }

      final isWallet =
          paymentMethod == 'Vodafone Cash' || paymentMethod == 'Instapay';

      // 💡 الحل الجذري: تحويل النص إلى رقم (Integer) لتفهمه Paymob
      final int integrationId = int.parse(
        isWallet ? _walletIntegrationId : _cardIntegrationId,
      );

      // 3. Payment Key Generation
      final paymentKeyResponse = await _dio.post(
        '/acceptance/payment_keys',
        data: {
          'auth_token': authToken,
          'amount_cents': amountInCents,
          'expiration': 3600,
          'order_id': orderId,
          'currency': 'EGP',
          'integration_id': integrationId, // 💡 إرسال الرقم هنا
          'billing_data': {
            'first_name': 'Customer',
            'last_name': 'KicksVibe',
            'email': email,
            'phone_number': phoneNumber,
            'apartment': 'NA',
            'floor': 'NA',
            'street': 'NA',
            'building': 'NA',
            'city': 'Cairo',
            'country': 'EG',
          },
        },
      );

      final paymentKey = paymentKeyResponse.data['token'] as String?;
      if (paymentKey == null || paymentKey.isEmpty) {
        throw const FormatException('Missing payment key.');
      }

      return paymentKey;
    } on DioException catch (error) {
      final paymobError = error.response?.data?.toString() ?? 'network';
      throw Exception('Payment service is unavailable. ($paymobError)');
    }
  }

  Future<String> getWalletRedirectUrl({
    required String paymentToken,
    required String phoneNumber,
  }) async {
    try {
      final response = await _dio.post(
        '/acceptance/payments/pay',
        data: {
          'source': {'identifier': phoneNumber, 'subtype': 'WALLET'},
          'payment_token': paymentToken,
        },
      );

      final url = response.data['redirect_url'] as String?;
      if (url == null || url.isEmpty) {
        // 💡 استخراج رسالة الخطأ الحقيقية من Paymob لعرضها لو استمرت المشكلة
        final paymobMessage =
            response.data['message'] ??
            response.data['detail'] ??
            response.data.toString();
        throw FormatException('Paymob Error: $paymobMessage');
      }

      return url;
    } on DioException catch (error) {
      final paymobError = error.response?.data?.toString() ?? 'network';
      throw Exception('Could not start wallet payment. ($paymobError)');
    }
  }

  void _ensureConfiguredFor(String paymentMethod) {
    if (!isConfiguredFor(paymentMethod)) {
      final isWallet =
          paymentMethod == 'Vodafone Cash' || paymentMethod == 'Instapay';
      final requiredValues = isWallet
          ? 'PAYMOB_API_KEY and PAYMOB_WALLET_INTEGRATION_ID'
          : 'PAYMOB_API_KEY, PAYMOB_CARD_INTEGRATION_ID and PAYMOB_IFRAME_ID';
      throw StateError(
        'Payment setup is incomplete. Provide $requiredValues using --dart-define.',
      );
    }
  }
}

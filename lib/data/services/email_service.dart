import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/formatters.dart';
import '../models/order_model.dart';

class EmailService {
  static final EmailService _instance = EmailService._internal();
  factory EmailService() => _instance;
  EmailService._internal();

  get _server => gmail(
        AppStrings.smtpUsername,
        AppStrings.smtpPassword,
      );

  Future<void> sendWelcomeEmail({
    required String email,
    required String name,
  }) async {
    final message = Message()
      ..from = Address(AppStrings.smtpUsername, 'FreshBasket')
      ..recipients.add(email)
      ..subject = 'Welcome to FreshBasket!'
      ..html = _welcomeHtml(name);

    try {
      await send(message, _server);
    } catch (_) {}
  }

  Future<void> sendOrderConfirmationEmail({
    required String email,
    required String name,
    required OrderModel order,
  }) async {
    final message = Message()
      ..from = Address(AppStrings.smtpUsername, 'FreshBasket')
      ..recipients.add(email)
      ..subject = 'Order Confirmed — FreshBasket ${order.displayId}'
      ..html = _orderConfirmationHtml(name, order);

    try {
      await send(message, _server);
    } catch (_) {}
  }

  Future<void> sendDeliveredEmail({
    required String email,
    required String name,
    required String orderId,
  }) async {
    final message = Message()
      ..from = Address(AppStrings.smtpUsername, 'FreshBasket')
      ..recipients.add(email)
      ..subject = 'Your FreshBasket order has arrived!'
      ..html = _deliveredHtml(name, orderId);

    try {
      await send(message, _server);
    } catch (_) {}
  }

  String _welcomeHtml(String name) => '''
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"></head>
<body style="margin:0;padding:0;background:#F9FBF7;font-family:'Helvetica Neue',Helvetica,Arial,sans-serif;">
  <div style="max-width:600px;margin:40px auto;background:#fff;border-radius:16px;overflow:hidden;box-shadow:0 4px 24px rgba(0,0,0,0.08);">
    <div style="background:linear-gradient(135deg,#1B5E20,#4CAF50);padding:40px 32px;text-align:center;">
      <h1 style="color:#fff;margin:0;font-size:28px;font-weight:700;">Welcome to FreshBasket</h1>
      <p style="color:rgba(255,255,255,0.85);margin:8px 0 0;font-size:15px;">Farm Fresh, Delivered Daily</p>
    </div>
    <div style="padding:40px 32px;">
      <h2 style="color:#1A1A1A;font-size:20px;margin:0 0 12px;">Hello, ${name.split(' ').first}!</h2>
      <p style="color:#6B7280;font-size:15px;line-height:1.7;margin:0 0 24px;">
        We're thrilled to have you on board. FreshBasket brings the freshest vegetables and fruits
        from local farms directly to your door — within hours of harvest.
      </p>
      <div style="background:#F9FBF7;border-radius:12px;padding:24px;margin-bottom:28px;">
        <p style="color:#1B5E20;font-size:15px;margin:0 0 14px;font-weight:600;">What's waiting for you:</p>
        <p style="color:#374151;font-size:14px;margin:0 0 10px;">✓ Fresh produce from local farms</p>
        <p style="color:#374151;font-size:14px;margin:0 0 10px;">✓ Real-time delivery tracking on map</p>
        <p style="color:#374151;font-size:14px;margin:0;">✓ Secure Mobile Money and Card payments</p>
      </div>
      <div style="text-align:center;">
        <a href="#" style="display:inline-block;background:linear-gradient(135deg,#1B5E20,#4CAF50);color:#fff;text-decoration:none;padding:16px 40px;border-radius:50px;font-size:16px;font-weight:700;">
          Start Shopping
        </a>
      </div>
    </div>
    <div style="border-top:1px solid #E5E7EB;padding:24px 32px;text-align:center;">
      <p style="color:#ADB5BD;font-size:12px;margin:0;">© 2024 FreshBasket. All rights reserved.</p>
    </div>
  </div>
</body>
</html>
''';

  String _orderConfirmationHtml(String name, OrderModel order) {
    final itemsHtml = order.items.map((item) => '''
      <tr>
        <td style="padding:12px 0;border-bottom:1px solid #F3F4F6;color:#374151;font-size:14px;">${item.name}</td>
        <td style="padding:12px 0;border-bottom:1px solid #F3F4F6;color:#6B7280;font-size:14px;text-align:center;">${item.quantity} ${item.unit}</td>
        <td style="padding:12px 0;border-bottom:1px solid #F3F4F6;color:#1B5E20;font-size:14px;text-align:right;font-weight:600;">${Formatters.currency(item.totalPrice)}</td>
      </tr>
    ''').join();

    return '''
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"></head>
<body style="margin:0;padding:0;background:#F9FBF7;font-family:'Helvetica Neue',Helvetica,Arial,sans-serif;">
  <div style="max-width:600px;margin:40px auto;background:#fff;border-radius:16px;overflow:hidden;box-shadow:0 4px 24px rgba(0,0,0,0.08);">
    <div style="background:linear-gradient(135deg,#1B5E20,#4CAF50);padding:40px 32px;text-align:center;">
      <h1 style="color:#fff;margin:0;font-size:26px;font-weight:700;">Order Confirmed!</h1>
      <p style="color:rgba(255,255,255,0.85);margin:8px 0 0;font-size:15px;">${order.displayId}</p>
    </div>
    <div style="padding:40px 32px;">
      <p style="color:#374151;font-size:15px;line-height:1.7;margin:0 0 28px;">
        Hi ${name.split(' ').first}, your order has been placed successfully. We are preparing your fresh produce now!
      </p>
      <h3 style="color:#1A1A1A;font-size:16px;margin:0 0 16px;">Order Summary</h3>
      <table style="width:100%;border-collapse:collapse;">
        <thead>
          <tr>
            <th style="text-align:left;color:#6B7280;font-size:12px;font-weight:600;padding-bottom:8px;text-transform:uppercase;">Item</th>
            <th style="text-align:center;color:#6B7280;font-size:12px;font-weight:600;padding-bottom:8px;text-transform:uppercase;">Qty</th>
            <th style="text-align:right;color:#6B7280;font-size:12px;font-weight:600;padding-bottom:8px;text-transform:uppercase;">Price</th>
          </tr>
        </thead>
        <tbody>$itemsHtml</tbody>
      </table>
      <div style="border-top:2px solid #1B5E20;margin-top:16px;padding-top:16px;">
        <table style="width:100%;border-collapse:collapse;">
          <tr><td style="color:#6B7280;font-size:14px;padding:4px 0;">Subtotal</td><td style="color:#374151;font-size:14px;text-align:right;">${Formatters.currency(order.subtotal)}</td></tr>
          <tr><td style="color:#6B7280;font-size:14px;padding:4px 0;">Delivery Fee</td><td style="color:#374151;font-size:14px;text-align:right;">${Formatters.currency(order.deliveryFee)}</td></tr>
          ${order.discount > 0 ? '<tr><td style="color:#4CAF50;font-size:14px;padding:4px 0;">Discount</td><td style="color:#4CAF50;font-size:14px;text-align:right;">-${Formatters.currency(order.discount)}</td></tr>' : ''}
          <tr><td style="color:#1A1A1A;font-size:16px;font-weight:700;padding:8px 0 0;">Total</td><td style="color:#1B5E20;font-size:16px;font-weight:700;text-align:right;padding-top:8px;">${Formatters.currency(order.total)}</td></tr>
        </table>
      </div>
      <div style="background:#F9FBF7;border-radius:12px;padding:20px;margin-top:28px;">
        <p style="margin:0 0 8px;color:#6B7280;font-size:12px;font-weight:600;text-transform:uppercase;">Delivery Details</p>
        <p style="margin:0 0 6px;color:#374151;font-size:14px;">${order.address.fullAddress}</p>
        <p style="margin:0;color:#374151;font-size:14px;">Time Slot: ${order.timeSlot}</p>
      </div>
    </div>
    <div style="border-top:1px solid #E5E7EB;padding:24px 32px;text-align:center;">
      <p style="color:#ADB5BD;font-size:12px;margin:0;">© 2024 FreshBasket</p>
    </div>
  </div>
</body>
</html>
''';
  }

  String _deliveredHtml(String name, String orderId) => '''
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"></head>
<body style="margin:0;padding:0;background:#F9FBF7;font-family:'Helvetica Neue',Helvetica,Arial,sans-serif;">
  <div style="max-width:600px;margin:40px auto;background:#fff;border-radius:16px;overflow:hidden;box-shadow:0 4px 24px rgba(0,0,0,0.08);">
    <div style="background:linear-gradient(135deg,#1B5E20,#4CAF50);padding:40px 32px;text-align:center;">
      <h1 style="color:#fff;margin:0;font-size:26px;font-weight:700;">Your order has arrived!</h1>
      <p style="color:rgba(255,255,255,0.85);margin:8px 0 0;font-size:15px;">#${orderId.substring(0, 8).toUpperCase()}</p>
    </div>
    <div style="padding:40px 32px;text-align:center;">
      <p style="color:#374151;font-size:16px;line-height:1.7;margin:0 0 28px;">
        Hi ${name.split(' ').first}! Your fresh produce has been delivered. We hope everything looks amazing!
      </p>
      <p style="color:#6B7280;font-size:15px;line-height:1.7;margin:0 0 32px;">
        Help other customers by reviewing the items you received. It only takes a minute.
      </p>
      <a href="#" style="display:inline-block;background:linear-gradient(135deg,#1B5E20,#4CAF50);color:#fff;text-decoration:none;padding:16px 40px;border-radius:50px;font-size:16px;font-weight:700;">
        Leave a Review
      </a>
    </div>
    <div style="border-top:1px solid #E5E7EB;padding:24px 32px;text-align:center;">
      <p style="color:#ADB5BD;font-size:12px;margin:0;">© 2024 FreshBasket</p>
    </div>
  </div>
</body>
</html>
''';
}

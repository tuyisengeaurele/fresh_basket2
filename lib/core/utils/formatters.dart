import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static String currency(double amount, {String symbol = 'RWF'}) {
    final formatter = NumberFormat('#,###', 'en_US');
    return '$symbol ${formatter.format(amount.round())}';
  }

  static String date(DateTime dt) => DateFormat('dd MMM yyyy').format(dt);

  static String dateTime(DateTime dt) =>
      DateFormat('dd MMM yyyy • HH:mm').format(dt);

  static String time(DateTime dt) => DateFormat('HH:mm').format(dt);

  static String relativeTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return date(dt);
  }

  static String orderID(String id) =>
      '#${id.substring(0, 8).toUpperCase()}';

  static String weight(double kg) {
    if (kg < 1) return '${(kg * 1000).round()}g';
    return '${kg.toStringAsFixed(1)} kg';
  }

  static String countdown(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return d.inHours > 0 ? '$h:$m:$s' : '$m:$s';
  }
}

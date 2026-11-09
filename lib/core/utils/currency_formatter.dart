import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _formatter = NumberFormat('#,##0');

  static String format(num amount) {
    return _formatter.format(amount);
  }
}

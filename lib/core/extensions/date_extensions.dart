import 'package:intl/intl.dart';

extension DateExtensions on DateTime {
  String toFormattedString() {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  String toDateTimeString() {
    return DateFormat('yyyy-MM-dd HH:mm').format(this);
  }

  String toFriendlyDate() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays == 0) {
      return 'Today, ${DateFormat('HH:mm').format(this)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday, ${DateFormat('HH:mm').format(this)}';
    }
    return DateFormat('MMM d, yyyy').format(this);
  }
}

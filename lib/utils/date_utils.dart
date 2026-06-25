import 'package:intl/intl.dart';

class DateUtils {
  static String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }

  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inDays > 365) return '${(difference.inDays / 365).floor()}年前';
    if (difference.inDays > 30) return '${(difference.inDays / 30).floor()}月前';
    if (difference.inDays > 0) return '${difference.inDays}天前';
    if (difference.inHours > 0) return '${difference.inHours}小时前';
    if (difference.inMinutes > 0) return '${difference.inMinutes}分钟前';
    return '刚刚';
  }
}
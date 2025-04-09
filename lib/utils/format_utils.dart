import 'package:intl/intl.dart';

class FormatUtils {
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  static String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('MMM dd, HH:mm');
    return formatter.format(dateTime);
  }

  static String formatDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('MMM dd, yyyy');
    return formatter.format(dateTime);
  }
}

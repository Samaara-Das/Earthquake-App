import 'package:intl/intl.dart';

String getFormattedDateTime(num dt, [String pattern = 'yyyy-MM-dd']) =>
    DateFormat(pattern).format(DateTime.fromMillisecondsSinceEpoch(dt.toInt()));


import 'package:intl/intl.dart';

String formattedDate(String date) {
  DateTime stringToIsoString = DateTime.parse(date);
  return DateFormat("EEEE, dd MMMM yyyy").format(stringToIsoString);
}

const List<String> months = [
  '',
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember'
];
const List<String> nameOfDay = ['', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
const List<String> monthsAbv = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'];

NumberFormat formatter = NumberFormat('#,###', 'en_US');

Duration getTimeStringDifferenceFromNowInDuration(String s) {
  return (DateTime.tryParse(s) ?? DateTime.now()).difference(DateTime.now());
}

String printDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  final String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  final String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}

bool checkStringIsToday(String s) {
  // DateTime d = DateTime.parse(s).toLocal();
  final DateTime d = DateTime.parse(s);
  return d.isAfter(DateTime.now().subtract(const Duration(days: 1)));
}

String getStringFromDate(DateTime d) {
  return d.year.toString() +
      '-' +
      (d.month < 10 ? ('0' + d.month.toString()) : d.month.toString()) +
      '-' +
      (d.day < 10 ? ('0' + d.day.toString()) : d.day.toString()) +
      " " +
      ((d.hour < 10) ? '0' + d.hour.toString() : d.hour.toString()) +
      ':' +
      ((d.minute < 10) ? '0' + d.minute.toString() : d.minute.toString());
}

String getDateAfterNDay(String s, int n) {
  // print(s);
  if (DateTime.tryParse(s) == null) {
    List<String> ss = s.split('-');
    if (ss[1].length == 1) {
      ss[1] = '0' + ss[1];
    }
    if (ss[2].length == 1) {
      ss[2] = '0' + ss[2];
    }
    s = ss.join("-");
  }
  // print(s);
  // DateTime d = DateTime.parse(s).toLocal();
  DateTime d = DateTime.parse(s);
  return getDateAsString(d.add(Duration(days: n)).toString());
}

String getDateAsString(String s) {
  if (DateTime.tryParse(s) == null) {
    final List<String> ss = s.split('-');
    if (ss[1].length == 1) {
      ss[1] = '0' + ss[1];
    }
    if (ss[2].length == 1) {
      ss[2] = '0' + ss[2];
    }
    s = ss.join("-");
  }
  DateTime d = DateTime.parse(s);
  // DateTime d = DateTime.parse(s).toLocal();
  // if(s.contains('T')) d= d.add(Duration(hours: 7));
  return nameOfDay[d.weekday] + ', ' + d.day.toString() + ' ' + months[d.month] + ' ' + d.year.toString();
}

String getDateAsStringMonth(String s) {
  if (DateTime.tryParse(s) == null) {
    final List<String> ss = s.split('-');
    if (ss[1].length == 1) {
      ss[1] = '0' + ss[1];
    }
    if (ss[2].length == 1) {
      ss[2] = '0' + ss[2];
    }
    s = ss.join("-");
  }
  // DateTime d = DateTime.parse(s).toLocal();
  DateTime d = DateTime.parse(s);
  // print(d.toString());
  // if(s.contains('T')) d= d.add(Duration(hours: 7));
  return d.day.toString() + ' ' + months[d.month] + ' ' + d.year.toString();
}

String getDateAsDateString(String s) {
  // DateTime d = DateTime.parse(s).toLocal();
  final DateTime d = DateTime.parse(s);
  // if(s.contains('T')) d= d.add(Duration(hours: 7));
  return d.year.toString() + '-' + d.month.toString() + '-' + d.day.toString();
}

String getDatToSaveToDB(String s) {
  // DateTime d = DateTime.parse(s).toLocal();
  final DateTime d = DateTime.parse(s);
  // if(s.contains('T')) d= d.add(Duration(hours: 7));
  return d.year.toString() +
      '-' +
      (d.month < 10 ? ('0' + d.month.toString()) : d.month.toString()) +
      '-' +
      (d.day < 10 ? ('0' + d.day.toString()) : d.day.toString());
}

String getMonthAndYear(String s) {
  // DateTime d = DateTime.parse(s).toLocal().toLocal();
  final DateTime d = DateTime.parse(s);
  // if(s.contains('T')) d= d.add(Duration(hours: 7));
  return months[d.month] + ' ' + d.year.toString();
}

String getDateDay(String s) {
  // DateTime d = DateTime.parse(s).toLocal();
  final DateTime d = DateTime.parse(s);
  // if(s.contains('T')) d= d.add(Duration(hours: 7));
  return d.day.toString();
}

String getDateAsTimeClock(String s) {
  // DateTime d = DateTime.parse(s).toLocal();
  final DateTime d = DateTime.parse(s);
  // if(s.contains('T')) d= d.add(Duration(hours: 7));
  return ((d.hour < 10) ? '0' + d.hour.toString() : d.hour.toString()) + ':' + ((d.minute < 10) ? '0' + d.minute.toString() : d.minute.toString());
}

String getDateAsDateAndTime(String s) {
  // DateTime d = DateTime.parse(s);
  final DateTime d = DateTime.parse(s);
  // DateTime d = DateTime.parse(s).toLocal();
  // if(s.contains('T')) d= d.add(Duration(hours: 7));
  return nameOfDay[d.weekday] +
      ', ' +
      d.day.toString() +
      ' ' +
      months[d.month] +
      ' ' +
      d.year.toString() +
      ", " +
      ((d.hour < 10) ? '0' + d.hour.toString() : d.hour.toString()) +
      ':' +
      ((d.minute < 10) ? '0' + d.minute.toString() : d.minute.toString());
}

String getDateAsDateAndTimeWithChecker(String s) {
  DateTime d = DateTime.parse(s);
  final DateTime now = DateTime.now();
  int dif = d.difference(now).inHours;
  // print(dif);
  if (dif < 0) {
    d = d.add(Duration(hours: dif + 1));
  } else if (dif > 1) {
    d = d.subtract(Duration(hours: dif + 1));
  }
  return nameOfDay[d.weekday] +
      ', ' +
      d.day.toString() +
      ' ' +
      months[d.month] +
      ' ' +
      d.year.toString() +
      ", " +
      ((d.hour < 10) ? '0' + d.hour.toString() : d.hour.toString()) +
      ':' +
      ((d.minute < 10) ? '0' + d.minute.toString() : d.minute.toString());
}

DateTime dateParse(String s) {
  // DateTime d = DateTime.parse(s);
  DateTime d = DateTime.parse(s).toLocal();
  final DateTime now = DateTime.now();
  final int dif = d.difference(now).inHours;
  // print(dif);
  if (dif < 0) {
    d = d.add(Duration(hours: dif + 1));
  } else if (dif > 1) {
    d = d.subtract(Duration(hours: dif + 1));
  }
  // print("string : $s ,, d : "+d.toString());
  return d;
}

DateTime dateParseForFanTimeline(String s) {
  // DateTime d = DateTime.parse(s);
  DateTime d = DateTime.parse(s).toLocal();
  final DateTime now = DateTime.now();
  final int dif = d.difference(now).inHours;
  // print(dif);
  if (dif < 0) {
    d = d.add(Duration(hours: dif + 1));
  } else if (dif > 1) {
    d = d.subtract(Duration(hours: dif + 1));
  }
  // print("string : $s ,, d : "+d.toString());
  return d;
}

String getDateWithMonthAbv(String dateyyyymmdd) {
  // print('datee =>$dateyyyymmdd');
  final List<String> d = dateyyyymmdd.split("-");
  // print('split date =>${d[1]}');
  final int m = int.tryParse(d[1]) ?? 0;
  return "${d[2]} ${monthsAbv[m]} ${d[0]}";
}

String getDateWithMonthAbv2(String dateyyyymmdd) {
  // print('datee =>$dateyyyymmdd');
  final List<String> datewoyear = dateyyyymmdd.split(" ");
  final List<String> d = datewoyear[0].split("-");
  // print('split date =>${d[1]}');
  final int m = int.tryParse(d[1]) ?? 0;
  return "${d[2]} ${monthsAbv[m]} ${d[0]}";
}

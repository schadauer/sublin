import 'package:Sublin/models/delimiter_class.dart';

String getNextDelimiter({String formattedAddress, String delimiter}) {
  String nextDelimiter = '__NODELIMITER__';
  switch (delimiter) {
    case Delimiter.station:
      nextDelimiter = Delimiter.country;
      break;
    case Delimiter.country:
      nextDelimiter = Delimiter.city;
      break;
    case Delimiter.city:
      if (formattedAddress.contains(Delimiter.street)) {
        nextDelimiter = Delimiter.street;
      }
      if (formattedAddress.contains(Delimiter.station) &&
          formattedAddress.indexOf(Delimiter.city) !=
              formattedAddress.lastIndexOf(Delimiter.city)) {
        nextDelimiter = Delimiter.station;
      }
      break;
    case Delimiter.street:
      if (formattedAddress.contains(Delimiter.number)) {
        nextDelimiter = Delimiter.number;
      } else if (formattedAddress.contains(Delimiter.company)) {
        nextDelimiter = Delimiter.company;
      } else if (formattedAddress.contains(Delimiter.station))
        nextDelimiter = Delimiter.station;
      break;
    case Delimiter.number:
      if (formattedAddress.contains(Delimiter.company)) {
        nextDelimiter = Delimiter.company;
      } else if (formattedAddress.contains(Delimiter.station))
        nextDelimiter = Delimiter.station;
      break;
  }

  return nextDelimiter;
}

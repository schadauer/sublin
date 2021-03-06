import 'dart:async';

import 'package:Sublin/models/booking_completed_class.dart';
import 'package:Sublin/models/booking_confirmed_class.dart';
import 'package:Sublin/models/booking_open_class.dart';
import 'package:Sublin/models/preferences_enum.dart';
import 'package:Sublin/utils/logging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' as Foundation;

class BookingService {
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  Stream<List<BookingOpen>> streamOpenBookings(uid) {
    try {
      return _database
          .collection('bookings')
          .doc(uid)
          .collection('open')
          .snapshots()
          .map((snapshot) => snapshot.docs.map((document) {
                if (!Foundation.kReleaseMode) {
                  sublinLogging(Preferences.intLoggingBookings);
                }
                return BookingOpen.fromJson(document.data(), document.id);
              }).toList());
    } catch (e) {
      print(e);
      return null;
    }
  }

  Stream<List<BookingConfirmed>> streamConfirmedBookings(uid) {
    try {
      // if (!Foundation.kReleaseMode) {
      //   sublinLogging(Preferences.intLoggingBookings);
      // }
      return _database
          .collection('bookings')
          .doc(uid)
          .collection('confirmed')
          .snapshots()
          .map((snapshot) => snapshot.docs.map((document) {
                return BookingConfirmed.fromJson(document.data(), document.id);
              }).toList());
    } catch (e) {
      print(e);
      return null;
    }
  }

  Stream<List<BookingCompleted>> streamCompletedBookings(uid) {
    try {
      // if (!Foundation.kReleaseMode) {
      //   sublinLogging(Preferences.intLoggingBookings);
      // }
      return _database
          .collection('bookings')
          .doc(uid)
          .collection('completed')
          .snapshots()
          .map((snapshot) => snapshot.docs.map((document) {
                return BookingCompleted.fromJson(document.data(), document.id);
              }).toList());
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> confirmBooking({
    String providerId,
    String userId,
    bool isSublinEndStep,
    int index,
  }) async {
    try {
      if (!Foundation.kReleaseMode) {
        sublinLogging(Preferences.intLoggingBookings);
      }
      _database
          .collection('bookings')
          .doc(providerId)
          .collection('open')
          .doc(userId)
          .set({
        isSublinEndStep ? 'sublinEndStep' : "sublinStartStep": {
          'confirmed': true,
        }
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  Future<void> completedBooking({
    String providerId,
    String userId,
    bool isSublinEndStep,
    int index,
  }) async {
    try {
      if (!Foundation.kReleaseMode) {
        sublinLogging(Preferences.intLoggingBookings);
      }
      _database
          .collection('bookings')
          .doc(providerId)
          .collection('confirmed')
          .doc(userId)
          .set({
        isSublinEndStep ? 'sublinEndStep' : "sublinStartStep": {
          'completed': true,
          'completedTime': DateTime.now().microsecondsSinceEpoch,
        }
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  Future<void> noShowBooking(
      {providerId, String userId, bool isSublinEndStep, int index}) async {
    try {
      if (!Foundation.kReleaseMode) {
        sublinLogging(Preferences.intLoggingBookings);
      }
      _database
          .collection('bookings')
          .doc(providerId)
          .collection('confirmed')
          .doc(userId)
          .set({
        isSublinEndStep ? 'sublinEndStep' : "sublinStartStep": {
          'completed': true,
          'noShow': true,
          'noShowTime': DateTime.now().microsecondsSinceEpoch,
        }
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }
}

import 'package:alarm_app_020724/Medicine_notification/medicine_notification_manager.dart';
import 'package:alarm_app_020724/Medicine_notification/medicine_notification_model.dart';
import 'package:alarm_app_020724/boxes.dart';
import 'package:flutter/material.dart';

abstract class AdhanNotificationSetupAbstract {
  Future<bool> setNotificationIfConditionsMet(BuildContext context);
}

class AdhanNotificationSetup implements AdhanNotificationSetupAbstract {
  final medicineBox = Boxes().medicineNotification;

  // _setCurrentLocationForAdhan() async {
  //   await adhanNotificationBox.put('lat', utilsBox.get('lat'));
  //   await adhanNotificationBox.put('long', utilsBox.get('long'));
  // }

  // Map<int, SalahReminderModel> _formatSalahReminderModelFromHive(dynamic map) {
  //   return {
  //     1: SalahReminderModel.fromJson(map[1]),
  //     2: SalahReminderModel.fromJson(map[2]),
  //     3: SalahReminderModel.fromJson(map[3]),
  //     4: SalahReminderModel.fromJson(map[4]),
  //     5: SalahReminderModel.fromJson(map[5]),
  //     6: SalahReminderModel.fromJson(map[6])
  //   };
  // }

  // Map<int, SalahReminderModel> _getFormatedSalahReminderModelFromHive() {
  //   final salahReminderBox = Boxes().salahReminderBox;
  //   final salaReminderMapFromHive = salahReminderBox.get('salahReminderMap');
  //   final savedSalahReminderMap =
  //       _formatSalahReminderModelFromHive(salaReminderMapFromHive);

  //   return savedSalahReminderMap;
  // }

  setNotificationForMedicine(
    BuildContext context,
    int id,
    String name,
    dynamic takingTime,
    dynamic note,
    DateTime time,
  ) async {
    // MedicineReminderModel adhanReminders = AdhanReminders(
    //     lat: lat,
    //     long: long,
    //     adhanForAsr: const AdhanForWakto(adhanName: 'azan'),
    //     adhanForDhuhr: const AdhanForWakto(adhanName: 'azan'),
    //     adhanForIsha: const AdhanForWakto(adhanName: 'azan'),
    //     adhanForFajr: const AdhanForWakto(adhanName: "azan"),
    //     adhanForMaghrib: const AdhanForWakto(adhanName: "azan"));

    //------------------- if user wants to disable alarm for any waqt -----------------------
    // final salahReminderBox = Boxes().salahReminderBox;
    // if (salahReminderBox.keys.isNotEmpty) {
    //   final savedSalahReminder = _getFormatedSalahReminderModelFromHive();
    //   adhanReminders = AdhanReminders(
    //     lat: lat,
    //     long: long,
    //     adhanForAsr: AdhanForWakto(
    //         adhanName: 'azan', isAdhanOn: savedSalahReminder[3]!.isEnabled),
    //     adhanForDhuhr: AdhanForWakto(
    //         adhanName: 'azan', isAdhanOn: savedSalahReminder[2]!.isEnabled),
    //     adhanForIsha: AdhanForWakto(
    //         adhanName: 'azan', isAdhanOn: savedSalahReminder[5]!.isEnabled),
    //     adhanForFajr: AdhanForWakto(
    //         adhanName: "azan", isAdhanOn: savedSalahReminder[1]!.isEnabled),
    //     adhanForMaghrib: AdhanForWakto(
    //         adhanName: "azan", isAdhanOn: savedSalahReminder[4]!.isEnabled),
    //   );
    // }

    //------------------- if user wants to disable alarm for any waqt -----------------------

    MedicineReminderModel().initialization(id, name, takingTime, note, time);
    NotificationManager notificationManager = NotificationManager();
    notificationManager.initialise(context);

    // notificationManager.cancelNotification();
    for (var medicinereminder in MedicineReminderModel().medicineReminders) {
      notificationManager.setNotification(
        time: medicinereminder.time,
        id: medicinereminder.id,
        name: medicinereminder.medicneName,
        tekingTime: medicinereminder.takeTime,
      );
    }
  }

  @override
  Future<bool> setNotificationIfConditionsMet(BuildContext context) {
    // TODO: implement setNotificationIfConditionsMet
    throw UnimplementedError();
  }

  // _setStartAndEndTimeForAdhan() async {
  //   await adhanNotificationBox.put('startDate', DateTime.now().toString());
  //   await adhanNotificationBox.put(
  //       'endDate', DateTime.now().add(const Duration(days: 10)).toString());
  // }
}

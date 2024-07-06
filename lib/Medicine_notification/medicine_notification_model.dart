import 'dart:convert';

import 'package:flutter/material.dart';

class MedicineReminderModel {
  List<MedicineReminder> medicineReminders = [];

  initialization(
    int id,
    String name,
    takingTime,
    note,
    DateTime time,
  ) {
    medicineReminders.add(MedicineReminder(
      id: id,
      medicneName: name,
      time: time,
      takeTime: takingTime,
      note: note,
    ));
  }
}

class MedicineReminder {
  int id;
  String medicneName;
  String takeTime;
  DateTime time;
  String note;
  MedicineReminder({required this.id, required this.medicneName, required this.takeTime, required this.time, required this.note});
}

import 'package:hive_flutter/hive_flutter.dart';

class Boxes {
  Box<dynamic> get medicineNotification => Hive.box('medicineAlart');
}

import 'package:hive/hive.dart';

part 'person.g.dart';

@HiveType(typeId: 1)
class Person extends HiveObject {
  @HiveField(0)
  String? title;
  @HiveField(1)
  String? subtitle;
  @HiveField(2)
  String? date;

  Person({ this.title, this.subtitle, this.date});
}

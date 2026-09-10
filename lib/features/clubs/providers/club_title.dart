import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClubTitleNotifier extends Notifier<String> {
  @override
  String build() => '';

  void set(String value) => state = value;
}

final clubTitleProvider = NotifierProvider<ClubTitleNotifier, String>(ClubTitleNotifier.new);

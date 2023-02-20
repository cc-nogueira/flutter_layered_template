part of '../contacts_use_case.dart';

@Riverpod(keepAlive: true)
class ContactsGuardNotifier extends _$ContactsGuardNotifier {
  @override
  bool build() {
    return false;
  }

  void _startProcessing() => state = true;

  void _finishedProcessing() => state = false;
}

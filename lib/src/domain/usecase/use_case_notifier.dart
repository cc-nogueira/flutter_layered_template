import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

abstract class UseCaseNotifier<State> extends Notifier<State> {
  @override
  @protected
  set state(State value) => super.state = value;
}

abstract class UseCaseFamilyNotifier<State, Arg> extends FamilyNotifier<State, Arg> {
  @override
  @protected
  set state(State value) => super.state = value;
}

abstract class UseCaseAutoDisposeFamilyAsyncNotifier<State, Arg> extends AutoDisposeFamilyAsyncNotifier<State, Arg> {}

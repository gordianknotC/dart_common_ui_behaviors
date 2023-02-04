// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'picked_aware.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PickedAware<T> on _PickedAware<T>, Store {
  Computed<bool>? _$hasPickedUpComputed;

  @override
  bool get hasPickedUp =>
      (_$hasPickedUpComputed ??= Computed<bool>(() => super.hasPickedUp,
              name: '_PickedAware.hasPickedUp'))
          .value;
  Computed<int>? _$pickedElementsComputed;

  @override
  int get pickedElements =>
      (_$pickedElementsComputed ??= Computed<int>(() => super.pickedElements,
              name: '_PickedAware.pickedElements'))
          .value;

  late final _$pickedAtom = Atom(name: '_PickedAware.picked', context: context);

  @override
  ObservableList<T> get picked {
    _$pickedAtom.reportRead();
    return super.picked;
  }

  @override
  set picked(ObservableList<T> value) {
    _$pickedAtom.reportWrite(value, super.picked, () {
      super.picked = value;
    });
  }

  @override
  String toString() {
    return '''
picked: ${picked},
hasPickedUp: ${hasPickedUp},
pickedElements: ${pickedElements}
    ''';
  }
}

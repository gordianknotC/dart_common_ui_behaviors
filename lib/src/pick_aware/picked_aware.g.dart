// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'picked_aware.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PickableAware<T> on _PickedAware<T>, Store {
  Computed<bool> _$hasPickedUpComputed;

  @override
  bool get hasPickedUp =>
      (_$hasPickedUpComputed ??= Computed<bool>(() => super.hasPickedUp)).value;
  Computed<int> _$pickedElementsComputed;

  @override
  int get pickedElements =>
      (_$pickedElementsComputed ??= Computed<int>(() => super.pickedElements))
          .value;

  final _$pickedAtom = Atom(name: '_PickableReact.picked');

  @override
  ObservableList<T> get picked {
    _$pickedAtom.context.enforceReadPolicy(_$pickedAtom);
    _$pickedAtom.reportObserved();
    return super.picked;
  }

  @override
  set picked(ObservableList<T> value) {
    _$pickedAtom.context.conditionallyRunInAction(() {
      super.picked = value;
      _$pickedAtom.reportChanged();
    }, _$pickedAtom, name: '${_$pickedAtom.name}_set');
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'single_group_aware.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SingleGroupAware<T> on _SingleGroupAware<T>, Store {
  Computed<bool> _$hasActivatedElementsComputed;

  @override
  bool get hasActivatedElements => (_$hasActivatedElementsComputed ??=
          Computed<bool>(() => super.hasActivatedElements))
      .value;
  Computed<int> _$activatedElementsComputed;

  @override
  int get activatedElements => (_$activatedElementsComputed ??=
          Computed<int>(() => super.activatedElements))
      .value;
  Computed<ObservableList<T>> _$property_activationsComputed;

  @override
  ObservableList<T> get property_activations =>
      (_$property_activationsComputed ??=
              Computed<ObservableList<T>>(() => super.property_activations))
          .value;

  final _$groupAtom = Atom(name: '_SingleGroupAware.group');

  @override
  ObservableList<T> get group {
    _$groupAtom.context.enforceReadPolicy(_$groupAtom);
    _$groupAtom.reportObserved();
    return super.group;
  }

  @override
  set group(ObservableList<T> value) {
    _$groupAtom.context.conditionallyRunInAction(() {
      super.group = value;
      _$groupAtom.reportChanged();
    }, _$groupAtom, name: '${_$groupAtom.name}_set');
  }

  final _$prevActivatedAtom = Atom(name: '_SingleGroupAware.prevActivated');

  @override
  ObservableList<T> get prevActivated {
    _$prevActivatedAtom.context.enforceReadPolicy(_$prevActivatedAtom);
    _$prevActivatedAtom.reportObserved();
    return super.prevActivated;
  }

  @override
  set prevActivated(ObservableList<T> value) {
    _$prevActivatedAtom.context.conditionallyRunInAction(() {
      super.prevActivated = value;
      _$prevActivatedAtom.reportChanged();
    }, _$prevActivatedAtom, name: '${_$prevActivatedAtom.name}_set');
  }

  final _$activatedsAtom = Atom(name: '_SingleGroupAware.activateds');

  @override
  ObservableList<T> get activateds {
    _$activatedsAtom.context.enforceReadPolicy(_$activatedsAtom);
    _$activatedsAtom.reportObserved();
    return super.activateds;
  }

  @override
  set activateds(ObservableList<T> value) {
    _$activatedsAtom.context.conditionallyRunInAction(() {
      super.activateds = value;
      _$activatedsAtom.reportChanged();
    }, _$activatedsAtom, name: '${_$activatedsAtom.name}_set');
  }
}

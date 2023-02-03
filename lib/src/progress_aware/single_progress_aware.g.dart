// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'single_progress_aware.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SingleProgressAware<T> on _SingleProgressAware<T>, Store {
  Computed<bool> _$isInitializedComputed;

  @override
  bool get isInitialized =>
      (_$isInitializedComputed ??= Computed<bool>(() => super.isInitialized))
          .value;
  Computed<bool> _$isStartedComputed;

  @override
  bool get isStarted =>
      (_$isStartedComputed ??= Computed<bool>(() => super.isStarted)).value;
  Computed<bool> _$isFinishedComputed;

  @override
  bool get isFinished =>
      (_$isFinishedComputed ??= Computed<bool>(() => super.isFinished)).value;
  Computed<double> _$property_progressComputed;

  @override
  double get progress => (_$property_progressComputed ??=
          Computed<double>(() => super.progress))
      .value;

  final _$totalAtom = Atom(name: '_SingleProgressAware.total');

  @override
  double get total {
    _$totalAtom.context.enforceReadPolicy(_$totalAtom);
    _$totalAtom.reportObserved();
    return super.total;
  }

  @override
  set total(double value) {
    _$totalAtom.context.conditionallyRunInAction(() {
      super.total = value;
      _$totalAtom.reportChanged();
    }, _$totalAtom, name: '${_$totalAtom.name}_set');
  }

  final _$currentAtom = Atom(name: '_SingleProgressAware.current');

  @override
  double get current {
    _$currentAtom.context.enforceReadPolicy(_$currentAtom);
    _$currentAtom.reportObserved();
    return super.current;
  }

  @override
  set current(double value) {
    _$currentAtom.context.conditionallyRunInAction(() {
      super.current = value;
      _$currentAtom.reportChanged();
    }, _$currentAtom, name: '${_$currentAtom.name}_set');
  }
}

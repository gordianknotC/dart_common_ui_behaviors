// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scroll_aware.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ScrollAccAware<T> on _ScrollAccAware<T>, Store {
  final _$offsetAtom = Atom(name: '_ScrollAccAware.offset');

  @override
  double get offset {
    _$offsetAtom.context.enforceReadPolicy(_$offsetAtom);
    _$offsetAtom.reportObserved();
    return super.offset;
  }

  @override
  set offset(double value) {
    _$offsetAtom.context.conditionallyRunInAction(() {
      super.offset = value;
      _$offsetAtom.reportChanged();
    }, _$offsetAtom, name: '${_$offsetAtom.name}_set');
  }

  final _$deltaAtom = Atom(name: '_ScrollAccAware.delta');

  @override
  double get delta {
    _$deltaAtom.context.enforceReadPolicy(_$deltaAtom);
    _$deltaAtom.reportObserved();
    return super.delta;
  }

  @override
  set delta(double value) {
    _$deltaAtom.context.conditionallyRunInAction(() {
      super.delta = value;
      _$deltaAtom.reportChanged();
    }, _$deltaAtom, name: '${_$deltaAtom.name}_set');
  }
}

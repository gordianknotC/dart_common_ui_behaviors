// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scroll_aware.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ScrollAccAware<T> on _ScrollAccAware<T>, Store {
  late final _$offsetAtom =
      Atom(name: '_ScrollAccAware.offset', context: context);

  @override
  double get offset {
    _$offsetAtom.reportRead();
    return super.offset;
  }

  @override
  set offset(double value) {
    _$offsetAtom.reportWrite(value, super.offset, () {
      super.offset = value;
    });
  }

  late final _$deltaAtom =
      Atom(name: '_ScrollAccAware.delta', context: context);

  @override
  double get delta {
    _$deltaAtom.reportRead();
    return super.delta;
  }

  @override
  set delta(double value) {
    _$deltaAtom.reportWrite(value, super.delta, () {
      super.delta = value;
    });
  }

  @override
  String toString() {
    return '''
offset: ${offset},
delta: ${delta}
    ''';
  }
}

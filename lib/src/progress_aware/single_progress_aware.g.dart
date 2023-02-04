// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'single_progress_aware.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SingleProgressAware<T> on _SingleProgressAware<T>, Store {
  Computed<bool>? _$isInitializedComputed;

  @override
  bool get isInitialized =>
      (_$isInitializedComputed ??= Computed<bool>(() => super.isInitialized,
              name: '_SingleProgressAware.isInitialized'))
          .value;
  Computed<bool>? _$isStartedComputed;

  @override
  bool get isStarted =>
      (_$isStartedComputed ??= Computed<bool>(() => super.isStarted,
              name: '_SingleProgressAware.isStarted'))
          .value;
  Computed<bool>? _$isFinishedComputed;

  @override
  bool get isFinished =>
      (_$isFinishedComputed ??= Computed<bool>(() => super.isFinished,
              name: '_SingleProgressAware.isFinished'))
          .value;
  Computed<double>? _$progressComputed;

  @override
  double get progress =>
      (_$progressComputed ??= Computed<double>(() => super.progress,
              name: '_SingleProgressAware.progress'))
          .value;

  late final _$totalAtom =
      Atom(name: '_SingleProgressAware.total', context: context);

  @override
  double? get total {
    _$totalAtom.reportRead();
    return super.total;
  }

  @override
  set total(double? value) {
    _$totalAtom.reportWrite(value, super.total, () {
      super.total = value;
    });
  }

  late final _$currentAtom =
      Atom(name: '_SingleProgressAware.current', context: context);

  @override
  double? get current {
    _$currentAtom.reportRead();
    return super.current;
  }

  @override
  set current(double? value) {
    _$currentAtom.reportWrite(value, super.current, () {
      super.current = value;
    });
  }

  @override
  String toString() {
    return '''
total: ${total},
current: ${current},
isInitialized: ${isInitialized},
isStarted: ${isStarted},
isFinished: ${isFinished},
progress: ${progress}
    ''';
  }
}

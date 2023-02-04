// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'single_group_aware.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SingleGroupAware<T> on _SingleGroupAware<T>, Store {
  Computed<bool>? _$hasActivatedElementsComputed;

  @override
  bool get hasActivatedElements => (_$hasActivatedElementsComputed ??=
          Computed<bool>(() => super.hasActivatedElements,
              name: '_SingleGroupAware.hasActivatedElements'))
      .value;
  Computed<int>? _$activatedElementsComputed;

  @override
  int get activatedElements => (_$activatedElementsComputed ??= Computed<int>(
          () => super.activatedElements,
          name: '_SingleGroupAware.activatedElements'))
      .value;
  Computed<ObservableList<T>>? _$property_activationsComputed;

  @override
  ObservableList<T> get property_activations =>
      (_$property_activationsComputed ??= Computed<ObservableList<T>>(
              () => super.property_activations,
              name: '_SingleGroupAware.property_activations'))
          .value;

  late final _$groupAtom =
      Atom(name: '_SingleGroupAware.group', context: context);

  @override
  ObservableList<T> get group {
    _$groupAtom.reportRead();
    return super.group;
  }

  @override
  set group(ObservableList<T> value) {
    _$groupAtom.reportWrite(value, super.group, () {
      super.group = value;
    });
  }

  late final _$prevActivatedAtom =
      Atom(name: '_SingleGroupAware.prevActivated', context: context);

  @override
  ObservableList<T> get prevActivated {
    _$prevActivatedAtom.reportRead();
    return super.prevActivated;
  }

  @override
  set prevActivated(ObservableList<T> value) {
    _$prevActivatedAtom.reportWrite(value, super.prevActivated, () {
      super.prevActivated = value;
    });
  }

  late final _$activatedsAtom =
      Atom(name: '_SingleGroupAware.activateds', context: context);

  @override
  ObservableList<T> get activateds {
    _$activatedsAtom.reportRead();
    return super.activateds;
  }

  @override
  set activateds(ObservableList<T> value) {
    _$activatedsAtom.reportWrite(value, super.activateds, () {
      super.activateds = value;
    });
  }

  @override
  String toString() {
    return '''
group: ${group},
prevActivated: ${prevActivated},
activateds: ${activateds},
hasActivatedElements: ${hasActivatedElements},
activatedElements: ${activatedElements},
property_activations: ${property_activations}
    ''';
  }
}

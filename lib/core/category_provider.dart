import 'package:flutter/material.dart';

class CategoryState extends ChangeNotifier {
  String? _selected;
  String? get selected => _selected;

  void setCategory(String name) {
    _selected = name;
    notifyListeners();
  }
}

class CategoryInherited extends InheritedNotifier<CategoryState> {
  const CategoryInherited({
    super.key,
    required CategoryState super.notifier,
    required super.child,
  });

  static CategoryState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CategoryInherited>()!.notifier!;
  }

  @override
  bool updateShouldNotify(covariant InheritedNotifier<CategoryState> old) => true;
}

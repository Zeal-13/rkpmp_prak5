import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/counter_provider.dart';

class CounterDelegate {
  final WidgetRef ref;

  CounterDelegate(this.ref);

  int get currentCount => ref.read(counterProvider);

  void increment() => ref.read(counterProvider.notifier).increment();
  void decrement() => ref.read(counterProvider.notifier).decrement();
  void reset() => ref.read(counterProvider.notifier).reset();
}
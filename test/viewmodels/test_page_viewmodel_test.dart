import 'package:flutter_test/flutter_test.dart';
import 'package:test_blu/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('TestPageViewModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}

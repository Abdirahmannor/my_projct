import 'package:flutter_test/flutter_test.dart';
import '../../lib/core/base/base_constants.dart';

void main() {
  group('BaseConstants Tests', () {
    test('should have correct priority values', () {
      expect(BaseConstants.priorities.containsKey('high'), isTrue);
      expect(BaseConstants.priorities.containsKey('medium'), isTrue);
      expect(BaseConstants.priorities.containsKey('low'), isTrue);
      expect(BaseConstants.priorities['high'], 'red');
      expect(BaseConstants.priorities['medium'], 'orange');
      expect(BaseConstants.priorities['low'], 'green');
    });

    test('should have correct status values', () {
      expect(BaseConstants.statuses.containsKey('not started'), isTrue);
      expect(BaseConstants.statuses.containsKey('in progress'), isTrue);
      expect(BaseConstants.statuses.containsKey('on hold'), isTrue);
      expect(BaseConstants.statuses.containsKey('completed'), isTrue);
      expect(BaseConstants.statuses['not started'], 'grey');
      expect(BaseConstants.statuses['in progress'], 'blue');
      expect(BaseConstants.statuses['completed'], 'green');
    });

    test('should have correct view mode constants', () {
      expect(BaseConstants.listView, 'list');
      expect(BaseConstants.gridView, 'grid');
    });

    test('should have correct filter constants', () {
      expect(BaseConstants.allFilter, 'all');
      expect(BaseConstants.activeFilter, 'active');
      expect(BaseConstants.archivedFilter, 'archived');
      expect(BaseConstants.recycleBinFilter, 'recycle_bin');
    });

    test('should have correct sort constants', () {
      expect(BaseConstants.ascending, 'asc');
      expect(BaseConstants.descending, 'desc');
      expect(BaseConstants.nameSort, 'name');
      expect(BaseConstants.dateSort, 'date');
      expect(BaseConstants.prioritySort, 'priority');
      expect(BaseConstants.statusSort, 'status');
    });

    test('should have correct layout constants', () {
      expect(BaseConstants.defaultPadding, 16.0);
      expect(BaseConstants.defaultSpacing, 8.0);
      expect(BaseConstants.defaultBorderRadius, 8.0);
      expect(BaseConstants.defaultIconSize, 24.0);
    });
  });
}

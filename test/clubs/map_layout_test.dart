import 'package:ace_mobile/features/clubs/data/booking_models.dart';
import 'package:ace_mobile/features/clubs/logic/map_layout.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const size = MapSize(xLen: 20, yLen: 20);
  final zones = [
    const Zone(id: 'd', name: 'default', x: 0, y: 0),
    const Zone(id: 'v', name: 'VIP', x: 4, y: 10, xLen: 3, yLen: 2),
  ];
  final computers = [
    const Computer(id: 'c1', name: '1', state: 'FREE', x: 0, y: 0, zoneId: 'v'),
    const Computer(id: 'c2', name: '2', state: 'IN_USE', x: 2, y: 1, zoneId: 'v'),
    const Computer(id: 'c3', name: '3', state: 'RESERVED', x: 1, y: 5, zoneId: 'd'),
  ];

  test('returns null when nothing is placed', () {
    expect(buildLayout(size, [zones[0]], []), isNull);
  });

  test('places zone box from bottom-left origin', () {
    final layout = buildLayout(size, zones, [])!;
    expect(layout.zones, [const ZoneBox(id: 'v', name: 'VIP', row: 0, col: 0, rows: 2, cols: 3)]);
    expect(layout.minRow, 8);
    expect(layout.minCol, 4);
    expect(layout.rows, 2);
    expect(layout.cols, 3);
  });

  test('keeps map positions and crops grid to used area', () {
    final layout = buildLayout(size, zones, computers)!;
    expect(layout.minRow, 8);
    expect(layout.minCol, 1);
    expect(layout.rows, 7);
    expect(layout.cols, 6);
    expect(layout.computers['1-3']?.id, 'c1');
    expect(layout.computers['0-5']?.id, 'c2');
    expect(layout.computers['6-0']?.id, 'c3');
    expect(layout.zones.first, const ZoneBox(id: 'v', name: 'VIP', row: 0, col: 3, rows: 2, cols: 3));
  });

  test('skips computers outside the grid', () {
    final layout = buildLayout(size, zones, [
      const Computer(id: 'x', name: 'x', state: 'FREE', x: 25, y: 0, zoneId: 'd'),
      computers[2],
    ])!;
    expect(layout.computers.length, 1);
  });

}

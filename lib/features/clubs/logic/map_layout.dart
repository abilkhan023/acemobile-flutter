import '../data/booking_models.dart';

class MapSize {
  const MapSize({required this.xLen, required this.yLen});

  final int xLen;
  final int yLen;
}

class ZoneBox {
  const ZoneBox({required this.id, required this.name, required this.row, required this.col, required this.rows, required this.cols});

  final String id;
  final String name;
  final int row;
  final int col;
  final int rows;
  final int cols;

  ZoneBox shifted(int dRow, int dCol) => ZoneBox(id: id, name: name, row: row - dRow, col: col - dCol, rows: rows, cols: cols);

  @override
  bool operator ==(Object other) =>
      other is ZoneBox && other.id == id && other.name == name && other.row == row && other.col == col && other.rows == rows && other.cols == cols;

  @override
  int get hashCode => Object.hash(id, name, row, col, rows, cols);

  @override
  String toString() => 'ZoneBox($id $name row=$row col=$col rows=$rows cols=$cols)';
}

class MapLayout {
  const MapLayout({required this.minRow, required this.minCol, required this.rows, required this.cols, required this.zones, required this.computers});

  final int minRow;
  final int minCol;
  final int rows;
  final int cols;
  final List<ZoneBox> zones;
  final Map<String, Computer> computers;
}

String cellKey(int row, int col) => '$row-$col';

bool _isDefaultZone(Zone? zone) => zone?.name == 'default';

class _Placed {
  const _Placed(this.computer, this.row, this.col);

  final Computer computer;
  final int row;
  final int col;
}

MapLayout? buildLayout(MapSize size, List<Zone> zones, List<Computer> computers) {
  final boxes = [
    for (final z in zones)
      if (!_isDefaultZone(z) && z.xLen != null && z.yLen != null)
        ZoneBox(
          id: z.id,
          name: z.name ?? '',
          row: size.yLen - (z.y ?? 0).toInt() - z.yLen!.toInt(),
          col: (z.x ?? 0).toInt(),
          rows: z.yLen!.toInt(),
          cols: z.xLen!.toInt(),
        ),
  ];

  final placed = <_Placed>[];
  for (final c in computers) {
    Zone? zone;
    for (final z in zones) {
      if (z.id == c.zoneId) {
        zone = z;
        break;
      }
    }
    final offsetX = zone != null && !_isDefaultZone(zone) ? (zone.x ?? 0).toInt() : 0;
    final offsetY = zone != null && !_isDefaultZone(zone) ? (zone.y ?? 0).toInt() : 0;
    final row = size.yLen - 1 - ((c.y ?? 0).toInt() + offsetY);
    final col = (c.x ?? 0).toInt() + offsetX;
    if (row >= 0 && row < size.yLen && col >= 0 && col < size.xLen) placed.add(_Placed(c, row, col));
  }

  if (boxes.isEmpty && placed.isEmpty) return null;

  var minRow = 1 << 30;
  var maxRow = -(1 << 30);
  var minCol = 1 << 30;
  var maxCol = -(1 << 30);

  for (final b in boxes) {
    if (b.row < minRow) minRow = b.row;
    if (b.row + b.rows - 1 > maxRow) maxRow = b.row + b.rows - 1;
    if (b.col < minCol) minCol = b.col;
    if (b.col + b.cols - 1 > maxCol) maxCol = b.col + b.cols - 1;
  }
  for (final p in placed) {
    if (p.row < minRow) minRow = p.row;
    if (p.row > maxRow) maxRow = p.row;
    if (p.col < minCol) minCol = p.col;
    if (p.col > maxCol) maxCol = p.col;
  }

  minRow = minRow.clamp(0, size.yLen - 1);
  maxRow = maxRow.clamp(0, size.yLen - 1);
  minCol = minCol.clamp(0, size.xLen - 1);
  maxCol = maxCol.clamp(0, size.xLen - 1);

  final computerMap = <String, Computer>{};
  for (final p in placed) {
    computerMap[cellKey(p.row - minRow, p.col - minCol)] = p.computer;
  }

  return MapLayout(
    minRow: minRow,
    minCol: minCol,
    rows: maxRow - minRow + 1,
    cols: maxCol - minCol + 1,
    zones: [for (final b in boxes) b.shifted(minRow, minCol)],
    computers: computerMap,
  );
}

class ZoneLayout {
  const ZoneLayout({required this.id, required this.name, required this.rows, required this.cols, required this.computers});

  final String id;
  final String name;
  final int rows;
  final int cols;
  final Map<String, Computer> computers;
}

ZoneLayout? _cropZone({required String id, required String name, required int height, required Iterable<Computer> computers, required int Function(Computer) rowOf, required int Function(Computer) colOf}) {
  final placed = <(Computer, int, int)>[];
  for (final c in computers) {
    final row = rowOf(c);
    final col = colOf(c);
    if (row < 0 || col < 0) continue;
    placed.add((c, row, col));
  }
  if (placed.isEmpty) return null;
  var minRow = 1 << 30, maxRow = -1, minCol = 1 << 30, maxCol = -1;
  for (final (_, row, col) in placed) {
    if (row < minRow) minRow = row;
    if (row > maxRow) maxRow = row;
    if (col < minCol) minCol = col;
    if (col > maxCol) maxCol = col;
  }
  final map = <String, Computer>{for (final (c, row, col) in placed) cellKey(row - minRow, col - minCol): c};
  return ZoneLayout(id: id, name: name, rows: maxRow - minRow + 1, cols: maxCol - minCol + 1, computers: map);
}

List<ZoneLayout> buildZoneLayouts(MapSize size, List<Zone> zones, List<Computer> computers, {String defaultName = ''}) {
  final result = <ZoneLayout>[];
  final assigned = <String>{};
  for (final z in zones) {
    if (_isDefaultZone(z)) continue;
    final own = computers.where((c) => c.zoneId == z.id).toList();
    for (final c in own) {
      assigned.add(c.id);
    }
    final height = (z.yLen ?? size.yLen).toInt();
    final layout = _cropZone(
      id: z.id,
      name: z.name ?? '',
      height: height,
      computers: own,
      rowOf: (c) => height - 1 - (c.y ?? 0).toInt(),
      colOf: (c) => (c.x ?? 0).toInt(),
    );
    if (layout != null) result.add(layout);
  }
  final rest = computers.where((c) => !assigned.contains(c.id)).toList();
  final restLayout = _cropZone(
    id: 'default',
    name: defaultName,
    height: size.yLen,
    computers: rest,
    rowOf: (c) => size.yLen - 1 - (c.y ?? 0).toInt(),
    colOf: (c) => (c.x ?? 0).toInt(),
  );
  if (restLayout != null) result.add(restLayout);
  return result;
}

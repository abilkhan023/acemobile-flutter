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


class SqlBuilder {
  late String _select;
  final List<String> _where = [];
  final List<Object?> _whereArgs = [];
  String _orderBy = '';
  int? _limit;

  SqlBuilder(String select) {
    _select = select;
  }

  SqlBuilder where(String whereStr, List<Object?> args) {
    if (whereStr.isNotEmpty &&
        args.where((element) => element == null || element.toString().isEmpty).isEmpty) {
      _where.add(whereStr);
      _whereArgs.addAll(args);
    }
    return this;
  }

  SqlBuilder like(String whereStr, List<Object?> args) {
    if (whereStr.isNotEmpty &&
        args.where((element) => element == null || element.toString().isEmpty).isEmpty) {
      _where.add(whereStr);
      _whereArgs.addAll(args.map((e) => "%$e%"));
    }
    return this;
  }

  SqlBuilder orderBy(String column, {bool desc = false}) {
    if (column.isNotEmpty) {
      _orderBy = "ORDER BY $column";
      if (desc) {
        _orderBy += " desc";
      }
    }
    return this;
  }

  SqlBuilder limit(int limit) {
    _limit = limit;
    return this;
  }

  (String, List<Object?>) done() {
    var whereStr = _where.join(" and ");
    if(whereStr.isNotEmpty) {
      whereStr = "where $whereStr";
    }
    if (_orderBy.isNotEmpty) {
      whereStr += " $_orderBy";
    }
    if (_limit != null) {
      whereStr += " limit $_limit";
    }
    return ("$_select $whereStr", _whereArgs);
  }
}

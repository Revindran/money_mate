class IncomeModel {
  final int amount;
  final String category;
  final String type;

  IncomeModel(this.amount, this.category, this.type);

  IncomeModel.fromMap(Map<String, dynamic> map)
      : assert(map['Amount'] != null),
        assert(map['Category'] != null),
        assert(map['Type'] != null),
        amount = map['Amount'],
        category = map['Category'],
        type = map['Type'];

  @override
  String toString() => "Record<$amount:$category:$type>";
}

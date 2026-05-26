import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

double _stringToDouble(dynamic value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

@freezed
class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required int id,
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _stringToDouble) required double amount,
    required String type,
    required String category,
    required String reference,
    required String status,
    String? description,
    Map<String, dynamic>? metadata,
    Map<String, dynamic>? wallet,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) => _$TransactionModelFromJson(json);
}

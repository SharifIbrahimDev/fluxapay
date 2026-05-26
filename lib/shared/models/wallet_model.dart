import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_model.freezed.dart';
part 'wallet_model.g.dart';

double _stringToDouble(dynamic value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

@freezed
class WalletModel with _$WalletModel {
  const factory WalletModel({
    required int id,
    required String currency,
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _stringToDouble) required double balance,
    required String status,
  }) = _WalletModel;

  factory WalletModel.fromJson(Map<String, dynamic> json) => _$WalletModelFromJson(json);
}

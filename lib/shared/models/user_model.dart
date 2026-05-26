import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required int id,
    required String name,
    required String email,
    required String? phone,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'account_number') String? accountNumber,
    @Default(false) @JsonKey(name: 'is_pin_set') bool isPinSet,
    required String status,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}

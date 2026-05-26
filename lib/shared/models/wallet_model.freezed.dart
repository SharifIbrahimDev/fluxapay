// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WalletModel _$WalletModelFromJson(Map<String, dynamic> json) {
  return _WalletModel.fromJson(json);
}

/// @nodoc
mixin _$WalletModel {
  int get id => throw _privateConstructorUsedError;
  String get currency =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(fromJson: _stringToDouble)
  double get balance => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;

  /// Serializes this WalletModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WalletModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WalletModelCopyWith<WalletModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletModelCopyWith<$Res> {
  factory $WalletModelCopyWith(
    WalletModel value,
    $Res Function(WalletModel) then,
  ) = _$WalletModelCopyWithImpl<$Res, WalletModel>;
  @useResult
  $Res call({
    int id,
    String currency,
    @JsonKey(fromJson: _stringToDouble) double balance,
    String status,
  });
}

/// @nodoc
class _$WalletModelCopyWithImpl<$Res, $Val extends WalletModel>
    implements $WalletModelCopyWith<$Res> {
  _$WalletModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WalletModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? currency = null,
    Object? balance = null,
    Object? status = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            balance: null == balance
                ? _value.balance
                : balance // ignore: cast_nullable_to_non_nullable
                      as double,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WalletModelImplCopyWith<$Res>
    implements $WalletModelCopyWith<$Res> {
  factory _$$WalletModelImplCopyWith(
    _$WalletModelImpl value,
    $Res Function(_$WalletModelImpl) then,
  ) = __$$WalletModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String currency,
    @JsonKey(fromJson: _stringToDouble) double balance,
    String status,
  });
}

/// @nodoc
class __$$WalletModelImplCopyWithImpl<$Res>
    extends _$WalletModelCopyWithImpl<$Res, _$WalletModelImpl>
    implements _$$WalletModelImplCopyWith<$Res> {
  __$$WalletModelImplCopyWithImpl(
    _$WalletModelImpl _value,
    $Res Function(_$WalletModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WalletModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? currency = null,
    Object? balance = null,
    Object? status = null,
  }) {
    return _then(
      _$WalletModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        balance: null == balance
            ? _value.balance
            : balance // ignore: cast_nullable_to_non_nullable
                  as double,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WalletModelImpl implements _WalletModel {
  const _$WalletModelImpl({
    required this.id,
    required this.currency,
    @JsonKey(fromJson: _stringToDouble) required this.balance,
    required this.status,
  });

  factory _$WalletModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WalletModelImplFromJson(json);

  @override
  final int id;
  @override
  final String currency;
  // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _stringToDouble)
  final double balance;
  @override
  final String status;

  @override
  String toString() {
    return 'WalletModel(id: $id, currency: $currency, balance: $balance, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, currency, balance, status);

  /// Create a copy of WalletModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletModelImplCopyWith<_$WalletModelImpl> get copyWith =>
      __$$WalletModelImplCopyWithImpl<_$WalletModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WalletModelImplToJson(this);
  }
}

abstract class _WalletModel implements WalletModel {
  const factory _WalletModel({
    required final int id,
    required final String currency,
    @JsonKey(fromJson: _stringToDouble) required final double balance,
    required final String status,
  }) = _$WalletModelImpl;

  factory _WalletModel.fromJson(Map<String, dynamic> json) =
      _$WalletModelImpl.fromJson;

  @override
  int get id;
  @override
  String get currency; // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _stringToDouble)
  double get balance;
  @override
  String get status;

  /// Create a copy of WalletModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WalletModelImplCopyWith<_$WalletModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

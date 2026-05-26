// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) {
  return _TransactionModel.fromJson(json);
}

/// @nodoc
mixin _$TransactionModel {
  int get id =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(fromJson: _stringToDouble)
  double get amount => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get reference => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  Map<String, dynamic>? get wallet =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this TransactionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionModelCopyWith<TransactionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionModelCopyWith<$Res> {
  factory $TransactionModelCopyWith(
    TransactionModel value,
    $Res Function(TransactionModel) then,
  ) = _$TransactionModelCopyWithImpl<$Res, TransactionModel>;
  @useResult
  $Res call({
    int id,
    @JsonKey(fromJson: _stringToDouble) double amount,
    String type,
    String category,
    String reference,
    String status,
    String? description,
    Map<String, dynamic>? metadata,
    Map<String, dynamic>? wallet,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class _$TransactionModelCopyWithImpl<$Res, $Val extends TransactionModel>
    implements $TransactionModelCopyWith<$Res> {
  _$TransactionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amount = null,
    Object? type = null,
    Object? category = null,
    Object? reference = null,
    Object? status = null,
    Object? description = freezed,
    Object? metadata = freezed,
    Object? wallet = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            reference: null == reference
                ? _value.reference
                : reference // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            metadata: freezed == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            wallet: freezed == wallet
                ? _value.wallet
                : wallet // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransactionModelImplCopyWith<$Res>
    implements $TransactionModelCopyWith<$Res> {
  factory _$$TransactionModelImplCopyWith(
    _$TransactionModelImpl value,
    $Res Function(_$TransactionModelImpl) then,
  ) = __$$TransactionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(fromJson: _stringToDouble) double amount,
    String type,
    String category,
    String reference,
    String status,
    String? description,
    Map<String, dynamic>? metadata,
    Map<String, dynamic>? wallet,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class __$$TransactionModelImplCopyWithImpl<$Res>
    extends _$TransactionModelCopyWithImpl<$Res, _$TransactionModelImpl>
    implements _$$TransactionModelImplCopyWith<$Res> {
  __$$TransactionModelImplCopyWithImpl(
    _$TransactionModelImpl _value,
    $Res Function(_$TransactionModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amount = null,
    Object? type = null,
    Object? category = null,
    Object? reference = null,
    Object? status = null,
    Object? description = freezed,
    Object? metadata = freezed,
    Object? wallet = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$TransactionModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        reference: null == reference
            ? _value.reference
            : reference // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        metadata: freezed == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        wallet: freezed == wallet
            ? _value._wallet
            : wallet // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionModelImpl implements _TransactionModel {
  const _$TransactionModelImpl({
    required this.id,
    @JsonKey(fromJson: _stringToDouble) required this.amount,
    required this.type,
    required this.category,
    required this.reference,
    required this.status,
    this.description,
    final Map<String, dynamic>? metadata,
    final Map<String, dynamic>? wallet,
    @JsonKey(name: 'created_at') required this.createdAt,
  }) : _metadata = metadata,
       _wallet = wallet;

  factory _$TransactionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionModelImplFromJson(json);

  @override
  final int id;
  // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _stringToDouble)
  final double amount;
  @override
  final String type;
  @override
  final String category;
  @override
  final String reference;
  @override
  final String status;
  @override
  final String? description;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _wallet;
  @override
  Map<String, dynamic>? get wallet {
    final value = _wallet;
    if (value == null) return null;
    if (_wallet is EqualUnmodifiableMapView) return _wallet;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'TransactionModel(id: $id, amount: $amount, type: $type, category: $category, reference: $reference, status: $status, description: $description, metadata: $metadata, wallet: $wallet, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            const DeepCollectionEquality().equals(other._wallet, _wallet) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    amount,
    type,
    category,
    reference,
    status,
    description,
    const DeepCollectionEquality().hash(_metadata),
    const DeepCollectionEquality().hash(_wallet),
    createdAt,
  );

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionModelImplCopyWith<_$TransactionModelImpl> get copyWith =>
      __$$TransactionModelImplCopyWithImpl<_$TransactionModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionModelImplToJson(this);
  }
}

abstract class _TransactionModel implements TransactionModel {
  const factory _TransactionModel({
    required final int id,
    @JsonKey(fromJson: _stringToDouble) required final double amount,
    required final String type,
    required final String category,
    required final String reference,
    required final String status,
    final String? description,
    final Map<String, dynamic>? metadata,
    final Map<String, dynamic>? wallet,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
  }) = _$TransactionModelImpl;

  factory _TransactionModel.fromJson(Map<String, dynamic> json) =
      _$TransactionModelImpl.fromJson;

  @override
  int get id; // ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _stringToDouble)
  double get amount;
  @override
  String get type;
  @override
  String get category;
  @override
  String get reference;
  @override
  String get status;
  @override
  String? get description;
  @override
  Map<String, dynamic>? get metadata;
  @override
  Map<String, dynamic>? get wallet; // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionModelImplCopyWith<_$TransactionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionModelImpl _$$TransactionModelImplFromJson(
  Map<String, dynamic> json,
) => _$TransactionModelImpl(
  id: (json['id'] as num).toInt(),
  amount: _stringToDouble(json['amount']),
  type: json['type'] as String,
  category: json['category'] as String,
  reference: json['reference'] as String,
  status: json['status'] as String,
  description: json['description'] as String?,
  metadata: json['metadata'] as Map<String, dynamic>?,
  wallet: json['wallet'] as Map<String, dynamic>?,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$$TransactionModelImplToJson(
  _$TransactionModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'amount': instance.amount,
  'type': instance.type,
  'category': instance.category,
  'reference': instance.reference,
  'status': instance.status,
  'description': instance.description,
  'metadata': instance.metadata,
  'wallet': instance.wallet,
  'created_at': instance.createdAt.toIso8601String(),
};

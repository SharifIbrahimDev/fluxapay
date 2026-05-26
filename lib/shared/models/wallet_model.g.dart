// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletModelImpl _$$WalletModelImplFromJson(Map<String, dynamic> json) =>
    _$WalletModelImpl(
      id: (json['id'] as num).toInt(),
      currency: json['currency'] as String,
      balance: _stringToDouble(json['balance']),
      status: json['status'] as String,
    );

Map<String, dynamic> _$$WalletModelImplToJson(_$WalletModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'currency': instance.currency,
      'balance': instance.balance,
      'status': instance.status,
    };

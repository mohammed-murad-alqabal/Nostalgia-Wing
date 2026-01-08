// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_template.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageTemplateAdapter extends TypeAdapter<MessageTemplate> {
  @override
  final int typeId = 4;

  @override
  MessageTemplate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageTemplate(
      id: fields[0] as String,
      type: fields[1] as String,
      content: fields[2] as String,
      intensity: fields[3] as double,
      tags: (fields[4] as List).cast<String>(),
      createdAt: fields[5] as DateTime?,
      lastUsedAt: fields[6] as DateTime?,
      usageCount: fields[7] as int,
      isFavorite: fields[8] as bool,
      userRating: fields[9] as double?,
      notes: fields[10] as String?,
      resonanceThreshold: fields[11] as double,
      optimalStability: fields[12] as double,
    );
  }

  @override
  void write(BinaryWriter writer, MessageTemplate obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.intensity)
      ..writeByte(4)
      ..write(obj.tags)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.lastUsedAt)
      ..writeByte(7)
      ..write(obj.usageCount)
      ..writeByte(8)
      ..write(obj.isFavorite)
      ..writeByte(9)
      ..write(obj.userRating)
      ..writeByte(10)
      ..write(obj.notes)
      ..writeByte(11)
      ..write(obj.resonanceThreshold)
      ..writeByte(12)
      ..write(obj.optimalStability);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageTemplateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

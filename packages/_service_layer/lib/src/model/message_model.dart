import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

@freezed
class MessageModel with _$MessageModel {
  const factory MessageModel({
    @Default(0) statusCode,
    @Default(PersonModel()) PersonModel sender,
    @Default(PersonModel()) PersonModel receiver,
    @Default(ContentModel()) ContentModel message,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}

@freezed
class PersonModel with _$PersonModel {
  const factory PersonModel({
    @Default('') String uuid,
    @Default('') String name,
  }) = _PersonModel;

  factory PersonModel.fromJson(Map<String, dynamic> json) =>
      _$PersonModelFromJson(json);
}

@freezed
class ContentModel with _$ContentModel {
  const factory ContentModel({
    @Default('') String title,
    @Default('') String text,
  }) = _ContentModel;

  factory ContentModel.fromJson(Map<String, dynamic> json) =>
      _$ContentModelFromJson(json);
}

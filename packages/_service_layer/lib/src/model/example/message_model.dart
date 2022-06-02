import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

/// Message Service Model.
///
/// Freezed class with Message service info.
/// Provides conversion from service JSON to this service Model.
@freezed
class MessageModel with _$MessageModel {
  /// Freezed factory constructor.
  const factory MessageModel({
    @Default(0) statusCode,
    @Default(PersonModel()) PersonModel sender,
    @Default(PersonModel()) PersonModel receiver,
    @Default(ContentModel()) ContentModel message,
  }) = _MessageModel;

  /// JSON factory constructor.
  factory MessageModel.fromJson(Map<String, dynamic> json) => _$MessageModelFromJson(json);
}

/// Person Service Model.
///
/// Freezed class with Person service info.
/// Provides conversion from service JSON to this service Model.
@freezed
class PersonModel with _$PersonModel {
  /// Freezed factory constructor.
  const factory PersonModel({
    @Default('') String uuid,
    @Default('') String name,
  }) = _PersonModel;

  /// JSON factory constructor.
  factory PersonModel.fromJson(Map<String, dynamic> json) => _$PersonModelFromJson(json);
}

/// Content Service Model.
///
/// Freezed class with Content service info.
/// Provides conversion from service JSON to this service Model.
@freezed
class ContentModel with _$ContentModel {
  /// Freezed factory constructor.
  const factory ContentModel({
    @Default('') String title,
    @Default('') String text,
  }) = _ContentModel;

  /// JSON factory constructor.
  factory ContentModel.fromJson(Map<String, dynamic> json) => _$ContentModelFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'whats_happening_model.freezed.dart';
part 'whats_happening_model.g.dart';

/// Otherthing service model.
///
/// Has a constructor for a serializion (JSON) map.
@freezed
class WhatsHappeningModel with _$WhatsHappeningModel {
  /// Freezed factory.
  const factory WhatsHappeningModel({
    required String text,
  }) = _OtherthingModel;

  /// Constructor from a serialization (JSON) map.
  factory WhatsHappeningModel.fromJson(Map<String, dynamic> json) => _$WhatsHappeningModelFromJson(json);
}

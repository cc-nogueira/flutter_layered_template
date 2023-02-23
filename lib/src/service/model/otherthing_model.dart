import 'package:freezed_annotation/freezed_annotation.dart';

part 'otherthing_model.freezed.dart';
part 'otherthing_model.g.dart';

/// Otherthing service model.
///
/// Has a constructor for a serializion (JSON) map.
@freezed
class OtherthingModel with _$OtherthingModel {
  /// Freezed factory.
  const factory OtherthingModel({
    required String text,
  }) = _OtherthingModel;

  /// Constructor from a serialization (JSON) map.
  factory OtherthingModel.fromJson(Map<String, dynamic> json) => _$OtherthingModelFromJson(json);
}

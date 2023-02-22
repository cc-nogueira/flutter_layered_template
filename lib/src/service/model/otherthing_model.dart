import 'package:freezed_annotation/freezed_annotation.dart';

part 'otherthing_model.freezed.dart';
part 'otherthing_model.g.dart';

@freezed
class OtherthingModel with _$OtherthingModel {
  const factory OtherthingModel({
    required String text,
  }) = _OtherthingModel;

  factory OtherthingModel.fromJson(Map<String, dynamic> json) => _$OtherthingModelFromJson(json);
}

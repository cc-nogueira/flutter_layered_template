/// Domain Layer exports.
///
/// Exposes domain types:
///   - Entities (immutable state modeling objects).
///   - Exceptions (domain exceptions).
///   - AppLayer base implementation of a Layer object.
///   - Use cases defining business rules. These are the common gateway API to
///     These use cases often expose state Notifiers that are observed by the UILayer.
///     These use cases contains business rules and access repositories, services and change app internal state.
///
/// And interfaces and types for implementation provisioning:
///   - DomainLayer class for provisioning specifications.
///   - Resitory interfaces to be provisioned by the DataLayer (optional).
///   - Service interfaces to be provisioned by the ServiceLayer (optional).

export 'domain/entity/entity_mapper.dart';
export 'domain/entity/thing.dart';
export 'domain/entity/whats_happening.dart';
export 'domain/exception/entity_not_found_exception.dart';
export 'domain/exception/service_exception.dart';
export 'domain/exception/validation_exception.dart';
export 'domain/layer/app_layer.dart';
export 'domain/layer/domain_layer.dart';
export 'domain/repository/things_repository.dart';
export 'domain/service/whats_happening_service.dart';
export 'domain/usecase/things_use_case.dart';
export 'domain/usecase/whats_happening_use_case.dart';

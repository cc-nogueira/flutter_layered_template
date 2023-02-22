/// Domain Layer exports:
///
/// Exposes domain types:
///   - Entities (immutable state modeling objects).
///   - Exceptions (domain exceptions).
///   - AppLayer base implementation of a Layer object.
///   - Use cases defining business rules. These are the common gateway API to
///     These use cases often expose StateNotifiers that are observed by the PresentationLayer.
///     These use cases contains business rules and access repositories, services and change app internal state.
///
/// And interfaces and types for implementation provisioning:
///   - DomainLayer class for provisioning specifications.
///   - Resitory interfaces to be provisioned by the DataLayer (optional).
///   - Service interfaces to be provisioned by the ServiceLayer (optional).

export 'domain/entity/contact.dart';
export 'domain/exception/entity_not_found_exception.dart';
export 'domain/layer/app_layer.dart';
export 'domain/layer/domain_layer.dart';
export 'domain/repository/contacts_async_repository.dart';
export 'domain/repository/contacts_sync_repository.dart';
export 'domain/usecase/contacts_async_use_case.dart';
export 'domain/usecase/contacts_sync_use_case.dart';

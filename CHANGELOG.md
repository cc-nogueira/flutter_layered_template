## [0.0.2] - 2022-03-18

### Hidding usecase injected dependencies in private instance variables.
> Important to protect injected implementations of repositories and prevent direct access to storage.  
> Maintaining a reference to the repository in the DomainLayer object itself, but cast to its StateNotifier subtype,
> allowing riverpod to watch state changes in the repository without full access to its API (it is the repository
> object by accessed by its Notifier subtype.


## [0.0.1] - 2022-03-14

### Template for Flutter Layered Architecture - Version 0.0.1
> Defined **Layered Architecture Structure** with **each layer in an internal package**:
>   - **Core** (Basic interfaces and utilities)
>   - **Domain Layer** (Business Entities and Business Rules)
>   - **Data Layer** (Persistence)
>   - **Service Layer** (External services)
>   - **Presentation Layer** (UI)  
>   - **DI Layer** (Dependency Injection)

> **Layered Implementation** using **Riverpod Providers** and **Freezed** libraries:
>   - Per layer exports to define public/private members for each layer
>   - Each layer has a AppLayer Object to coordinate inter-layer interactions
>   - Using Riverpod for layer instantiation and initialization
>   - Using Riverpod for layer configuration with Dependency Inversion
>   - Using Riverpod to expose layer implementations
>   - Using Freezed classes for Entities

> **main() implementation to provide global injection scope and initialize all layers**:
>   - Wrap the whole application in Riverpod ProviderScope
>   - Use a FutureProvider to:
>     - Async initialize the DI Layer (which initialize and configure all other layers)
>     - Create main App widget after initialization

> **Example Usecase Implementation**
>   - Domain entities, Domain exceptions, Domain repository interfaces, Domain usecases
>   - Data repository implementation
>   - Dependency Inversion (also Dependency Injection) via AppLayer instances and providers

> **Common Code** extracted to correct locations
>   - Common code in Core folder
>   - Common pages in /lib/presentation/common/page
>   - Named routes configuration and implementation

> **Testing Domain Usecase**
>   - Testing Domain Usecase business rules with Mockito

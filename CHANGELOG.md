## [0.1.0] - 2023-02-06
> Refactore the whole structure to use a single project.
> DomainLayer runtime dependencies expressed as Provisions classes.
> Dependencies upgrates (riverpod 2.1.3)
> Use of riverpod_annotations.

## [0.0.5] - 2022-06-01
> Flutter updated to 3.0 and Dart to 2.17.  
> Configuring internationalization.  
>  
> - Using DART 2.17 new super arguments.
> - Using lint 2.0.1.
> - Using Flutter l10n for internationalization with ARB files.


## [0.0.4] - 2022-04-05
Fix clean command in project.dart that would not run without building.  
Add --org parameter to project.dart

## [0.0.3] - 2022-03-22

### Placing example files in example subfolders. Adding Stream API abstract classes and interfaces in Domain Layer.
> Refactored the whole structure to move example specific files into new example subfolders.  
> This way when reusing this template you will find example app files separated from generic files.  
> These generic will either be reused as is (abstract classes, interfaces) or will be edited (providers, exports).  
> While example files will probably be deleted after serving their role as examples.  
> Added abstract stream API usecase and stream API repository interface to domain layer.  


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

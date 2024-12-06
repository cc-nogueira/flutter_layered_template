# A Flutter **Layered Architecture** template.

This is an implementation of the architecture described in [**4+2 Layered Architecture**](https://medium.com/@nogueira.cc/4-2-layered-architecture-313329082989) and it's companion publication **Layered Architecture - A Flutter Implementation**. 

> **Layered Architecture**:
> - Defines AppLayer, DomainLayer and ProvisioningLayer classes.
> - Provides the project structure with all suggested layers (Domain, Data, Service, UI and main).
> - Implements a simple domain in a runnable sample application.
> - Also includes an example folder with more complext UI and two Persistence implementations (Synchronous and Async).
  
> **Main project dependencies**:
> - [Flutter Riverpod](https://pub.dev/packages/flutter_riverpod)
> - [Freezed](https://pub.dev/packages/freezed)
>
> **Also using **:
> - [GoRouter](https://pub.dev/packages/go_router)
> - [Isar](https://pub.dev/packages/isar)
> - [Quiver](https://pub.dev/packages/quiver)
> - And others (annotations for code generation, build_runner, and more).

---

## Architecture overview:

<img align="right" src="https://raw.githubusercontent.com/cc-nogueira/flutter_layered_template/media/Layered_Architecture_380x420.png?raw=true" alt="Project Structure" style="padding-left: 20px">

The [*4+2 Layered Architecture*](https://medium.com/@nogueira.cc/4-2-layered-architecture-313329082989) describes the importance of ***Separation of Concerns*** in software development. All concepts highlighted in that proposal are present in the ***Flutter*** implementation.  

Dependency provisioning is concentrated in **main.dart** as this file is in the outer application scope, with full code visibility. It is responsible to initialize all layers
and orchestrate layer dependencies provisioning.

- 4 Layers:
  - **Domain Layer** (business rules)
  - **Data Layer** (persistence)
  - **Service Layer** (external services)
  - **UI Layer** (presentation)
>
- Outer Layer:
  - **main** (dependency provisioning coordination and App start up).
>

---

## Layer objects
A key component in this template is the use of Layer objects to structure layer relations. Layer objects can be of three types: **AppLayer**, **DomainLayer** and **ProvisioningLayer**.  

Once more, the driving force behind the use of these layer objects is *Separation of Concerns*: no layer needs to know about the internals of any other layer. Outer layers can only see **static types** defined in inner layers and
the *Domain Layer* is *provisioned at runtime* with implementations of required interfaces.

---

## Project structure:

<img align="right" src="https://raw.githubusercontent.com/cc-nogueira/flutter_layered_template/media/Project_Structure.png?raw=true" alt="Project Structure">

All code is separated in layers, each layer organized as a separate internal package.  
This separation of concerns makes inter layer dependencies explicity and tests modular.  

The main project structure, shown in the following image, has:
* flutter project files: **pubspec.yaml**, **build****, etc
* **lib** folder with main.dart
* **packages** folder containing all layers:
  * _data_layer
  * _di_layer
  * _domain_layer
  * _service_layer
  * _ui_layer
* **test** folder for main project

Each layer folder has its own package structure with:
* **pubspec.yaml**
* **test** folder for that layer

Main project and outer layers pubspec.yaml use path dependencies to
refer to inner layers, for example, in **_domain_layer**'s pubspec you see:

``` yaml
dependencies:
  _core_layer:
    path: ../_core_layer
```

In this structure image I show my VSCode Explorer using **MultiRoot** feature (aka **Workspace files**) setting each layer as a root folder.  
I use this *MultiRoot* feature combined with [Explorer Exclude extension](https://marketplace.visualstudio.com/items?itemName=RedVanWorkshop.explorer-exclude-vscode-extension) to have a focused view for my projects.

The image shows just the ***Domain Layer*** open for exemplification. 

Besides these files shown in the image there are a number of configuration files for flutter, VSCode, GIT and others. Since we are working with 6 extra internal packages we get a lot of these configuration files and code navigation on VSCode explorer becomes very clumsy. Thus the suggestion to use this ***Explorer Exclude*** extension.

Below my configuration for ***MuiltiRoot*** and ***Explorer Exclude*** worspace. This configuration is provided in this template at **.vscode/layered_template.code-workspace** file:
``` json
{
  "folders": [
    { "path": ".." },
    { "path": "../packages/data", "name": "Data Layer" },
    { "path": "../packages/domain", "name": "Domain Layer" },
    { "path": "../packages/service", "name": "Service Layer" },
    { "path": "../packages/ui", "name": "UI Layer" }
  ],
  "settings": {
    "files.exclude": {
      "**/.git": true,
      "**/.svn": true,
      "**/.hg": true,
      "**/CVS": true,
      "**/.DS_Store": true,
      "**/Thumbs.db": true,
      "**/.dart_tool": true,
      "**/.idea": true,
      "**/.vscode": true,
      "**/*.iml": true,
      "**/.metadata": true,
      "**/.packages": true,
      "**/CHANGELOG.md": true,
      "**/LICENSE": true,
      "**/README.md": true,
      "**/analysis_options.yaml": true,
      "**/pubspec.lock": true,
      ".code-workspace": true,
      ".flutter-plugins": true,
      ".flutter-plugins-dependencies": true,
      ".gitignore": true,
      "android": true,
      "build": true,
      "packages": true
    },
    "explorerExclude.backup": null
  }
}
```

---

## The sample domain:
This template defines a simple domain model with "in memory" temporary persistence.  
Persistence is implemented using a StateNotifier to keep entities and notify storage state changes.  
The purpose is not to implement a full featured application, but rather to provide a
simple application with full layered architecture structure.

---

## Using this template for a new Flutter project:
This a start up template for a layered architecture project. 
1. Click on **Use this template** on this template main page in github:

   https://github.com/cc-nogueira/flutter_layered_template/

2. **Clone your repository** to your development machine:
```bash
   git clone https://github.com/your-repo/your-project.git
```

3. **Change name in pubspec.yaml**
```yaml
   name: your-project
```

4. **Run** the provided utility **project.dart** that initializes the main project
and all layer packages, creating configuration files that not stored in git (project
and build files).  

```bash
   cd <your-project>
   dart project.dart init
```

5. **Open Workspace from File** 

```
   Rename workspace file from .vscode/layered_template.code-workspace to <your-project>.code-workspace
   Open VSCode
   Choose "Open Workspace from File...: from the File menu
   Select <your-project>/.vscode/<your-project>.code-workspace
```

This provided **project.dart** utility has commands to init, clean and build
the project and its internal packages.  
You can always run commands in a specific package folfer using the terminal,
for example you can run build_runner to generate json or freezed files in the
domain layer folder. But when you want to run build_runner or clean for all layers
you better running dart project.dart with the specific command.

---

## References:

Publications:
- ***[4+2 Layered Architecture](https://medium.com/@nogueira.cc/4-2-layered-architecture-313329082989)*** (english)
- ***4+2 Layered Architecture - A Flutter Implementation***

Videos:
- ***4+2 Layered Architecture - Flutter Implementatioh*** (english)
- ***[Flutter: Arquitetura 4+2 em Camadas](https://odysee.com/@Flutter:8/Flutter_Arquitetura_4+2:2)*** (portuguese)

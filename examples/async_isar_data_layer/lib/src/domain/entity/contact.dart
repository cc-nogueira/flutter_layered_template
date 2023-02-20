import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact.freezed.dart';

/// Contact entity.
///
/// Immutable class with contact properties.
@freezed
class Contact with _$Contact {
  /// Freezed factory.
  const factory Contact({
    int? id,
    @Default('') String uuid,
    required String name,
    @Default('') String about,
  }) = _Contact;
}

const personalities = [
  Contact(
    id: 0,
    name: 'Trygve Reenskaug',
    uuid: 'c6d85b7c-8f77-4447-9f80-2ae4ab061f20',
    about: 'Creator of the "Inversion of Control" mechanism. The "Inversion of Control" mechanism using injected '
        'implementations was first used by Trygve Reenkaug when he designed the MVC architecture for Smalltalk in '
        '1978 at Xerox PARC. It was then extensively used in the Smalltak-80 language and environment.',
  ),
  Contact(
    id: 1,
    name: 'Robert Martin',
    uuid: '6381eb68-e200-490c-a227-cb64648f2a23',
    about: 'In about 1994 Robert Martin (Uncle Bob) used the expression "Dependency Inversion Principle. Later '
        'in 2012, Bob Martin presents the original "Clean Architecture" proposal picturing layers with software '
        'engineering concepts from Ivar Jacobson, Steve Freeman and other. He states that all these previous architectures '
        'share the same objective: "Separation of Concerns".',
  ),
  Contact(
    id: 2,
    name: 'Martin Fowler',
    uuid: 'b7525456-ce67-4df0-8760-9c4f5d76cac7',
    about: 'In 2004 Fowler coined the term "Dependency Injection" when writing about Inversion of Control Containers '
        'such as PicoContainer and Spring Container.',
  ),
  Contact(
      id: 3,
      name: 'Gilad Bracha',
      uuid: '8ad5b6ca-8b37-489a-a95f-11a1f8cdd110',
      about: 'Bracha is the creator of the Newspeak programming language and previously co-authored the '
          'Java Language Specification. Before that he worked with Strongtalk and Smalltalk language design. '
          'Gilad became part of Dart specification group at Google and worked with innovative features such as '
          'Optional Types, Generics, Checked mode and the Dart VM.'),
];

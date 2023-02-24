import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entity/contact.dart';
import '../../../common/helper/hero_flight_shuttle_builder.dart';
import '../../../common/helper/text_form_field_mixin.dart';
import '../../../common/helper/text_input_formatters.dart';
import '../../../l10n/translations.dart';

class ContactNameAndAboutEditor extends ConsumerWidget {
  const ContactNameAndAboutEditor(this.editionProvider, {super.key, required this.original});

  final StateProvider<Contact> editionProvider;

  final Contact original;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _ContactNameAndAboutEditor(ref.read(editionProvider.notifier), original: original);
  }
}

class _ContactNameAndAboutEditor extends StatefulWidget {
  const _ContactNameAndAboutEditor(this.editionController, {required this.original});

  final StateController<Contact> editionController;

  final Contact original;

  @override
  State<_ContactNameAndAboutEditor> createState() => __ContactNameAndAboutEditorState();
}

class __ContactNameAndAboutEditorState extends State<_ContactNameAndAboutEditor>
    with TextFormFieldMixin, TextInputKeyFormatter {
  final nameController = TextEditingController();
  final aboutController = TextEditingController();
  late bool isPersonality;

  @override
  void initState() {
    super.initState();
    _resetState();
  }

  @override
  void didUpdateWidget(covariant _ContactNameAndAboutEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    _resetState();
  }

  void _resetState() {
    final contact = widget.editionController.state;
    nameController.text = contact.name;
    aboutController.text = contact.about;
    isPersonality = contact.isPersonality;
  }

  @override
  Widget build(BuildContext context) {
    final tr = Translations.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textField(
            context: context,
            label: Hero(
              tag: 'contact_type',
              flightShuttleBuilder: heroDefaultStyleFlightShuttleBuilder(Theme.of(context).textTheme.bodySmall!),
              child: Text(widget.original.isPersonality ? tr.personality_title : tr.name_title),
            ),
            controller: nameController,
            originalText: widget.original.name,
            readOnly: isPersonality,
            onChanged: _onNameChanged,
            onTap: isPersonality ? () => _alertReadOnly(context) : null,
          ),
          const SizedBox(height: 20),
          textField(
            context: context,
            labelText: tr.about_title,
            // hintText:
            controller: aboutController,
            originalText: widget.original.about,
            readOnly: isPersonality,
            onChanged: _onAboutChanged,
            onTap: isPersonality ? () => _alertReadOnly(context) : null,
          ),
        ],
      ),
    );
  }

  void _alertReadOnly(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        const SnackBar(
          content: Text('This contact is a famous personality whose name and description are not editable.'),
          showCloseIcon: true,
        ),
      );
  }

  void _onNameChanged(String value) => widget.editionController.update((state) => state.copyWith(name: value));

  void _onAboutChanged(String value) => widget.editionController.update((state) => state.copyWith(about: value));
}

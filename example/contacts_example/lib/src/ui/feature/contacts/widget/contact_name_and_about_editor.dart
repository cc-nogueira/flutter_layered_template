import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entity/contact.dart';
import '../../../l10n/translations.dart';

class ContactNameAndAboutEditor extends ConsumerWidget {
  const ContactNameAndAboutEditor(this.editionProvider, {super.key});

  final StateProvider<Contact> editionProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _ContactNameAndAboutEditor(ref.read(editionProvider.notifier));
  }
}

class _ContactNameAndAboutEditor extends StatefulWidget {
  const _ContactNameAndAboutEditor(this.editionController);

  final StateController<Contact> editionController;

  @override
  State<_ContactNameAndAboutEditor> createState() => __ContactNameAndAboutEditorState();
}

class __ContactNameAndAboutEditorState extends State<_ContactNameAndAboutEditor> {
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
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isPersonality)
            Text(
              tr.personality_title,
              style: textTheme.bodyLarge?.copyWith(color: colors.tertiary, fontWeight: FontWeight.bold),
            ),
          TextFormField(
            controller: nameController,
            readOnly: isPersonality,
            onTap: isPersonality ? () => _alertReadOnly(context) : null,
          ),
          TextFormField(
            controller: aboutController,
            maxLines: null,
            readOnly: isPersonality,
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
}

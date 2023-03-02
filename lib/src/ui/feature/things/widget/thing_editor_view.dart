import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain.dart';
import '../../../common/mixin/text_form_field_mixin.dart';
import '../../../l10n/translations.dart';

class ThingEditor extends StatefulWidget {
  const ThingEditor(this.editionController, {super.key, required this.original});

  final StateController<Thing> editionController;

  final Thing original;

  @override
  State<ThingEditor> createState() => _ThingEditorState();
}

class _ThingEditorState extends State<ThingEditor> with TextFormFieldMixin {
  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _resetState();
  }

  @override
  void didUpdateWidget(covariant ThingEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    _resetState();
  }

  void _resetState() {
    final contact = widget.editionController.state;
    nameController.text = contact.name;
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
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
            labelText: tr.name_title,
            controller: nameController,
            originalText: widget.original.name,
            validator: (value) => _validateName(value, tr: tr),
            onChanged: _onNameChanged,
          ),
        ],
      ),
    );
  }

  /// By updating the controller inside a setState we also update the textField decoration.
  void _onNameChanged(String value) => setState(() {
        widget.editionController.update((state) => state.copyWith(name: value));
      });

  String? _validateName(String? value, {required Translations tr}) {
    if (value == null || value.isEmpty) {
      return '* ${tr.required_message}';
    }
    return null;
  }
}

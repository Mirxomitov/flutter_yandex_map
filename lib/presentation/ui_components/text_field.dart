import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String hintText;
  final TextEditingController fieldController;
  final String defValue;
  final TextInputType inputType;

  const TextFieldWidget({
    super.key,
    required this.hintText,
    required this.fieldController,
    this.defValue = '',
    this.inputType = TextInputType.name,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: fieldController,
      keyboardType: inputType,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hintText,
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => fieldController.clear(),
        ),
        suffixIconColor: Colors.grey,
      ),
    );
  }
}

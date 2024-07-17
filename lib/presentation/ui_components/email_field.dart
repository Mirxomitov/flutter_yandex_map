import 'package:flutter/material.dart';

class EmailField extends StatefulWidget {
  final TextEditingController fieldController;

  const EmailField({super.key, required this.fieldController});

  @override
  EmailFieldState createState() => EmailFieldState();
}

class EmailFieldState extends State<EmailField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.fieldController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: 'Email',
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => widget.fieldController.clear(),
        ),
        suffixIconColor: Colors.grey,
      ),
    );
  }
}
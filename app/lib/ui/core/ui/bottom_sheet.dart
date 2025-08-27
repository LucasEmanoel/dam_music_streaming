import 'package:flutter/material.dart';

class CustomActionSheet extends StatelessWidget {
  final Widget? titleContent; // Mude para opcional
  final List<Widget> actions;

  const CustomActionSheet({
    super.key,
    this.titleContent, // Mude para opcional
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Adiciona o título e o espaço somente se titleContent não for nulo
          if (titleContent != null) ...[
            titleContent!,
            const SizedBox(height: 20),
          ],
          ...actions,
        ],
      ),
    );
  }
}
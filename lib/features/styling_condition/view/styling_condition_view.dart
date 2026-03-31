import 'package:flutter/material.dart';
import 'package:fit_mate_client/features/styling_condition/widget/styling_condition_placeholder_section.dart';

class StylingConditionView extends StatelessWidget {
  const StylingConditionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Styling Condition')),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: StylingConditionPlaceholderSection(),
      ),
    );
  }
}

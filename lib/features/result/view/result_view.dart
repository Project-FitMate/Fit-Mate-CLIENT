import 'package:flutter/material.dart';
import 'package:fit_mate_client/features/result/widget/result_placeholder_section.dart';

class ResultView extends StatelessWidget {
  const ResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Result')),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: ResultPlaceholderSection(),
      ),
    );
  }
}

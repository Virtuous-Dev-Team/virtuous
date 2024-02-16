import 'package:flutter/cupertino.dart';

class VirtueEntry extends StatelessWidget {
  const VirtueEntry(
      {super.key,
      required this.quadrantName,
      required this.definition,
      required this.color});
  final String? quadrantName;
  final String? definition;
  final String? color;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Text(quadrantName!), Text(definition!)],
    );
  }
}

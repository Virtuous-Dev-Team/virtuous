import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';


class LegalDialog extends StatelessWidget {
  LegalDialog({
    Key? key,
    this.radius = 8,
    required this.mdFileName,
  }) : assert(mdFileName.contains('.md'), 'The file extension must be .md'),
      super(key: key);

  final double radius;
  final String mdFileName;


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: Future.delayed(Duration(milliseconds: 150)).then((value) {
                return rootBundle.loadString('assets/markdown/$mdFileName');
              }), 
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  return Markdown(
                    data: snapshot.data!, //null check
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(radius),
                  bottomRight: Radius.circular(radius),
                ) 
              ),
              height: 50,
              width: double.infinity,
              alignment: Alignment.center,
              child: const Text(
                "CLOSE", 
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ]
      ),
    );
  }
}
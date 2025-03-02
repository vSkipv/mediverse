import 'package:flutter/material.dart';

import 'constants.dart';
import 'features/MainScreen/presentaion/views/MainScreen_view.dart';

void main() {
  runApp(mediverse());
}

class mediverse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
    );
  }
}

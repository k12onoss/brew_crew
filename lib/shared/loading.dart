import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.brown[100],
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.pink,
        ),
      ),
    );
  }
}

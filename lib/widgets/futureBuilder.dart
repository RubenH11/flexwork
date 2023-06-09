import 'package:flutter/material.dart';

class FlexworkFutureBuilder<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(T snapshot) builder;
  const FlexworkFutureBuilder(
      {super.key, required this.future, required this.builder});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: ((context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        if (!snapshot.hasData) {
          // print(snapshot.data);
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        // print(snapshot.data);

        return builder(snapshot.data!);
      }),
    );
  }
}

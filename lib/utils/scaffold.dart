import 'package:flutter/material.dart';

void presentScaffold(BuildContext context, String message,
    {ScaffoldState state = ScaffoldState.error, SnackBarAction? action}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: state == ScaffoldState.error
          ? Colors.red
          : state == ScaffoldState.undertermined
              ? Colors.black
              : Colors.green,
      action: action,
      content: Text(
        message,
        style: Theme.of(context).textTheme.headline6!.copyWith(
              color: Colors.white,
              fontSize: 16,
            ),
      ),
    ),
  );
}

enum ScaffoldState { error, success, undertermined }

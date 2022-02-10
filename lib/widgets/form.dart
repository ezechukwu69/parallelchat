import 'package:flutter/material.dart';

class CustomForm extends StatefulWidget {
  final Widget child;
  const CustomForm({Key? key, required this.child}) : super(key: key);

  @override
  CustomFormState createState() => CustomFormState();

  static CustomFormState? of(BuildContext context) {
    var ctx = context.dependOnInheritedWidgetOfExactType<CustomFormScope>();
    return ctx?.formState;
  }
}

class CustomFormState extends State<CustomForm> {
  final Set<dynamic> textfields = <dynamic>{};

  void register(dynamic state) {
    textfields.add(state);
  }

  void unregister(dynamic state) {
    textfields.remove(state);
  }

  bool validate() {
    bool isValid = true;
    for (var i in textfields) {
      if (i.validate() == false) {
        isValid = false;
      }
    }
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return CustomFormScope(child: widget.child, formState: this);
  }
}

class CustomFormScope extends InheritedWidget {
  final CustomFormState formState;
  const CustomFormScope(
      {Key? key, required Widget child, required this.formState})
      : super(child: child, key: key);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}

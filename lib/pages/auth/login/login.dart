import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parallelchat/constants/constants.dart';
import 'package:parallelchat/extensions/string.dart';
import 'package:parallelchat/pages/auth/login/cubit/login_cubit.dart';
import 'package:parallelchat/pages/home/home.dart';
import 'package:parallelchat/utils/scaffold.dart' as scaffold;
import 'package:parallelchat/widgets/auth_container.dart';
import 'package:parallelchat/widgets/button.dart';
import 'package:parallelchat/widgets/form.dart';
import 'package:parallelchat/widgets/textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController email = TextEditingController();

  final TextEditingController password = TextEditingController();

  final GlobalKey<CustomTextFieldState> passwordKey =
      GlobalKey<CustomTextFieldState>();

  final GlobalKey<CustomFormState> formKey = GlobalKey<CustomFormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        body: AuthContainer(
          canPop: true,
          title: "Login",
          description:
              "Login to experience premium chat feature and connect with friends",
          children: [
            CustomForm(
              key: formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: email,
                    label: "Email",
                    hint: "johnDoe@email.com",
                    color: const Color(IColors.textFieldGray),
                    validate: (v) {
                      if (v.isEmpty) {
                        return "Enter email";
                      }
                      if (!v.isValidEmail) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    controller: password,
                    key: passwordKey,
                    obscured: true,
                    hint: "Password",
                    label: "Password",
                    color: const Color(IColors.textFieldGray),
                    validate: (v) {
                      if (v.length < 6) {
                        return "Password must be atleast 6 charactes long";
                      }
                      return null;
                    },
                    suffix: CustomTextFieldItem(
                      child: Text("Hide",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(decoration: TextDecoration.underline)),
                      onTap: () {
                        passwordKey.currentState?.toggleObscuredState();
                      },
                    ),
                    obscuredSuffix: CustomTextFieldItem(
                        child: Text("Show",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    decoration: TextDecoration.underline)),
                        onTap: () {
                          passwordKey.currentState?.toggleObscuredState();
                        }),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Text(
                          "Sign Up",
                          style:
                              TextStyle(decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<LoginCubit, LoginState>(
                    builder: (context, state) {
                      return CustomButton(
                        loading: state.loading,
                        title: "Login",
                        color: Theme.of(context).primaryColor,
                        onTap: () {
                          if (formKey.currentState?.validate() == true) {
                            context
                                .read<LoginCubit>()
                                .login(email.text.trim(), password.text.trim(),
                                    onError: (v) {
                              scaffold.presentScaffold(context, v,
                                  state: scaffold.ScaffoldState.error);
                            }, onSuccess: (v) {
                              scaffold.presentScaffold(context, v,
                                  state: scaffold.ScaffoldState.success);
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                builder: (context) {
                                  return const HomePage();
                                },
                              ), (route) => false);
                            });
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

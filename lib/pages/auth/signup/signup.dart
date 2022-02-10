import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parallelchat/constants/constants.dart';
import 'package:parallelchat/extensions/string.dart';
import 'package:parallelchat/pages/auth/login/login.dart';
import 'package:parallelchat/pages/auth/signup/cubit/signup_cubit.dart';
import 'package:parallelchat/pages/home/home.dart';
import 'package:parallelchat/utils/scaffold.dart' as scaffold;
import 'package:parallelchat/widgets/auth_container.dart';
import 'package:parallelchat/widgets/button.dart';
import 'package:parallelchat/widgets/form.dart';
import 'package:parallelchat/widgets/textfield.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController email = TextEditingController();

  final TextEditingController password = TextEditingController();

  final TextEditingController confirmPassword = TextEditingController();

  final GlobalKey<CustomTextFieldState> passwordKey =
      GlobalKey<CustomTextFieldState>();

  final GlobalKey<CustomTextFieldState> confirmPasswordKey =
      GlobalKey<CustomTextFieldState>();

  final GlobalKey<CustomFormState> formKey = GlobalKey<CustomFormState>();

  void validateFields() {
    passwordKey.currentState?.validate();
    confirmPasswordKey.currentState?.validate();
  }

  @override
  void initState() {
    super.initState();
    password.addListener(validateFields);
    confirmPassword.addListener(validateFields);
  }

  @override
  void dispose() {
    password.removeListener(validateFields);
    password.dispose();
    confirmPassword.removeListener(validateFields);
    confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(),
      child: Scaffold(
        body: AuthContainer(
          canPop: false,
          title: "Sign Up",
          description:
              "Sign Up to experience premium chat feature and connect with friends",
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
                      if (v != confirmPassword.text) {
                        return "Passwords do not match";
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
                  const SizedBox(height: 24),
                  CustomTextField(
                    controller: confirmPassword,
                    key: confirmPasswordKey,
                    obscured: true,
                    hint: "Confirm Password",
                    label: "Confirm Password",
                    color: const Color(IColors.textFieldGray),
                    validate: (v) {
                      if (v != password.text) {
                        return "Passwords do not match";
                      }
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
                        confirmPasswordKey.currentState?.toggleObscuredState();
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
                          confirmPasswordKey.currentState
                              ?.toggleObscuredState();
                        }),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return const LoginPage();
                            },
                          ));
                        },
                        child: const Text(
                          "Login",
                          style:
                              TextStyle(decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<SignupCubit, SignupState>(
                    builder: (context, state) {
                      return CustomButton(
                        loading: state.loading,
                        title: "Sign Up",
                        color: Theme.of(context).primaryColor,
                        onTap: () {
                          if (formKey.currentState?.validate() == true) {
                            context
                                .read<SignupCubit>()
                                .signup(email.text.trim(), password.text.trim(),
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parallelchat/constants/constants.dart';

class AuthContainer extends StatelessWidget {
  final String title;
  final String description;
  final bool? canPop;
  final List<Widget> children;
  const AuthContainer(
      {Key? key,
      required this.title,
      required this.description,
      this.canPop,
      required this.children})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Spacer(
              //   flex: 1,
              // ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
              ),
              if (canPop == true) ...{
                GestureDetector(
                  child: const Icon(CupertinoIcons.chevron_left),
                  onTap: () => Navigator.of(context).pop(),
                ),
                const SizedBox(height: 40)
              },
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: Text(
                  description,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        fontSize: 14,
                        color: const Color(IColors.textLightBlack),
                      ),
                ),
              ),
              const SizedBox(height: 32),
              SingleChildScrollView(
                child: Column(
                  children: [...children],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

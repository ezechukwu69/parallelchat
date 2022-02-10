import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parallelchat/constants/constants.dart';
import 'package:parallelchat/pages/auth/signup/signup.dart';
import 'package:parallelchat/pages/chat/chat.dart';
import 'package:parallelchat/pages/home/cubit/home_cubit.dart';
import 'package:parallelchat/utils/scaffold.dart';
import 'package:parallelchat/widgets/newchat_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "ParallelChat",
            style: TextStyle(),
          ),
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Logout?"),
                        actions: [
                          TextButton(
                              onPressed: () async {
                                try {
                                  await FirebaseAuth.instance.signOut();
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SignUpPage(),
                                      ),
                                      (route) => false);
                                } catch (e) {
                                  presentScaffold(context, "Unable to logout");
                                }
                              },
                              child: const Text("Yes")),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "No",
                                style: TextStyle(color: Colors.redAccent),
                              )),
                        ],
                      );
                    },
                    useRootNavigator: false);
              },
              icon: const Icon(Icons.power_settings_new_outlined),
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  return ListView.builder(
                    itemBuilder: (context, i) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color(IColors.textFieldGray),
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              child: Icon(Icons.person_outline),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) {
                                      return ChatPage(
                                        chatID: state.chats[i].id,
                                        email: getOtherPersonsName(state
                                            .chats[i]
                                            .data()["participants"]),
                                      );
                                    },
                                  ));
                                },
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      getOtherPersonsName(state.chats[i]
                                          .data()["participants"]),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 8),
                                    if (state.chats[i].data()['lastMessage'] !=
                                        null) ...{
                                      Text(
                                        state.chats[i].data()["lastMessage"],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.9),
                                            fontWeight: FontWeight.w400),
                                      ),
                                    }
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: state.chats.length,
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Map<dynamic, dynamic>? data = await showDialog(
                context: context,
                useRootNavigator: false,
                builder: (context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: const NewChatDialog(),
                  );
                });

            if (data != null) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return ChatPage(
                    chatID: data['chatID'],
                    email: data['email'],
                  );
                },
              ));
            }
          },
          child: const Icon(Icons.edit_outlined),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}

String getOtherPersonsName(List<dynamic> data) {
  return data
      .where((element) =>
          element['email'] != FirebaseAuth.instance.currentUser!.email)
      .first['email'];
}

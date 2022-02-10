import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parallelchat/constants/constants.dart';
import 'package:parallelchat/pages/chat/cubit/chat_cubit.dart';
import 'package:parallelchat/widgets/textfield.dart';

class ChatPage extends StatefulWidget {
  final String chatID;
  final String email;
  const ChatPage({Key? key, required this.chatID, required this.email})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool canSend = false;
  final TextEditingController controller = TextEditingController();

  void checkCanSend() {
    if (controller.text.isEmpty) {
      setState(() {
        canSend = false;
      });
    } else {
      setState(() {
        canSend = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(checkCanSend);
  }

  @override
  void dispose() {
    controller.removeListener(checkCanSend);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit(widget.chatID),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            widget.email,
            style: const TextStyle(),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 12),
            Expanded(
              child: BlocConsumer<ChatCubit, ChatState>(
                listener: (context, state) async {
                  WriteBatch batch = FirebaseFirestore.instance.batch();
                  for (var e in state.messages) {
                    if (e.data()["owner"] !=
                            FirebaseAuth.instance.currentUser!.uid &&
                        e.data()["read"] != true) {
                      batch.update(e.reference, {
                        "read": true,
                      });
                    }
                  }
                  batch.commit();
                },
                builder: (context, state) {
                  return NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification.metrics.maxScrollExtent -
                              notification.metrics.pixels <
                          50) {
                        context.read<ChatCubit>().loadNext();
                      }
                      return true;
                    },
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      reverse: true,
                      padding: const EdgeInsets.only(top: 50),
                      itemBuilder: (context, i) {
                        return Row(
                          mainAxisAlignment:
                              state.messages[i].data()["owner"] ==
                                      FirebaseAuth.instance.currentUser!.uid
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: state.messages[i].data()["owner"] ==
                                      FirebaseAuth.instance.currentUser!.uid
                                  ? MediaQuery.of(context).size.width * 0.4
                                  : 12,
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(
                                    top: 12, bottom: 12, left: 8, right: 12),
                                decoration: BoxDecoration(
                                  color: state.messages[i].data()["owner"] ==
                                          FirebaseAuth.instance.currentUser!.uid
                                      ? Colors.indigo
                                      : Colors.teal.shade900,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        state.messages[i].data()["message"],
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    if (state.messages[i].data()["owner"] ==
                                        FirebaseAuth
                                            .instance.currentUser!.uid) ...{
                                      Icon(
                                        Icons.check,
                                        color: state.messages[i].data()['read']
                                            ? Colors.green
                                            : Colors.white,
                                      )
                                    }
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: state.messages[i].data()["owner"] !=
                                      FirebaseAuth.instance.currentUser!.uid
                                  ? MediaQuery.of(context).size.width * 0.4
                                  : 12,
                            )
                          ],
                        );
                      },
                      itemCount: state.messages.length,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            SafeArea(
              child: Row(
                children: [
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: CustomTextField(
                      controller: controller,
                      color: const Color(IColors.textFieldGray),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Builder(builder: (context) {
                    return GestureDetector(
                      onTap: () {
                        context.read<ChatCubit>().send(controller.text.trim(),
                            () {
                          controller.clear();
                        });
                      },
                      child: Icon(
                        Icons.send,
                        color: canSend
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                    );
                  }),
                  const SizedBox(
                    width: 12,
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

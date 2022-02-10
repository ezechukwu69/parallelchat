import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parallelchat/constants/constants.dart';
import 'package:parallelchat/utils/generators.dart';
import 'package:parallelchat/utils/scaffold.dart';
import 'package:parallelchat/widgets/button.dart';
import 'package:parallelchat/widgets/textfield.dart';

class NewChatDialog extends StatefulWidget {
  const NewChatDialog({Key? key}) : super(key: key);

  @override
  State<NewChatDialog> createState() => _NewChatDialogState();
}

class _NewChatDialogState extends State<NewChatDialog> {
  final TextEditingController controller = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        children: [
          const SizedBox(
            height: 12,
          ),
          const Text(
            "New Chat",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: CustomTextField(
              controller: controller,
              hint: "johndoe@gmial.com",
              color: const Color(IColors.textFieldGray),
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomButton(
                width: 140,
                color: Theme.of(context).primaryColor,
                title: "Search",
                type: ButtonType.search,
                loading: loading,
                onTap: () async {
                  setState(() {
                    loading = true;
                  });
                  var firebaseInstance = FirebaseFirestore.instance;
                  var currentUser = FirebaseAuth.instance.currentUser;
                  if (currentUser == null) {
                    return;
                  }
                  Query<Map<String, dynamic>> query = firebaseInstance
                      .collection("users")
                      .where("email", isEqualTo: controller.text.trim());
                  var data = await query.get();
                  if (data.docs.isNotEmpty) {
                    if (data.docs.first.data()["email"] == currentUser.email) {
                      presentScaffold(context,
                          "Cannot initiate an appointment with your self");
                      setState(() {
                        loading = false;
                      });
                      return;
                    }
                    var ref = firebaseInstance.collection("chats").doc(
                        generateChatID(currentUser.uid, data.docs.first.id));
                    var reference = await ref.get();
                    if (reference.exists) {
                      Navigator.of(context).pop({
                        "chatID": reference.id,
                        "email": controller.text.trim()
                      });
                    } else {
                      ref.set({
                        "participants": [
                          {
                            "userID": currentUser.uid,
                            "email": currentUser.email
                          },
                          {
                            "userID": data.docs.first.id,
                            "email": controller.text.trim()
                          }
                        ],
                        "updatedAt": Timestamp.now(),
                        "createdAt": Timestamp.now(),
                        "lastMessage": null
                      });
                      Navigator.of(context).pop({
                        "chatID":
                            generateChatID(currentUser.uid, data.docs.first.id),
                        "email": controller.text.trim()
                      });
                    }
                  } else {
                    presentScaffold(context, "User Does not exist");
                  }
                  setState(() {
                    loading = false;
                  });
                },
              ),
              const SizedBox(
                width: 12,
              )
            ],
          ),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }
}

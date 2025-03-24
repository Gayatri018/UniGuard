import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {

  ChatUser user = ChatUser(
    id: "1",
    firstName: "User",
    profileImage: "assets/images/user.png",
  );

  ChatUser bot = ChatUser(
    id: "2",
    firstName: "Bot",
    profileImage: "assets/images/user.png",
  );

  getData(ChatMessage m)async {
    _typing.add(bot);
    messages.insert(0, m);
    setState(() {});
    await Future.delayed(const Duration(seconds: 2));

    ChatMessage data = ChatMessage(
        text: "Demo text",
        user: user,
        createdAt: DateTime.now()
    );

    messages.insert(0, data);
    _typing.remove(bot);
    setState(() {});
  }

  List<ChatMessage> messages = <ChatMessage>[];
  List<ChatUser> _typing = <ChatUser>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chatbot"),
      ),
      body: DashChat(
        typingUsers: _typing,
        currentUser: user,
        messages: messages,
        onSend: (ChatMessage message) {
          getData(message);
        },
        inputOptions: InputOptions(
          alwaysShowSend: true,
          cursorStyle: CursorStyle(color: Colors.black)
        ),
        messageOptions: MessageOptions(
          currentUserContainerColor: Colors.black,
        ),
      ),
    );
  }
}

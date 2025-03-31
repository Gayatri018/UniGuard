import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {

  @override
  void initState() {

    super.initState();
  }

  ChatUser user = ChatUser(
    id: "1",
    firstName: "User",
    profileImage: "Icon(icons.person)",
  );

  ChatUser bot = ChatUser(
    id: "2",
    firstName: "Gemini",
    profileImage: "assets/images/gemini.png",
  );

  getData(ChatMessage m)async {

    final url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${dotenv.env["API_KEY"]}" ;
    final header = {
      'Content-Type' : 'application/json'
    };

    var data = {
      "contents": [{
        "parts":[{"text": m.text}]
      }]
    };

    _typing.add(bot);
    messages.insert(0, m);
    setState(() {});
    await http.post(Uri.parse(url), headers: header, body: jsonEncode(data))
        .then((value) {
          if(value.statusCode==200) {
            var result = jsonDecode(value.body);

            ChatMessage m1 = ChatMessage(
                text: result["candidates"][0]['content']['parts'][0]['text'],
                user: bot,
                createdAt: DateTime.now()
            );

            messages.insert(0, m1);

          } else {
            print("error");
          }
    })
        .catchError(( e ) {});

    _typing.remove(bot);
    setState(() {});
  }

  List<ChatMessage> messages = <ChatMessage>[];
  List<ChatUser> _typing = <ChatUser>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF8D0E02),
        title: const Text("Chatbot"),
        foregroundColor: Colors.white,
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
          cursorStyle: CursorStyle(color: Color(0xFF8D0E02))
        ),
        messageOptions: MessageOptions(
          showCurrentUserAvatar: false,

          currentUserTextColor: Colors.white,
          currentUserContainerColor: Color(0xFF8D0E02),
        ),

      ),
    );
  }
}

import 'package:flutter/material.dart';

class GiverChatPage extends StatefulWidget {
  const GiverChatPage({super.key});

  @override
  State<GiverChatPage> createState() => _GiverChatPageState();
}

class _GiverChatPageState extends State<GiverChatPage> {

  final TextEditingController messageController =
      TextEditingController();

  List<Map<String, dynamic>> messages = [

    {
      "text":
          "Aldi's Burger Cempaka Putih rotinya lembut dagingnya juicy lucu feast hihihi mahal ini rizky teblis bisa pesen online",
      "isMe": false,
    },

    {
      "text": "Maksudnya apa ya bang saya bingung",
      "isMe": true,
    },

    {
      "text":
          "Semua manusia di muka bumi ini bingung. Mbak. Nanti gak bingung kalau udah di surga",
      "isMe": false,
    },
  ];

  void sendMessage() {

    if (messageController.text.trim().isEmpty) {
      return;
    }

    setState(() {

      messages.add({
        "text": messageController.text,
        "isMe": true,
      });

    });

    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },

          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),

        title: const Row(
          children: [

            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.orange,

              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),

            SizedBox(width: 10),

            Text(
              "Aldi (Aldi's Burger)",

              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),

      body: Center(
        child: Container(
          width: 390,
          color: Colors.white,

          child: Column(
            children: [

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),

                  itemCount: messages.length,

                  itemBuilder: (context, index) {

                    final message = messages[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),

                      child: Align(
                        alignment: message["isMe"]
                            ? Alignment.centerRight
                            : Alignment.centerLeft,

                        child: Container(
                          padding: const EdgeInsets.all(12),

                          decoration: BoxDecoration(
                            color: message["isMe"]
                                ? Colors.green
                                : Colors.orange,

                            borderRadius:
                                BorderRadius.circular(14),
                          ),

                          child: Text(
                            message["text"],

                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),

                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                ),

                child: Row(
                  children: [

                    Expanded(
                      child: TextField(
                        controller: messageController,

                        decoration: InputDecoration(
                          hintText: "Type message...",
                          filled: true,
                          fillColor: Colors.white,

                          contentPadding:
                              const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),

                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(30),

                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    CircleAvatar(
                      backgroundColor: Colors.green,

                      child: IconButton(
                        onPressed: sendMessage,

                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
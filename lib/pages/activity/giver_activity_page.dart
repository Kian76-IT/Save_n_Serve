import 'package:flutter/material.dart';
import 'giver_chat_page.dart';
import '../../home_page.dart';

class GiverActivityPage extends StatelessWidget {
  const GiverActivityPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          "Activity",

          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Center(
        child: Container(
          width: 390,
          color: Colors.white,

          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  // TAB
                  Row(
                    children: [

                      const Text(
                        "Done",

                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(width: 16),

                      Column(
                        children: [

                          const Text(
                            "On Process",

                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            height: 2,
                            width: 60,
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // MAP IMAGE
                  Container(
                    height: 220,
                    width: double.infinity,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey.shade300,
                    ),

                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),

                      child: Image.asset(
                        "assets/images/activity1.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ROLE
                  Row(
                    children: [

                      Container(
                        width: 10,
                        height: 10,

                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                      ),

                      const SizedBox(width: 8),

                      const Text(
                        "Role : ",

                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),

                      const Text(
                        "Giver",

                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    "Pick Up Location :",

                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "KFC, Jl. Pajajaran No.65",

                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Pick Up Time remaining",

                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 32),

                  const Center(
                    child: Text(
                      "20:60",

                      style: TextStyle(
                        fontSize: 48,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // BUTTONS
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,

                    children: [

                      CircleAvatar(
                        radius: 28,

                        backgroundColor:
                            Colors.green.withOpacity(0.15),

                        child: const Icon(
                          Icons.call,
                          color: Colors.green,
                        ),
                      ),

                      GestureDetector(
                        onTap: () {

                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (_) =>
                                  const GiverChatPage(),
                            ),
                          );
                        },

                        child: CircleAvatar(
                          radius: 28,

                          backgroundColor:
                              Colors.green.withOpacity(0.15),

                          child: const Icon(
                            Icons.chat,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(

        currentIndex: 2,

        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,

        onTap: (index) {

          // HOME
          if (index == 0) {

            Navigator.push(
              context,

              MaterialPageRoute(
                builder: (_) => HomeTab(),
              ),
            );
          }

          // WATCHLIST
          if (index == 1) {

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Watchlist page belum dibuat"),
              ),
            );
          }

          // PROFILE
          if (index == 3) {

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Profile page belum dibuat"),
              ),
            );
          }
        },

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: "Watchlist",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: "Activity",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
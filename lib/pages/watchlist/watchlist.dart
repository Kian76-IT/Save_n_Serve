import 'package:flutter/material.dart';
import 'package:save_n_serve/models/food_item.dart';
import 'package:save_n_serve/pages/watchlist/watchlist_card.dart';
import 'package:save_n_serve/components/empty/empty_state.dart';
import 'package:save_n_serve/controllers/food_controller.dart';

class Watchlist extends StatelessWidget {
  const Watchlist({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Watchlist",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: ListenableBuilder(
        listenable: foodController,

        builder: (context, child) {
          return foodController.isWatchlistEmpty()
              ? const EmptyState(
                  imagePath: 'assets/images/whoopies1.png',
                  title: 'Whoopsie!',
                  subtitle: "You don't have any items yet",
                  buttonColor: Colors.orange,
                )
              : Padding(
                  padding: const EdgeInsets.all(16),

                  child: ListView.builder(
                    itemCount: foodController.watchlistFoods.length,

                    itemBuilder: (context, index) {
                      final food = foodController.watchlistFoods[index];

                      return WatchlistCard(food: food);
                    },
                  ),
                );
        },
      ),
    );
  }
}

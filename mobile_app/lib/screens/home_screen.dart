import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Mystery Munch'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Find a random restaurant!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Search Bar with Filter Section
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search restaurants...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Colors.amber,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8), // Space between search bar and button
            IconButton(
              icon: const Icon(Icons.filter_list_alt),
              onPressed: () {
                // TODO: Implement filter functionality
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to Random Picker Screen
              },
              child: const Text('Pick a Restaurant!'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add Action Here
        },
        backgroundColor: Colors.grey,
        child: Icon(
          Icons.navigation_rounded,
          color: Colors.blue,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

}

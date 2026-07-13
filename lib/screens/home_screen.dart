import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../widgets/note_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final firestore = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🌸 My Cute Notes"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [

            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Title",
                prefixIcon: const Icon(Icons.title),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Description",
                prefixIcon: const Icon(Icons.description),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                icon: const Icon(Icons.add),
                label: const Text(
                  "Add Note",
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () async {

                  if (titleController.text.isEmpty ||
                      descriptionController.text.isEmpty) {
                    return;
                  }

                  await firestore.addNote(
                    titleController.text,
                    descriptionController.text,
                  );

                  titleController.clear();
                  descriptionController.clear();
                },
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: StreamBuilder(
                stream: firestore.getNotes(),
                builder: (context, snapshot) {

                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final notes = snapshot.data!;

                  if (notes.isEmpty) {
                    return const Center(
                      child: Text(
                        "✨ No notes yet!\nAdd your first note.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: NoteCard(note: notes[index]),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
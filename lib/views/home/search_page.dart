import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Search for Users'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter username',
              ),
              onChanged: (value) {
                setState(() {
                  username = value;
                });
              },
            ),
          ),

          ///
          if (username != null)
            Expanded(
              child: FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .where('username', isEqualTo: username)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('An error occurred'),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('No User Found'),
                      );
                    }

                    return ListView.builder(
                        itemCount: snapshot.data?.docs.length ?? 0,
                        itemBuilder: (context, index) {
                          final doc = snapshot.data!.docs[index];
                          return ListTile(
                            title: Text(doc['username']),
                            trailing: FutureBuilder<DocumentSnapshot>(
                                future: doc.reference
                                    .collection('followers')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return const Text('Error');
                                  }
                                  if (snapshot.hasData &&
                                      snapshot.data!.exists) {
                                    return ElevatedButton(
                                      onPressed: () async {
                                        await doc.reference
                                            .collection('followers')
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .delete();
                                        setState(() {});
                                      },
                                      child: const Text(
                                        ' Un Follow',
                                      ),
                                    );
                                  }
                                  return ElevatedButton(
                                    onPressed: () async {
                                      await doc.reference
                                          .collection('followers')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .set({
                                        'time': DateTime.now(),
                                      });
                                      setState(() {});
                                    },
                                    child: const Text(
                                      'Follow',
                                    ),
                                  );
                                }),
                          );
                        });
                  }),
            ),
        ],
      ),
    );
  }
}

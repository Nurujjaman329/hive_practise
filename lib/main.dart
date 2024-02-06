import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textController = TextEditingController();
  final String _offlineDataBoxName = 'offlineData';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offline Firebase Sync'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(labelText: 'Enter data'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                // Save data offline
                await saveOfflineData(_textController.text);

                // Sync data with Firebase
                await syncDataWithFirebase();

                // Clear the text field
                _textController.clear();
              },
              child: Text('Save and Sync'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveOfflineData(String data) async {
    // Use Hive or any other local storage to save data offline
    final Box<String> offlineDataBox =
        await Hive.openBox<String>(_offlineDataBoxName);
    offlineDataBox.add(data);
  }

  Future<void> syncDataWithFirebase() async {
    try {
      // Check if the device is online
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        // No internet connection
        print('Offline: Data saved locally');
        return;
      }

      // If online, sync data with Firebase
      final Box<String> offlineDataBox =
          await Hive.openBox<String>(_offlineDataBoxName);
      for (int i = 0; i < offlineDataBox.length; i++) {
        String data = offlineDataBox.getAt(i) ?? '';
        await FirebaseFirestore.instance.collection('offline_collection').add({
          'data': data,
          'timestamp': FieldValue.serverTimestamp(),
        });
        print('Synced: $data');
      }

      // Clear offline data after syncing
      offlineDataBox.clear();
    } catch (e) {
      print('Error syncing data with Firebase: $e');
    }
  }
}


















//import 'package:flutter/material.dart';
//import 'package:hive_flutter/hive_flutter.dart';

//import 'models/person.dart';
//import 'screens/info_screens.dart';

//main() async {
//  // Initialize hive
//  await Hive.initFlutter();
//  // Registering the adapter
//  Hive.registerAdapter(PersonAdapter());
//  // Opening the box
//  await Hive.openBox('peopleBox');
//  runApp(MyApp());
//}

//class MyApp extends StatefulWidget {
//  @override
//  _MyAppState createState() => _MyAppState();
//}

//class _MyAppState extends State<MyApp> {
//  @override
//  void dispose() {
//    // Closes all Hive boxes
//    Hive.close();
//    super.dispose();
//  }

//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Hive Demo',
//      theme: ThemeData(
//        primarySwatch: Colors.purple,
//      ),
//      debugShowCheckedModeBanner: false,
//      home: InfoScreen(),
//    );
//  }
//}

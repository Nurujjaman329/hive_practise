//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:connectivity_plus/connectivity_plus.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:flutter/material.dart';
//import 'package:hive_flutter/hive_flutter.dart';

//void main() async {
//  WidgetsFlutterBinding.ensureInitialized();
//  await Firebase.initializeApp();
//  await Hive.initFlutter();
//  runApp(MyApp());
//}

//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      home: MyHomePage(),
//    );
//  }
//}

//class MyHomePage extends StatefulWidget {
//  @override
//  _MyHomePageState createState() => _MyHomePageState();
//}

//class _MyHomePageState extends State<MyHomePage> {
//  final TextEditingController _textController = TextEditingController();
//  final String _offlineDataBoxName = 'offlineData';

//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('Offline Firebase Sync'),
//      ),
//      body: Padding(
//        padding: const EdgeInsets.all(16.0),
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: [
//            TextField(
//              controller: _textController,
//              decoration: InputDecoration(labelText: 'Enter data'),
//            ),
//            SizedBox(height: 16.0),
//            ElevatedButton(
//              onPressed: () async {
//                // Save data offline
//                await saveOfflineData(_textController.text);

//                // Sync data with Firebase
//                await syncDataWithFirebase();

//                // Clear the text field
//                _textController.clear();
//              },
//              child: Text('Save and Sync'),
//            ),
//          ],
//        ),
//      ),
//    );
//  }

//  Future<void> saveOfflineData(String data) async {
//    // Use Hive or any other local storage to save data offline
//    final Box<String> offlineDataBox =
//        await Hive.openBox<String>(_offlineDataBoxName);
//    offlineDataBox.add(data);
//  }

//  Future<void> syncDataWithFirebase() async {
//    try {
//      // Check if the device is online
//      var connectivityResult = await Connectivity().checkConnectivity();
//      if (connectivityResult == ConnectivityResult.none) {
//        // No internet connection
//        print('Offline: Data saved locally');
//        return;
//      }

//      // If online, sync data with Firebase
//      final Box<String> offlineDataBox =
//          await Hive.openBox<String>(_offlineDataBoxName);
//      for (int i = 0; i < offlineDataBox.length; i++) {
//        String data = offlineDataBox.getAt(i) ?? '';
//        await FirebaseFirestore.instance.collection('your_collection').add({
//          'data': data,
//          'timestamp': FieldValue.serverTimestamp(),
//        });
//        print('Synced: $data');
//      }

//      // Clear offline data after syncing
//      offlineDataBox.clear();
//    } catch (e) {
//      print('Error syncing data with Firebase: $e');
//    }
//  }
//}

//import 'dart:async';

//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:connectivity_plus/connectivity_plus.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:flutter/material.dart';
//import 'package:hive_flutter/hive_flutter.dart';

//void main() async {
//  WidgetsFlutterBinding.ensureInitialized();
//  await Firebase.initializeApp();
//  await Hive.initFlutter();

//  runApp(
//    MyApp(),
//  );
//}

//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      debugShowCheckedModeBanner: false,
//      home: StreamBuilder<ConnectivityResult>(
//        stream: Connectivity().onConnectivityChanged,
//        initialData: ConnectivityResult.none,
//        builder: (context, snapshot) {
//          var connectivityResult = snapshot.data;
//          return MyHomePage(connectivityResult != ConnectivityResult.none);
//        },
//      ),
//    );
//  }
//}

//class MyHomePage extends StatefulWidget {
//  final bool isOnline;

//  MyHomePage(this.isOnline);

//  @override
//  _MyHomePageState createState() => _MyHomePageState();
//}

//class _MyHomePageState extends State<MyHomePage> {
//  final TextEditingController _textController = TextEditingController();
//  final String _offlineDataBoxName = 'offlineData';

//  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

//  @override
//  void initState() {
//    super.initState();

//    _connectivitySubscription =
//        Connectivity().onConnectivityChanged.listen((result) {
//      if (result != ConnectivityResult.none) {
//        syncDataWithFirebase();
//      }
//    });
//  }

//  @override
//  void dispose() {
//    _connectivitySubscription.cancel();
//    super.dispose();
//  }

//  Future<void> saveOfflineData(String data) async {
//    final Box<String> offlineDataBox =
//        await Hive.openBox<String>(_offlineDataBoxName);
//    offlineDataBox.add(data);
//  }

//  Future<void> syncDataWithFirebase() async {
//    try {
//      var connectivityResult = await Connectivity().checkConnectivity();
//      if (connectivityResult == ConnectivityResult.none) {
//        return;
//      }

//      final Box<String> offlineDataBox =
//          await Hive.openBox<String>(_offlineDataBoxName);
//      for (int i = 0; i < offlineDataBox.length; i++) {
//        String data = offlineDataBox.getAt(i) ?? '';
//        await FirebaseFirestore.instance.collection('offline_collection').add({
//          'data': data,
//          'timestamp': FieldValue.serverTimestamp(),
//        });
//        print('Synced: $data');
//      }

//      offlineDataBox.clear();
//    } catch (e) {
//      print('Error syncing data with Firebase: $e');
//    }
//  }

//  Future<void> submitData() async {
//    if (widget.isOnline) {
//      await saveOfflineData(_textController.text);
//      _textController.clear();
//      syncDataWithFirebase(); // Optionally trigger immediate sync when online
//    } else {
//      // Save data offline if offline
//      await saveOfflineData(_textController.text);
//      _textController.clear();
//    }
//  }

//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('Offline Firebase Sync'),
//      ),
//      body: Padding(
//        padding: const EdgeInsets.all(16.0),
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: [
//            TextField(
//              controller: _textController,
//              decoration: InputDecoration(labelText: 'Enter data'),
//            ),
//            SizedBox(height: 16.0),
//            ElevatedButton(
//              onPressed: submitData,
//              child: Text('Submit data'),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Domain/entities
//class OfflineData {
//  final String data;

//  OfflineData(this.data);
//}

// Domain/repositories
abstract class OfflineRepository {
  Future<void> saveOfflineData(String data);
}

// Data/repositories
class OfflineRepositoryImpl implements OfflineRepository {
  final LocalDataSource localDataSource;
  final FirebaseFirestore firestore;

  OfflineRepositoryImpl({
    required this.localDataSource,
    required this.firestore,
  });

  @override
  Future<void> saveOfflineData(String data) async {
    await localDataSource.saveDataLocally(data);
    await _syncDataWithFirebase(data);
  }

  Future<void> _syncDataWithFirebase(String data) async {
    try {
      await firestore.collection('offline_collection_clean').add({
        'data': data,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error syncing data with Firebase: $e');
    }
  }
}

// Data/datasources
class LocalDataSource {
  static const String _offlineDataBoxName = 'offlineData';

  Future<void> saveDataLocally(String data) async {
    final Box<String> offlineDataBox =
        await Hive.openBox<String>(_offlineDataBoxName);
    offlineDataBox.add(data);
  }
}

// Presentation/pages
class HomePage extends StatefulWidget {
  final OfflineRepository offlineRepository;

  HomePage({required this.offlineRepository});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textController = TextEditingController();

  Future<void> _submitData(BuildContext context) async {
    final String data = _textController.text;
    if (data.isNotEmpty) {
      bool isOnline = await _checkConnectivity();
      if (isOnline) {
        await widget.offlineRepository.saveOfflineData(data);
        _textController.clear();
      } else {
        _saveLocallyAndNotifyUser(context, data);
      }
    } else {}
  }

  Future<bool> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  void _saveLocallyAndNotifyUser(BuildContext context, String data) {
    widget.offlineRepository.saveOfflineData(data);

    // Notify the user about the offline status
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You are offline. Data will be saved locally.'),
      ),
    );
  }

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
              onPressed: () => _submitData(context),
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();

  final localDataSource = LocalDataSource();
  final firestore = FirebaseFirestore.instance;
  final offlineRepository = OfflineRepositoryImpl(
    localDataSource: localDataSource,
    firestore: firestore,
  );

  //await syncPendingData(offlineRepository);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(offlineRepository: offlineRepository),
    ),
  );
}

//Future<void> syncPendingData(OfflineRepository offlineRepository) async {
//  // Fetch pending data from local storage
//  final Box<String> offlineDataBox = await Hive.openBox<String>('offlineData');
//  final List<String> pendingData = offlineDataBox.values.toList();

//  // Sync each pending data with Firebase Firestore
//  for (final data in pendingData) {
//    await offlineRepository.saveOfflineData(data);
//  }

//  // Clear the local storage after syncing
//  offlineDataBox.clear();
//}

//Future<void> syncPendingData(OfflineRepository offlineRepository) async {
//  final Box<String> offlineDataBox = await Hive.openBox<String>('offlineData');
//  final Box<String> syncedDataBox = await Hive.openBox<String>('syncedData');

//  // Retrieve the unique identifiers of previously synced data
//  final Set<String> syncedIds = Set.from(syncedDataBox.values);

//  // Fetch pending data from local storage
//  final List<String> pendingData = offlineDataBox.values.toList();

//  // Sync each pending data with Firebase Firestore
//  for (final data in pendingData) {
//    // Generate a unique identifier for the data using timestamp and UUID
//    final String dataId =
//        '${DateTime.now().millisecondsSinceEpoch}-${Uuid().v4()}';

//    // Check if the data has already been synced
//    if (!syncedIds.contains(dataId)) {
//      await offlineRepository.saveOfflineData(data);
//      syncedDataBox.add(dataId); // Store the ID of the synced data
//    }
//  }

//  // Clear the local storage after syncing
//  offlineDataBox.clear();
//}


  






















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

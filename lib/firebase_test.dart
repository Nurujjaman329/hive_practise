// domain/entities/offline_data.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class OfflineData {
  final String data;

  OfflineData(this.data);
}

// domain/repositories/offline_repository.dart

abstract class OfflineRepository {
  Future<void> saveOfflineData(String data);
}

// data/repositories/offline_repository_impl.dart

class OfflineRepositoryImpl implements OfflineRepository {
  final LocalDataSource localDataSource;
  final FirebaseFirestore firestore;

  OfflineRepositoryImpl(
      {required this.localDataSource, required this.firestore});

  @override
  Future<void> saveOfflineData(String data) async {
    await localDataSource.saveDataLocally(data);
    await _syncDataWithFirebase(data);
  }

  Future<void> _syncDataWithFirebase(String data) async {
    try {
      await firestore.collection('offline_collection').add({
        'data': data,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error syncing data with Firebase: $e');
    }
  }
}

// data/datasources/local_data_source.dart

class LocalDataSource {
  static const String _offlineDataBoxName = 'offlineData';

  Future<void> saveDataLocally(String data) async {
    final Box<String> offlineDataBox =
        await Hive.openBox<String>(_offlineDataBoxName);
    offlineDataBox.add(data);
  }
}

// presentation/pages/home_page.dart

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
      await widget.offlineRepository.saveOfflineData(data);
      _textController.clear();
    } else {
      // Show error message or handle empty data case
    }
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
      localDataSource: localDataSource, firestore: firestore);

  runApp(
    MaterialApp(
      home: HomePage(offlineRepository: offlineRepository),
    ),
  );
}

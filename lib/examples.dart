//import 'package:connectivity_plus/connectivity_plus.dart';
//import 'package:hive/hive.dart';

//class Message {
//  final String text;

//  Message(this.text);
//}

//class LocalDatabase {
//  final String boxName = 'messagesBox';

//  Future<void> saveMessage(Message message) async {
//    final box = await Hive.openBox(boxName);
//    await box.add(message);
//  }

//  Future<List> getUnsyncedMessages() async {
//    final box = await Hive.openBox(boxName);
//    // Logic to retrieve unsynchronized messages from the local database
//    return box.values.toList();
//  }

//  //Future<List<Message>> getUnsyncedMessages() async {
//  //  final box = await Hive.openBox(boxName);
//  //  // Logic to retrieve unsynchronized messages from the local database
//  //  return box.values.toList();
//  //}

//  Future<void> clearLocalDatabase() async {
//    final box = await Hive.openBox(boxName);
//    await box.clear();
//  }

//  init() {}
//}

//class ApiService {
//  // Simulated API service
//  Future<void> sendMessages(List messages) async {
//    // Simulated API call
//    await Future.delayed(Duration(seconds: 2));
//    print('Messages sent successfully');
//  }
//}

//Future<void> main() async {
//  final localDatabase = LocalDatabase();
//  final apiService = ApiService();

//  // Save a message to the local database (simulating offline creation)
//  await localDatabase.saveMessage(Message('Hello, world!'));

//  // Check internet connection
//  var connectivityResult = await Connectivity().checkConnectivity();
//  if (connectivityResult == ConnectivityResult.mobile ||
//      connectivityResult == ConnectivityResult.wifi) {
//    // Internet connection is available
//    final unsyncedMessages = await localDatabase.getUnsyncedMessages();
//    if (unsyncedMessages.isNotEmpty) {
//      // Send unsynchronized messages to the remote API
//      await apiService.sendMessages(unsyncedMessages);

//      // Clear the local database after successful sending
//      await localDatabase.clearLocalDatabase();
//    }
//  } else {
//    print('No internet connection. Data will be sent later.');
//  }
//}








////class DataRepository {
////  final LocalDataSource localDataSource;
////  final RemoteDataSource remoteDataSource;

////  DataRepository({required this.localDataSource, required this.remoteDataSource});

////  Future<List<Data>> fetchData() async {
////    // Try fetching data from the local database
////    List<Data> localData = await localDataSource.fetchData();

////    // Check if the device is online
////    bool isOnline = await checkNetworkStatus();

////    if (isOnline) {
////      // Fetch data from the remote server
////      List<Data> remoteData = await remoteDataSource.fetchData();

////      // Synchronize local database with remote data
////      await localDataSource.syncData(remoteData);

////      // Return the merged data
////      return localData + remoteData;
////    } else {
////      // Device is offline, return local data
////      return localData;
////    }
////  }
////}

////// Example of local and remote data sources
////abstract class LocalDataSource {
////  Future<List<Data>> fetchData();
////  Future<void> syncData(List<Data> data);
////}

////abstract class RemoteDataSource {
////  Future<List<Data>> fetchData();
////}

////class Data {
////  // Data model
////}

////Future<bool> checkNetworkStatus() async {
////  // Implement a function to check if the device is online
////  // This can be done using the connectivity package or other methods
////  return true; // Assume online for simplicity
////}

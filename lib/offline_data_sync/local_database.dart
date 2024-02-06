//import 'package:hive_flutter/hive_flutter.dart';

//class Constants {
//  static const String messageBoxName = 'messages';
//}

//class LocalDatabase {
//  Future<void> init() async {
//    await Hive.initFlutter();
//    Hive.registerAdapter(MessageAdapter());
//    await Hive.openBox<Message>(Constants.messageBoxName);
//  }

//  List<Message> getUnsyncedMessages() {
//    final Box<Message> messageBox = Hive.box<Message>(Constants.messageBoxName);
//    return messageBox.values.where((message) => !message.isSynced).toList();
//  }

//  void clearUnsyncedMessages() {
//    final Box<Message> messageBox = Hive.box<Message>(Constants.messageBoxName);
//    messageBox.values.forEach((message) {
//      if (!message.isSynced) {
//        message.isSynced = true;
//        message.save();
//      }
//    });
//  }

//  void addMessage(Message message) {
//    final Box<Message> messageBox = Hive.box<Message>(Constants.messageBoxName);
//    messageBox.add(message);
//  }
//}

//@HiveType(typeId: 0)
//class Message {
//  @HiveField(0)
//  late String content;

//  @HiveField(1)
//  late bool isSynced;

//  @HiveField(2)
//  late DateTime timestamp;

//  Message({
//    required this.content,
//    required this.isSynced,
//    required this.timestamp,
//  });

//  // Add this method to save the message
//  Future<void> save() async {
//    final Box<Message> messageBox = Hive.box<Message>(Constants.messageBoxName);
//    await messageBox.put(timestamp.millisecondsSinceEpoch, this);
//  }
//}

//class MessageAdapter extends TypeAdapter<Message> {
//  @override
//  final int typeId = 0;

//  @override
//  Message read(BinaryReader reader) {
//    return Message(
//      content: reader.read(),
//      isSynced: reader.read(),
//      timestamp: reader.read(),
//    );
//  }

//  @override
//  void write(BinaryWriter writer, Message obj) {
//    writer.write(obj.content);
//    writer.write(obj.isSynced);
//    writer.write(obj.timestamp);
//  }
//}

// import 'package:flutter/material.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

// class SqlDatabase {
//   static Database? _db;
//
//   Future<Database?> get db async {
//     if (_db == null) {
//       _db = await initDb();
//       return _db;
//     }
//     return _db;
//   }
//
//   initDb() async {
//     String data_base_path = await getDatabasesPath();
//     String path = join(data_base_path, '_database.db');
//     Database myDb = await openDatabase(
//       path,
//       onCreate: _onCreate,
//       version: 1,
//       onUpgrade: _onUpgrade,
//     );
//     return myDb;
//   }
//
//   _onUpgrade(Database db, int oldVersion, int newVersion) {
//     print("onUpgrade ===========================");
//   }
//
//   _onCreate(Database db, int version) async {
//     // await db
//     //     .execute('CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)')
//     // ;
//     print("onCreate ===========================");
//
//     await db
//         .execute(
//             'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, data TEXT , time TEXT , status TEXT )')
//         .then((value) {
//       print('Table has been created');
//       print("onCreate ===========================");
//     }).catchError(
//       (error) {
//         print(
//             'Error has been habend while inserting in the data :${error.toString()}');
//       },
//     );
//     print('Data Has been Created');
//   }
//
//   // Future<List<Task>> readData() async {
//   //   Database? myDb = await db;
//   //   var tasks = await myDb!.rawQuery('SELECT * FROM "tasks"');
//   //   var result = await tasks.map((e) => Task.fromJson(e)).toList();
//   //   return result;
//   //
//   //   ///this will be list of tasks
//   // }
//
//   Future insertData(
//       {@required dynamic title,
//         @required dynamic date,
//         @required dynamic time}) async {
//     // Insert some records in a transaction
//     Database? myDb = await db;
//     // int response = await myDb!.rawInsert(
//     //     "INSERT INTO 'tasks' ( 'title', 'data' , 'time'  , 'status') VALUES( '$title','$date' , '$time' , 'false')");
//     // return response;
//
//     return await myDb!.transaction((txn) async {
//       int id1 = await txn.rawInsert(
//           "INSERT INTO tasks ( title, data , time  , status) VALUES( '$title','$date' , '$time' , 'false')");
//       print('inserted1: $id1');
//     }).then((value) {
//       print(value);
//     }).catchError((error) {
//       print(
//         error.toString(),
//       );
//     });
//   }
// }

abstract class MapsStates{}

class MapInitialState extends MapsStates{}
class AddMarkerState extends MapsStates{}
class AddLocationState extends MapsStates{}

class GetAllUserLocationSuccess extends MapsStates{}
class UpdateAllUserDisSuccess extends MapsStates{}

class GetAllUserLocationError extends MapsStates{}
class CalcDistence extends MapsStates{}
class GetRoute extends MapsStates{}
class SendRequest extends MapsStates{}
class AcceptReq extends MapsStates{}
class Refresh extends MapsStates{}
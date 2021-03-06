// import 'dart:async';
//
// import 'package:rapido/src/document.dart';
// import 'package:rapido/src/document_list.dart';
// import 'persistence.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// import 'dart:convert';
//
// class SqlLitePersistence implements PersistenceProvider {
//   final String databaseName;
//   Database _database;
//   SqlLitePersistence(this.databaseName);
//
//   @override
//   Future deleteDocument(Document doc) async {
//     _getDatabase().then((Database database) {
//       database.delete(doc.documentType, where: "_id = ?", whereArgs: [doc.id]);
//     });
//   }
//
//   @override
//   Future loadDocuments(DocumentList documentList,
//       {Function onChangedListener}) async {
//     if (await _checkDocumentTypeExists(documentList.documentType)) {
//       List<Map<String, dynamic>> maps =
//           await _getDocuments(docType: documentList.documentType);
//       maps.forEach((Map<String, dynamic> map) {
//         Document loadedDoc = Document.fromMap(map);
//         loadedDoc.addListener(documentList.notifyListeners);
//         documentList.add(loadedDoc, saveOnAdd: false);
//       });
//     }
//   }
//
//   Future<List<Map<String, dynamic>>> _getDocuments({String docType}) async {
//     Database database = await _getDatabase();
//     List<Map<String, dynamic>> maps = await database.query(docType);
//     return maps;
//   }
//
//   Future<bool> _checkDocumentTypeExists(String docType) async {
//     Database database = await _getDatabase();
//     String q =
//         "SELECT count(*) FROM sqlite_master WHERE type='table' AND name='$docType';";
//
//     List<Map<String, dynamic>> maps = await database.rawQuery(q);
//     return maps[0]["count(*)"] == 1;
//   }
//
//   Future<Database> _getDatabase() async {
//     if (this._database == null) {
//       _database = await openDatabase(
//         join(await getDatabasesPath(), this.databaseName),
//       );
//     }
//     return _database;
//   }
//
//   String _createTableSql(Document doc) {
//     String s = "CREATE TABLE ${doc.documentType}(_id TEXT PRIMARY KEY";
//     doc.keys.forEach((String key) {
//       if (key != "_id") {
//         s += ", '$key' BLOB";
//       }
//     });
//     s += ")";
//     return s;
//   }
//
//   Future _createTableFromDoc({Document doc}) async {
//     Database database = await _getDatabase();
//     await database.execute(_createTableSql(doc));
//   }
//
//   String _keyStringFromDoc(Document doc) {
//     bool first = true;
//     String keysStr = "(";
//     doc.keys.forEach((String key) {
//       if (!first) {
//         keysStr += ", ";
//       }
//       first = false;
//       keysStr += "'$key'";
//     });
//     keysStr += ")";
//     return keysStr;
//   }
//
//   String _valuesStringFromDoc(Document doc) {
//     String vStr = ("(?");
//     for (int i = 1; i < doc.length; i++) {
//       vStr += ", ?";
//     }
//     vStr += ")";
//     return vStr;
//   }
//
//   List<dynamic> _safeValues(Document doc) {
//     Map<String, dynamic> safeMap = Map.from(doc);
//     safeMap.keys.forEach((String key) {
//       if (safeMap[key] is bool) {
//         if (safeMap[key]) {
//           safeMap[key] = 1;
//         } else {
//           safeMap[key] = 0;
//         }
//       }
//       if (key.endsWith("latlong")) {
//         safeMap[key] = jsonEncode(safeMap[key]);
//       }
//     });
//     return safeMap.values.toList();
//   }
//
//   @override
//   saveDocument(Document doc) async {
//     if (!await _checkDocumentTypeExists(doc.documentType)) {
//       await _createTableFromDoc(doc: doc);
//     }
//     String kStr = _keyStringFromDoc(doc);
//     String vStr = _valuesStringFromDoc(doc);
//     print(kStr);
//     print(vStr);
//
//     String q = "INSERT OR REPLACE INTO ${doc.documentType} $kStr VALUES $vStr";
//     Database database = await _getDatabase();
//
//     int changes = await database.rawUpdate(q, _safeValues(doc));
//   }
// }

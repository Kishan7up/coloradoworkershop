import 'package:app/models/DB_Models/recent_view_list_db_tabel.dart';
import 'package:app/models/common/inquiry_product_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class OfflineDbHelper {
  static OfflineDbHelper _offlineDbHelper;
  static Database database;

  static const TABLE_PRODUCT_CART = "product_cart";
  static const TABLE_INQUIRY_PRODUCT = "inquiry_product";
  static const TABLE_RECENT_VIEW = "recent_view";

  static createInstance() async {
    _offlineDbHelper = OfflineDbHelper();
    database = await openDatabase(
        join(await getDatabasesPath(), 'grocery_shop_database.db'),
        onCreate: (db, version) => _createDb(db),
        version: 4);
  }

  static void _createDb(Database db) {
    String ProductName, Unit, LoginUserID;

    db.execute(
      'CREATE TABLE $TABLE_PRODUCT_CART(id INTEGER PRIMARY KEY AUTOINCREMENT, ProductID INTEGER,Quantity DOUBLE, Amount DOUBLE, NetAmount DOUBLE , ProductName TEXT, ProductImage TEXT)',
    );
    db.execute(
      'CREATE TABLE $TABLE_INQUIRY_PRODUCT(id INTEGER PRIMARY KEY AUTOINCREMENT, InquiryNo TEXT,LoginUserID TEXT, CompanyId TEXT, ProductName TEXT, ProductID TEXT, Quantity TEXT, UnitPrice TEXT,TotalAmount TEXT)',
    );

    /* int id;
  String title;
  String caseNo;
  String caseDetailShort;
  String caseDetailLong;
  String filter;
  String link;*/
    db.execute(
      'CREATE TABLE $TABLE_RECENT_VIEW(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT,caseNo TEXT , caseDetailShort TEXT, caseDetailLong TEXT,filter TEXT,link TEXT, subTitle TEXT , category TEXT , judgeName TEXT)',
    );
    //TABLE_RECENT_VIEW
  }

  static OfflineDbHelper getInstance() {
    return _offlineDbHelper;
  }

  ///Here InquiryProduct Table Implimentation

  Future<int> insertInquiryProduct(InquiryProductModel model) async {
    final db = await database;

    return await db.insert(
      TABLE_INQUIRY_PRODUCT,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<InquiryProductModel>> getInquiryProduct() async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query(TABLE_INQUIRY_PRODUCT);

    return List.generate(maps.length, (i) {
      return InquiryProductModel(
        maps[i]['InquiryNo'],
        maps[i]['LoginUserID'],
        maps[i]['CompanyId'],
        maps[i]['ProductName'],
        maps[i]['ProductID'],
        maps[i]['Quantity'],
        maps[i]['UnitPrice'],
        maps[i]['TotalAmount'],
        id: maps[i]['id'],
      );
    });
  }

  Future<void> updateInquiryProduct(InquiryProductModel model) async {
    final db = await database;

    await db.update(
      TABLE_INQUIRY_PRODUCT,
      model.toJson(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<void> deleteInquiryProduct(int id) async {
    final db = await database;

    await db.delete(
      TABLE_INQUIRY_PRODUCT,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteALLInquiryProduct() async {
    final db = await database;

    await db.delete(TABLE_INQUIRY_PRODUCT);
  }

  ///Here Recent View Table Implimentation

  Future<int> insertRecentViewDBTable(RecentViewDBTable model) async {
    final db = await database;

    return await db.insert(
      TABLE_RECENT_VIEW,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<RecentViewDBTable>> getRecentViewDBTable() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(TABLE_RECENT_VIEW);

    /* int id;
  String title;
  String caseNo;
  String caseDetailShort;
  String caseDetailLong;
  String filter;
  String link;*/
    return List.generate(maps.length, (i) {
      return RecentViewDBTable(
        maps[i]['title'],
        maps[i]['caseNo'],
        maps[i]['caseDetailShort'],
        maps[i]['caseDetailLong'],
        maps[i]['filter'],
        maps[i]['link'],
        maps[i]['subTitle'],
        maps[i]['category'],
        maps[i]['judgeName'],
        id: maps[i]['id'],
      );
    });
  }

  /*final List<Map<String, dynamic>> maps = await db.query(TABLE_QT_ASSEMBLY,
  where: 'FinishProductID = ? ', whereArgs: [FinishProductID]);*/

  Future<List<RecentViewDBTable>> getSearchRecentViewDBTable(
      String keyword, String dropdownItem) async {
    final db = await database;

    //final List<Map<String, dynamic>> maps = await db.query(TABLE_RECENT_VIEW);
    List<Map<String, dynamic>> maps;

   /* if (keyword == "") {
      maps = await db.query(TABLE_RECENT_VIEW);
    }
    else {
      maps = await db.query(TABLE_RECENT_VIEW,
          where: "title LIKE ?", whereArgs: ['%$keyword%']);
    }*/

    if (keyword == "") {
      if (dropdownItem == "ALL") {
        maps = await db.query(TABLE_RECENT_VIEW);
      } else {

       // List<String> clist = dropdownItem.split(",");

        maps = await db.query(TABLE_RECENT_VIEW,
            where: "category = ?", whereArgs: [dropdownItem]);
    /* maps = await db.query(TABLE_RECENT_VIEW,
            where: "category IN ($dropdownItem)");*/
      }
    } else {
      if (dropdownItem == "ALL") {
        maps = await db.query(TABLE_RECENT_VIEW,
            where: "title LIKE ?", whereArgs: ['%$keyword%']);
      } else {
        maps = await db.query(TABLE_RECENT_VIEW,
            where: "title LIKE and category = ?",
            whereArgs: ['%$keyword%', dropdownItem]);

        /*maps = await db.query(TABLE_RECENT_VIEW,
            where: "title LIKE and category  IN (${dropdownItem})",
            whereArgs: ['%$keyword%', dropdownItem]);*/
      }

      /* db.query(TABLE_RECENT_VIEW,
          where: 'CustomerName = ? ', whereArgs: [keyword]);*/
    }

    return List.generate(maps.length, (i) {
      return RecentViewDBTable(
        maps[i]['title'],
        maps[i]['caseNo'],
        maps[i]['caseDetailShort'],
        maps[i]['caseDetailLong'],
        maps[i]['filter'],
        maps[i]['link'],
        maps[i]['subTitle'],
        maps[i]['category'],
        maps[i]['judgeName'],


        id: maps[i]['id'],
      );
    });
  }




  Future<void> updateRecentViewDBTable(RecentViewDBTable model) async {
    final db = await database;

    await db.update(
      TABLE_RECENT_VIEW,
      model.toJson(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<void> deleteRecentViewDBTable(int id) async {
    final db = await database;

    await db.delete(
      TABLE_RECENT_VIEW,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteALLRecentViewDBTable() async {
    final db = await database;

    await db.delete(TABLE_RECENT_VIEW);
  }
}

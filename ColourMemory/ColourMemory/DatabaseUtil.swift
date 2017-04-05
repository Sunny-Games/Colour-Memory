//
//  DatabaseUtil.swift
//  DejaFashion
//
//  Created by DanyChen on 21/12/15.
//  Copyright © 2015 Mozat. All rights reserved.
//

import UIKit
import FMDB

private var databaseMap = [String : Database]()

private struct BaseColumns {
  static let id = "id"
  static let rawData = "raw_data"
}

func TableWith<T : NSObject>(_ tableName : String?, type : T.Type, primaryKey : String?, dbName : String = "Default") -> Table<T> {
  return Table<T>(name: (tableName == nil ? NSStringFromClass(T):tableName!), primaryKey : primaryKey, dbName : dbName)
}

func TableWith<T : NSObject>(_ tableName : String?, type : T.Type, primaryKey : String?, dbName : String = "Default", columns : [String]? = nil) -> Table<T> {
  return Table<T>(name: (tableName == nil ? NSStringFromClass(T):tableName!), primaryKey : primaryKey, dbName : dbName, columns : columns)
}


class Table<T : NSObject> {
  var name : String
  fileprivate var dbName : String
  fileprivate var primaryKey : String?
  fileprivate var database : Database?
  fileprivate var normalColumns : [String]?
  fileprivate var columns : [String]?
  fileprivate var queue : FMDatabaseQueue?
  
  //primaryKey should be one of the property name, columns should be the sublist of all properties
  fileprivate init(name : String, primaryKey : String?,  dbName : String, columns : [String]? = nil) {
    self.name = name
    self.dbName = dbName
    self.primaryKey = primaryKey
    self.columns = columns
    if self.columns == nil {
      self.columns = getPropertyList()
    }
    
    setupDatabase()
    if database != nil {
      queue = FMDatabaseQueue(path: database!.fmDatabase.databasePath())
    }
  }
  
  fileprivate func getPropertyList() -> [String] {
    let t = T()
    return Mirror(reflecting: t).children.filter { $0.label != nil }.map { $0.label! }
  }
  
  fileprivate func setupDatabase() -> Bool {
    if database == nil {
      if let db = databaseMap[dbName] {
        let setupSuccess = db.setupTable(name, primaryKey: primaryKey, columns: getNormalColumns())
        if setupSuccess {
          database = db
        }else {
          return false
        }
      }else {
        let database = Database(name: dbName)
        let setupSuccess = database.setupTable(name, primaryKey: primaryKey, columns: getNormalColumns())
        if setupSuccess {
          self.database = database
          databaseMap[dbName] = database
        }else {
          return false
        }
      }
    }
    return true
  }
  
  func getNormalColumns() -> [String] {
    if normalColumns == nil {
      normalColumns = self.columns!.filter( { $0 != primaryKey} )
    }
    return normalColumns!
  }
  
  func parseResultSetToObj(_ resultSet : FMResultSet) -> T? {
    let obj = T()
    for key in columns! {
      let value = resultSet.object(forColumnName: key)
      if !(value is NSNull) {
        obj.setValue(value, forKey: key)
      }
    }
    return obj
  }
  
  func convertObjToValue(_ obj : T) -> [Any?] {
    return columns!.map { obj.value(forKey: $0)}
  }
  
  
  func save(_ obj : T) {
    if database == nil { return }
    queue?.inDatabase({(db : FMDatabase?) -> Void in
      self.database!.insert(self.name, columns: self.columns!, values: self.convertObjToValue(obj))
    })
  }
  
  func saveAll(_ objs : [T]){
    if database == nil { return }
    queue?.inDatabase({(db : FMDatabase?) -> Void in
      self.database!.bulkInsert(self.name, columns: self.columns!, valuesList: objs.map({ (obj : T) -> [Any?] in
        self.convertObjToValue(obj)
      }))
    })
  }
  
  func query(_ columnNames : [String], values : [AnyObject?], orderBy : String = "", handler : @escaping ([T]) -> Void) {
    if database == nil { handler([]) }
    queue?.inDatabase({(db : FMDatabase?) -> Void in
      var array = [T]()
      if let rs = self.database!.query(self.name, columns: columnNames, values: values, orderBy: orderBy) {
        while rs.next() {
          if let t = self.parseResultSetToObj(rs) {
            array.append(t)
          }
        }
      }
      handler(array)
    })
  }
  
  func querySingle(_ columnNames : [String], values : [AnyObject?], handler : @escaping (T?) -> Void){
    if database == nil { handler(nil)}
    queue?.inDatabase({(db : FMDatabase?) -> Void in
      if let rs = self.database!.query(self.name, columns: columnNames, values: values) {
        while rs.next() {
          handler(self.parseResultSetToObj(rs))
          break
        }
      }
    })
  }
  
  func queryAll(_ orderby : String = "", handler : @escaping ([T]) -> Void){
    if database == nil {
      handler([])
    }
    queue?.inDatabase({(db : FMDatabase?) -> Void in
      var array = [T]()
      if let rs = self.database!.query(self.name, columns: nil, values: nil, orderBy: orderby) {
        while rs.next() {
          if let t = self.parseResultSetToObj(rs) {
            array.append(t)
          }
        }
      }
      handler(array)
    })
  }
  
  func delete(_ columnNames : [String], values : [AnyObject?]) {
    if database == nil { return  }
    queue?.inDatabase({(db : FMDatabase?) -> Void in
      self.database!.delete(self.name, columns: columnNames, values: values)
    })
  }
  
  func deleteAll() {
    if database == nil { return  }
    queue?.inDatabase({(db : FMDatabase?) -> Void in
      self.database!.delete(self.name, columns: nil, values: nil)
    })
  }
  
  func executeUpdates(_ sqls : [String]) {
    if database == nil { return  }
    queue?.inDatabase({(db : FMDatabase?) -> Void in
      self.database!.executeUpdates(sqls)
    })
  }
}




private class Database : NSObject {
  var fmDatabase : FMDatabase
  
  
  init(name : String) {
    let fileManager = FileManager.default
    let documents = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    let fileURL = documents.appendingPathComponent(name + ".db")
    let urlPath = fileURL.path
    fmDatabase = FMDatabase(path: urlPath)
    
    if !fmDatabase.open() {
      print("Unable to open database")
      fmDatabase.close()
      do {
        try fileManager.removeItem(atPath: urlPath)
        print("delete database file success")
      }catch {
        print("Unable to delete database")
      }
      
    }
  }
  
  func setupTable(_ name : String, primaryKey : String?, columns : [String]) -> Bool {
    if fmDatabase.open() && columns.count > 0 {
      if let existingColumns = getExistingColumnsOfTable(name) {
        return updateTableStructure(name ,columns: columns, originColumnNames: existingColumns)
      }else {
        return createTable(name, primaryKey: primaryKey, columns: columns)
      }
    }else {
      return false
    }
  }
  
  func getExistingColumnsOfTable(_ tableName : String) -> Set<String>? {
    guard let rs = fmDatabase.executeQuery("PRAGMA table_info(\(tableName))", withArgumentsIn: nil) else {return nil}
    var result = Set<String>()
    while rs.next() {
      if let columnName = rs.string(forColumn: "name") {
        result.insert(columnName)
      }
    }
    return result.count > 0 ? result : nil
  }
  
  func updateTableStructure(_ tableName : String, columns : [String], originColumnNames : Set<String>) -> Bool{
    var columnsNeedToAdd = [String]()
    var result = true
    for column in columns {
      if !originColumnNames.contains(column) {
        columnsNeedToAdd.append(column)
      }
    }
    if columnsNeedToAdd.count == 0 {
      return true
    }
    
    for column in columnsNeedToAdd {
      let sql = "alter table " + tableName + " add column " + column + " TEXT"
      result = fmDatabase.executeUpdate(sql, withArgumentsIn: nil)
    }
    
    return result
  }
  
  
  func createTable(_ tableName : String, primaryKey : String?, columns : [String]) -> Bool {
    var sql = "create table " + tableName + "("
    if let primaryColumn = primaryKey {
      sql += primaryColumn + " TEXT primary key"
    }else {
      sql += "id INTEGER primary key autoincrement"
    }
    for column in columns {
      sql += ", " + column + " TEXT"
    }
    sql += ")"
    return fmDatabase.executeUpdate(sql, withArgumentsIn: nil)
  }
  
  func insert(_ tableName : String, columns : [String], values : [Any?]) -> Bool {
    return insertWithPreparedSql(prepareSqlForInsertColumns(tableName, columns: columns), valueCount: columns.count, values: values)
  }
  
  fileprivate func insertWithPreparedSql(_ sql : String, valueCount : Int,  values : [Any?]) -> Bool {
    if valueCount == 0 || valueCount != values.count {
      return false
    }
    return fmDatabase.executeUpdate(sql, withArgumentsIn: convertNullObjects(valueCount, values: values))
  }
  
  fileprivate func convertNullObjects(_ count : Int, values : [Any?]) -> [Any] {
    var objects = [Any]()
    for i in 0..<count {
      if values[i] == nil {
        objects.append(NSNull())
      }else {
        objects.append(values[i]!)
      }
    }
    return objects
  }
  
  func prepareSqlForInsertColumns(_ tableName : String, columns : [String]) -> String {
    var combineColumnString = ""
    var questioMarks = ""
    for i in 0..<columns.count {
      if i == 0 {
        combineColumnString += columns[0]
        questioMarks += "?"
      }else {
        combineColumnString += "," + columns[i]
        questioMarks += ",?"
      }
    }
    return "insert or replace into " + tableName + "(" + combineColumnString + ") values(" + questioMarks + ")";
  }
  
  func bulkInsert(_ tableName : String, columns : [String], valuesList : [[Any?]]) -> Bool {
    fmDatabase.beginTransaction()
    var success = true
    let sql = prepareSqlForInsertColumns(tableName, columns: columns)
    for values in valuesList {
      if !insertWithPreparedSql(sql, valueCount: columns.count, values: values) {
        success = false
        break
      }
    }
    if !success {
      fmDatabase.rollback()
    }else {
      fmDatabase.commit()
    }
    return success
  }
  
  func executeUpdates(_ sqls : [String]) -> Bool{
    fmDatabase.beginTransaction()
    var success = true
    for sql in sqls {
      if !fmDatabase.executeUpdate(sql, withArgumentsIn: nil) {
        success = false
        break
      }
    }
    if !success {
      fmDatabase.rollback()
    }else {
      fmDatabase.commit()
    }
    return success
  }
  
  func query(_ tableName : String, columns : [String]?, values : [AnyObject?]?, orderBy : String = "") -> FMResultSet? {
    var orderBySuffix = ""
    if orderBy.characters.count > 0 {
      orderBySuffix = "order by " + orderBy
    }
    if columns == nil || columns?.count == 0 {
      return fmDatabase.executeQuery("select * from " + tableName + " " + orderBySuffix, withArgumentsIn: nil)
    }else if columns?.count == values?.count {
      var condition = " where "
      var i = 0
      for column in columns! {
        if i == 0 {
          condition += column + "=?"
        }else {
          condition += "and " + column + "=? "
        }
        i += 1
      }
      return fmDatabase.executeQuery("select * from " + tableName + condition + " " + orderBySuffix, withArgumentsIn: convertNullObjects(columns!.count, values: values!))
    }
    return nil
  }
  
  func delete(_ tableName : String, columns : [String]?, values : [AnyObject?]?) -> Bool {
    if columns == nil || columns?.count == 0 {
      return fmDatabase.executeUpdate("delete from " + tableName, withArgumentsIn: nil)
    }else if columns?.count == values?.count {
      var condition = " where "
      var i = 0
      for column in columns! {
        if i == 0 {
          condition += column + "=?"
        }else {
          condition += "and " + column + "=? "
        }
        i += 1
      }
      return fmDatabase.executeUpdate("delete from " + tableName + condition, withArgumentsIn: convertNullObjects(columns!.count, values: values!))
    }
    return false
  }
}

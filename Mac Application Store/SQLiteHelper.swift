//
//  SQLiteHelper.swift
//  Mac Software Center
//
//  Created by Rafael Ortiz.
//  Copyright © 2017 Nextneo. All rights reserved.
//
import Foundation


class SQLiteHelper :NSObject {
    
    // sqlite3 *db;
    var db: OpaquePointer? = nil;
    
    // Constructor
    init(database: String) {
        super.init()
        
        self.db = open(database)
    }
    
    // Database Path
    func getFilePath(_ nome: String) -> String {
        // Path with file
        let path = NSHomeDirectory() + "/Documents/" + nome
        print("Database: \(path)")
        return path
    }
    
    // Opens the database
    func open(_ database: String) -> OpaquePointer? {
        
        var db: OpaquePointer? = nil;
        
        let path = getFilePath(database)
        let cPath = StringUtils.toCString(path)
        //let cPath = String(cString: path)
        //let cPath = path.cString(using: .utf8)!
        let result = sqlite3_open(cPath, &db);
        if(result != SQLITE_OK) {
            print("Could not open SQLite database \(result)")
            return nil
        } else {
            //println("SQLite OK")
        }
        
        return db
    }
    
    // Run SQL
    func execSql(_ sql: String) -> CInt {
        return self.execSql(sql, params: nil)
    }
    
    func execSql(_ sql: String, params: Array<AnyObject>!) -> CInt {
        var result:CInt = 0
        
        //let cSql = StringUtils.toCString(sql)
        
        // Statement
        let stmt = query(sql, params: params)
        
        // Step
        result = sqlite3_step(stmt)
        if (result != SQLITE_OK && result != SQLITE_DONE) {
            sqlite3_finalize(stmt)
            let msg = "Error SQL\n\(sql)\nError: \(lastSQLError())"
            print(msg)
            return -1
        } else {
            //println("SQL [\(sql)]")
        }
        
        // If insert, retrieve id
        if (sql.uppercased().hasPrefix("INSERT")) {
            // http://www.sqlite.org/c3ref/last_insert_rowid.html
            let rid = sqlite3_last_insert_rowid(self.db)
            result = CInt(rid)
        } else {
            result = 1
        }
        
        // Closes the statement
        sqlite3_finalize(stmt)
        
        return result
    }
    
    // paramaters bind (?,?,?) of query
    func bindParams(_ stmt:OpaquePointer, params: Array<AnyObject>!) {
        if(params != nil) {
            let size = params.count
            //            println("Bind \(size) values")
            for i:Int in 1...size {
                let value : AnyObject = params[i-1]
                if(value is Int) {
                    let number:CInt = toCInt(value as! Int)
                    
                    sqlite3_bind_int(stmt, toCInt(i), number)
                    
                    // println("bind int \(i) -> \(value)")
                } else if(value is String) {
                    
                    let text: String = value as! String
                    
                    SQLiteObjc.bindText(stmt, idx: toCInt(i), with: text)
                    
                    //println("bind tetxt \(i) -> \(value)")
                }
            }
        }
    }
    
    // Execute SQL and return statement
    func query(_ sql:String) -> OpaquePointer {
        return query(sql, params: nil)
    }
    
    // Execute SQL and return statement
    func query(_ sql:String, params: Array<AnyObject>!) -> OpaquePointer {
        var stmt:OpaquePointer? = nil
        
        let cSql = sql.cString(using: .utf8)!

        // Prepare
        let result = sqlite3_prepare_v2(db, cSql, -1, &stmt, nil)
        
        if (result != SQLITE_OK) {
            sqlite3_finalize(stmt)
            let msg = "Error SQL\n\(sql)\nError: \(lastSQLError())"
            print("SQLite ERROR \(msg)")
        } else {
            print("SQL [\(sql)], params: \(params)")
        }
        
        // Bind Values (?,?,?)
        if(params != nil) {
            bindParams(stmt!, params:params)
        }
        
        return stmt!
    }
    
    // Returns to a next line in the query
    func nextRow(_ stmt:OpaquePointer) -> Bool {
        let result = sqlite3_step(stmt)
        let next: Bool = result == SQLITE_ROW
        return next
    }
    
    // Closes the database
    func close() {
        sqlite3_close(self.db)
    }
    
    func closeStatement(_ stmt:OpaquePointer) {
        // Closes the statement
        sqlite3_finalize(stmt)
        close()
    }
    
    // Returns the last SQL error
    func lastSQLError() -> String {
        var err:UnsafePointer<Int8>? = nil
        err = sqlite3_errmsg(self.db)
        
        if(err != nil) {
            let s = NSString(utf8String: err!)
            return s! as String
        }
        
        return ""
    }
    
    // Reads a column of the Integer type
    func getInt(_ stmt:OpaquePointer, index:CInt) -> Int {
        let val = sqlite3_column_int(stmt, index)
        return Int(val)
    }
    
    // Reads a column of the Double Type
    func getDouble(_ stmt:OpaquePointer, index:CInt) -> Double {
        let val = sqlite3_column_double(stmt, index)
        return Double(val)
    }
    
    // Reads a column of the Float Type
    func getFloat(_ stmt:OpaquePointer, index:CInt) -> Float {
        let val = sqlite3_column_double(stmt, index)
        return Float(val)
    }
    
    // Reads a column of the String Type
    func getString(_ stmt:OpaquePointer, index:CInt) -> String {
        
        let cString  = SQLiteObjc.getText(stmt, idx: index)
        
        if let cs = cString {
            let s = String(describing: cs)
            
            return s
        }
        
        return ""
    }
    
    // Reads a column of the String Type and change to date format
    func getDate(_ stmt:OpaquePointer, index:CInt) -> Date {
        
        let cString  = SQLiteObjc.getText(stmt, idx: index)
        
        if let cs = cString {
            let s : String? = String(describing: cs)
            
            if(s != nil && (s?.isEmpty)! && s != ""){
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM dd, yyyy"
                return dateFormatter.date(from: s!)!
            }
            
        }
        
        return Date()
    }
    
    // Convert Int (swift) to CInt(C)
    func toCInt(_ swiftInt : Int) -> CInt {
        let number : NSNumber = swiftInt as NSNumber
        let pos: CInt = number.int32Value
        return pos
    }
}

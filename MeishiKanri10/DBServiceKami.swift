//
//  DBService.swift
//  MeishiKanri10
//
//  Created by 酒井健輔 on 2023/03/21.
//

import Foundation
import SQLite3

final class DBServiceKami {
    static let shared = DBServiceKami()
    
    private let dbFile = "MeishiDB.sqlite"
    private var db: OpaquePointer?
    
    private init() {
        db = openDatabase()
        if !createTable() {
            print("Failed to create table")
        }
    }
    
    private func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory,
                                                   in: .userDomainMask,
                                                   appropriateFor: nil,
                                                   create: false).appendingPathComponent(dbFile)
        
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Failed to open database")
            return nil
        }
        else {
            print("Opened connection to database")
            return db
        }
    }
    
    private func createTable() -> Bool {
        let createSql = """
        CREATE TABLE IF NOT EXISTS meishidb (
            id INTEGER NOT NULL PRIMARY KEY,
            name TEXT NOT NULL,
            uritext TEXT NOT NULL,
            biko TEXT NULL
        );
        """
        
        var createStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (createSql as NSString).utf8String, -1, &createStmt, nil) != SQLITE_OK {
            print("db error: \(getDBErrorMessage(db))")
            return false
        }
        
        if sqlite3_step(createStmt) != SQLITE_DONE {
            print("db error: \(getDBErrorMessage(db))")
            sqlite3_finalize(createStmt)
            return false
        }
        
        sqlite3_finalize(createStmt)
        return true
    }
    
    private func getDBErrorMessage(_ db: OpaquePointer?) -> String {
        if let err = sqlite3_errmsg(db) {
            return String(cString: err)
        } else {
            return ""
        }
    }
    
    func insertUriDB(meishi: Uri) -> Bool {
        let insertSql = """
                        INSERT INTO meishidb
                            (id, name, uritext, biko)
                            VALUES
                            (?, ?, ?, ?);
                        """;
        var insertStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (insertSql as NSString).utf8String, -1, &insertStmt, nil) != SQLITE_OK {
            print("db error: \(getDBErrorMessage(db))")
            return false
        }
        
        sqlite3_bind_int(insertStmt, 1,Int32(meishi.ID))
        sqlite3_bind_text(insertStmt, 2, (meishi.Name as NSString).utf8String, -1, nil)
        sqlite3_bind_text(insertStmt, 3, (meishi.UriText as NSString).utf8String, -1, nil)
        sqlite3_bind_text(insertStmt, 4, (meishi.Biko as NSString).utf8String, -1, nil)
        
        
        if sqlite3_step(insertStmt) != SQLITE_DONE {
            print("db error: \(getDBErrorMessage(db))")
            sqlite3_finalize(insertStmt)
            return false
        }
        sqlite3_finalize(insertStmt)
        return true
    }
    
    func updateUriDB(meishi: Uri) -> Bool {
        let updateSql = """
        UPDATE  meishidb
        SET     name = ?,
                uritext = ?,
                biko = ?
        WHERE   id = ?
        """
        var updateStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (updateSql as NSString).utf8String, -1, &updateStmt, nil) != SQLITE_OK {
            print("db error: \(getDBErrorMessage(db))")
            return false
        }
        
        sqlite3_bind_text(updateStmt, 1, (meishi.Name as NSString).utf8String, -1, nil)
        sqlite3_bind_text(updateStmt, 2, (meishi.UriText as NSString).utf8String, -1, nil)
        sqlite3_bind_text(updateStmt, 3, (meishi.Biko as NSString).utf8String, -1, nil)
        sqlite3_bind_int(updateStmt, 4, Int32(meishi.ID))
        
        if sqlite3_step(updateStmt) != SQLITE_DONE {
            print("db error: \(getDBErrorMessage(db))")
            sqlite3_finalize(updateStmt)
            return false
        }
        sqlite3_finalize(updateStmt)
        return true
    }
    
    func getUriDB(ID: Int) -> (success: Bool, errorMessage: String?, meishi: Uri?) {
     
        var meishi: Uri? = nil
        
        let sql = """
            SELECT  id, name, uritext, biko
            FROM    meishidb
            WHERE   id = ?;
            """
        
        var stmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &stmt, nil) != SQLITE_OK {
            return (false, "Unexpected error: \(getDBErrorMessage(db)).", meishi)
        }
        
        sqlite3_bind_int(stmt, 1, Int32(ID))
        
        if sqlite3_step(stmt) == SQLITE_ROW {
            let ID = Int(sqlite3_column_int(stmt, 0))
            let Name = String(describing: String(cString: sqlite3_column_text(stmt, 1)))
            let UriText = String(describing: String(cString: sqlite3_column_text(stmt, 2)))
            let Biko = String(describing: String(cString: sqlite3_column_text(stmt, 3)))
            
            meishi = Uri(id: ID, name: Name,
                                uritext: UriText, biko: Biko)
        }
        
        sqlite3_finalize(stmt)
        return (true, nil, meishi)
    }
    
    func getUriCount() -> (success: Bool, errorMessage: String?, count: Int) {
        
        var count: Int = 0
        
        let getUriCountSql = """
                        SELECT MAX(ID) as cnt
                        FROM meishidb;
                        """;
        var getUriCountStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (getUriCountSql as NSString).utf8String, -1, &getUriCountStmt, nil) != SQLITE_OK {
            print("db error: \(getDBErrorMessage(db))")
            return (false, "Unexpected error: \(getDBErrorMessage(db)).", count)
        }
        
        if sqlite3_step(getUriCountStmt) == SQLITE_ROW {
            count = Int(sqlite3_column_int(getUriCountStmt, 0))
        }
        
        sqlite3_finalize(getUriCountStmt)
        return (true, nil, count)
    }
    
    func deleteUriDB(ID: Int) -> Bool {
        let deleteSql = "DELETE FROM meishidb WHERE id = ?;";
        var deleteStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (deleteSql as NSString).utf8String, -1, &deleteStmt, nil) != SQLITE_OK {
            print("db error: \(getDBErrorMessage(db))")
            return false
        }
        
        sqlite3_bind_int(deleteStmt, 1,Int32(ID))
        
        if sqlite3_step(deleteStmt) != SQLITE_DONE {
            print("db error: \(getDBErrorMessage(db))")
            sqlite3_finalize(deleteStmt)
            return false
        }

        sqlite3_finalize(deleteStmt)
        return true
    }
    
    func dropTable() -> Bool {
        let dropSql = """
        DROP TABLE meishidb;
        """
        
        var dropStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (dropSql as NSString).utf8String, -1, &dropStmt, nil) != SQLITE_OK {
            print("db error: \(getDBErrorMessage(db))")
            return false
        }
        
        if sqlite3_step(dropStmt) != SQLITE_DONE {
            print("db error: \(getDBErrorMessage(db))")
            sqlite3_finalize(dropStmt)
            return false
        }
        
        sqlite3_finalize(dropStmt)
        return true
    }
}

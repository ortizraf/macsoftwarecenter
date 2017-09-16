//
//  CategoryDB.swift
//  Mac Application Store
//
//  Created by Rafael Ortiz on 07/01/17.
//  Copyright © 2017 Nextneo. All rights reserved.
//

import Foundation

class CategoryDB {
    var db: SQLiteHelper
    
    init() {
        self.db = SQLiteHelper(database:"macapplicationstore.db")
    }
    
    func tableExists() -> Bool {
        var isExists : Int
        isExists = 0
        let stmt = db.query("SELECT count(*) FROM sqlite_master WHERE type = 'table' AND name = 'category' ")
        while (db.nextRow(stmt)){
            isExists = db.getInt(stmt, index: 0)
            break
        }
        db.closeStatement(stmt)
        if(isExists<=0){
            return false
        }
        return true
    }
    
    func dropTable(){
        var dropSql = "drop table if exists category"
        db.execSql(dropSql)
    }

    
    func createTable(){
        var createSql = "create table if not exists category (id integer primary key, name text, active integer)"
        db.execSql(createSql)
    }
    
    func save(category: Category){
        let sql = "insert or replace into category (id, name, active) VALUES (?,?,?);"
        var active = 1
        if(!category.active!){
            active = 0
        }
        
        let params : [Any] = [category.id, category.name, active]
        let id = db.execSql(sql, params:params as Array<AnyObject>!)
    }

    
    func getAllCategory() -> Array<Category> {
        var categories : Array<Category> = []
        let stmt = db.query("SELECT * FROM category WHERE active = 1 order by category.name asc")
        while (db.nextRow(stmt)){
            let c = Category()
            c.id = db.getInt(stmt, index: 0)
            c.name = db.getString(stmt, index: 1)
            categories.append(c)
        }
        db.closeStatement(stmt)
        return categories
    }
    
    func getCategoryById(categoryId: Int) -> Category {
        let category = Category()
        if(categoryId > 0){
            let stmt = db.query("SELECT * FROM category WHERE id = ? ",params:[categoryId as AnyObject])
            while (db.nextRow(stmt)){
                category.id = db.getInt(stmt, index: 0)
                category.name = db.getString(stmt, index: 1)
            }
            db.closeStatement(stmt)
        }
        return category
    }


    
    func close(){
        self.db.close()
    }
}

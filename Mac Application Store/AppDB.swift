//
//  AppDB.swift
//  Mac Application Store
//
//  Created by Rafael Ortiz on 07/01/17.
//  Copyright © 2017 Nextneo. All rights reserved.
//

import Foundation

class AppDB {
    var db: SQLiteHelper
    
    init() {
        self.db = SQLiteHelper(database:"macapplicationstore.db")
    }
    
    func dropTable(){
        var dropSql = "drop table if exists app"
        db.execSql(dropSql)
    }

    
    func createTable(){
        var createSql = "create table if not exists app (id integer primary key autoincrement, name text, url_image text, download_link text, category_id integer, is_active integer, desc text, version text, last_update text, organization_id integer, website text, order_by integer, file_format text, FOREIGN KEY(category_id) REFERENCES category(id))"
        db.execSql(createSql)
    }
    
    func save(app: App){
        if(app==nil || app.name==nil || app.url_image==nil || app.download_link==nil || app.category==nil){
            print("erro")
        } else {
            var is_active = 1
            if(!app.is_active!){
                is_active = 0
            }
            if(app.description==nil){
                app.description = String()
            }
            if(app.version==nil){
                app.version = String()
            }
            if(app.last_update_text==nil){
                app.last_update_text = String()
            }
            var organizationId = app.organization?.id
            if(organizationId==nil){
                organizationId = Int()
            }
            if(app.website==nil){
                app.website = String()
            }
            if(app.order_by == 0 || app.order_by==nil){
                app.order_by = 99999
            }
            if(app.file_format==nil){
                app.file_format = String()
            }
            if(app.id == 0 || app.id == nil){
                //Insert
                let sql = "insert or replace into app (name, url_image, download_link, category_id, is_active, desc, version, last_update, organization_id, website, order_by, file_format) VALUES (?,?,?,?,?,?,?,?,?,?,?,?);"
                let params : [Any] = [app.name, app.url_image, app.download_link, app.category?.id, is_active, app.description, app.version, app.last_update_text, organizationId, app.website, app.order_by, app.file_format]
                let id = db.execSql(sql, params:params as Array<AnyObject>?)
            } else {
                //Update
                let sql = "update app (set name=?, url_image=?, download_link=?, category_id=?, is_active=?, desc=?, version=?, last_update=?, organization_id=?, website=?, order_by=?, file_format=? where id=? VALUES (?,?,?,?,?,?,?,?,?,?,?,?));"
                let params : [Any] = [app.name, app.url_image, app.download_link, app.category?.id, is_active, app.description, app.version, app.last_update_text, organizationId, app.id, app.website, app.order_by, app.file_format]
                let id = db.execSql(sql, params:params as Array<AnyObject>?)
            }
        }
    }
    
    func getAppsByCategory(categoryId: AnyObject) -> Array<App> {
        var apps : Array<App> = []
        let stmt = db.query("SELECT * FROM app WHERE is_active = 1 AND category_id = ? order by order_by ",params:[categoryId])
        while (db.nextRow(stmt)){
            let a = App()
            a.id = db.getInt(stmt, index: 0)
            a.name = db.getString(stmt, index: 1)
            a.url_image = db.getString(stmt, index: 2)
            a.download_link = db.getString(stmt, index: 3)
            let categoryId = db.getInt(stmt, index: 4)
            a.is_active = Bool(db.getInt(stmt, index: 5) as NSNumber)
            a.description = db.getString(stmt, index: 6)
            a.version = db.getString(stmt, index: 7)
            a.last_update = db.getDate(stmt, index: 8)
            let organizationId = db.getInt(stmt, index: 9)
            a.website = db.getString(stmt, index: 10)
            a.order_by = db.getInt(stmt, index: 11)
            a.file_format = db.getString(stmt, index: 12)

            var category = Category()
            let dbCategory = CategoryDB()
            category = dbCategory.getCategoryById(categoryId: categoryId)
            a.category = category
            
            if(organizationId>0){
                var organization = Organization()
                let dbOrganization = OrganizationDB()
                organization = dbOrganization.getOrganizationById(organizationId: organizationId)!
                a.organization = organization
            }
            apps.append(a)
        }
        db.closeStatement(stmt)
        return apps
    }
    
    func getAppsByOrganization(organizationId: AnyObject) -> Array<App> {
        var apps : Array<App> = []
        let stmt = db.query("SELECT * FROM app WHERE is_active = 1 AND organization_id = ? order by order_by ",params:[organizationId])
        while (db.nextRow(stmt)){
            let a = App()
            a.id = db.getInt(stmt, index: 0)
            a.name = db.getString(stmt, index: 1)
            a.url_image = db.getString(stmt, index: 2)
            a.download_link = db.getString(stmt, index: 3)
            let categoryId = db.getInt(stmt, index: 4)
            a.is_active = Bool(db.getInt(stmt, index: 5) as NSNumber)
            a.description = db.getString(stmt, index: 6)
            a.version = db.getString(stmt, index: 7)
            a.last_update = db.getDate(stmt, index: 8)
            let organizationId = db.getInt(stmt, index: 9)
            a.website = db.getString(stmt, index: 10)
            a.order_by = db.getInt(stmt, index: 11)
            a.file_format = db.getString(stmt, index: 12)
            
            var category = Category()
            let dbCategory = CategoryDB()
            category = dbCategory.getCategoryById(categoryId: categoryId)
            a.category = category
            
            if(organizationId>0){
                var organization = Organization()
                let dbOrganization = OrganizationDB()
                organization = dbOrganization.getOrganizationById(organizationId: organizationId)!
                a.organization = organization
            }
            apps.append(a)
        }
        db.closeStatement(stmt)
        return apps
    }

    
    func getAppById(id: AnyObject) -> App {
        var app = App()
        let stmt = db.query("SELECT * FROM app WHERE is_active = 1 AND id = ? ",params:[id])
        while (db.nextRow(stmt)){
            let a = App()
            a.id = db.getInt(stmt, index: 0)
            a.name = db.getString(stmt, index: 1)
            a.url_image = db.getString(stmt, index: 2)
            a.download_link = db.getString(stmt, index: 3)
            let categoryId = db.getInt(stmt, index: 4)
            a.is_active = Bool(db.getInt(stmt, index: 5) as NSNumber)
            a.description = db.getString(stmt, index: 6)
            a.version = db.getString(stmt, index: 7)
            a.last_update = db.getDate(stmt, index: 8)
            let organizationId = db.getInt(stmt, index: 9)
            a.website = db.getString(stmt, index: 10)
            a.order_by = db.getInt(stmt, index: 11)
            a.file_format = db.getString(stmt, index: 12)
            
            var category = Category()
            let dbCategory = CategoryDB()
            category = dbCategory.getCategoryById(categoryId: categoryId)
            a.category = category
            
            
            if(organizationId>0){
                var organization = Organization()
                let dbOrganization = OrganizationDB()
                organization = dbOrganization.getOrganizationById(organizationId: organizationId)!
                a.organization = organization
            }
            
            app = a
        }
        db.closeStatement(stmt)
        return app
    }
    
    func getAppsByLikeName(name: AnyObject) -> Array<App> {
        var apps : Array<App> = []
        let stmt = db.query("SELECT * FROM app WHERE name like ? order by order_by ",params:[name])
        while (db.nextRow(stmt)){
            let a = App()
            a.id = db.getInt(stmt, index: 0)
            a.name = db.getString(stmt, index: 1)
            a.url_image = db.getString(stmt, index: 2)
            a.download_link = db.getString(stmt, index: 3)
            let categoryId = db.getInt(stmt, index: 4)
            a.is_active = Bool(db.getInt(stmt, index: 5) as NSNumber)
            a.description = db.getString(stmt, index: 6)
            a.version = db.getString(stmt, index: 7)
            a.last_update = db.getDate(stmt, index: 8)
            let organizationId = db.getInt(stmt, index: 9)
            a.website = db.getString(stmt, index: 10)
            a.order_by = db.getInt(stmt, index: 11)
            a.file_format = db.getString(stmt, index: 12)
            
            var category = Category()
            let dbCategory = CategoryDB()
            category = dbCategory.getCategoryById(categoryId: categoryId)
            a.category = category
            
            if(organizationId>0){
                var organization = Organization()
                let dbOrganization = OrganizationDB()
                organization = dbOrganization.getOrganizationById(organizationId: organizationId)!
                a.organization = organization
            }
            
            apps.append(a)
        }
        db.closeStatement(stmt)
        return apps
    }
    
    func tableExists() -> Bool {
        var isExists : Int
        isExists = 0
        let stmt = db.query("SELECT count(*) FROM sqlite_master WHERE type = 'table' AND name = 'app' ")
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
    
    func getAllApps() -> Array<App> {
        var apps : Array<App> = []
        let stmt = db.query("SELECT * FROM app WHERE is_active = 1 order by order_by ")
        while (db.nextRow(stmt)){
            let a = App()
            a.id = db.getInt(stmt, index: 0)
            a.name = db.getString(stmt, index: 1)
            a.url_image = db.getString(stmt, index: 2)
            a.download_link = db.getString(stmt, index: 3)
            let categoryId = db.getInt(stmt, index: 4)
            a.is_active = Bool(db.getInt(stmt, index: 5) as NSNumber)
            a.description = db.getString(stmt, index: 6)
            a.version = db.getString(stmt, index: 7)
            a.last_update = db.getDate(stmt, index: 8)
            let organizationId = db.getInt(stmt, index: 9)
            a.website = db.getString(stmt, index: 10)
            a.order_by = db.getInt(stmt, index: 11)
            a.file_format = db.getString(stmt, index: 12)
            
            let dbCategory = CategoryDB()
            let category = dbCategory.getCategoryById(categoryId: categoryId)
            a.category = category
            
            if(organizationId>0){
                var organization = Organization()
                let dbOrganization = OrganizationDB()
                organization = dbOrganization.getOrganizationById(organizationId: organizationId)!
                a.organization = organization
            }

            apps.append(a)
        }
        db.closeStatement(stmt)
        return apps
    }
    
    func close(){
        self.db.close()
    }
}

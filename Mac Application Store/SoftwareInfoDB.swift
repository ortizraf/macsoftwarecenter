//
//  SoftwareInfoDB.swift
//  Mac Software Center
//
//  Created by Rafael Ortiz on 14/05/17.
//  Copyright © 2017 Nextneo. All rights reserved.
//

import Foundation

class SoftwareInfoDB {
    var db: SQLiteHelper
    
    init() {
        self.db = SQLiteHelper(database:"macapplicationstore.db")
    }
    
    func dropTable(){
        let dropSql = "drop table if exists software_info"
        db.execSql(dropSql)
    }
    
    
    func createTable(){
        let createSql = "create table if not exists software_info (id integer primary key, version text, version_build integer, date_update text, desc text, download_link text, information_link text, license_link text)"
        db.execSql(createSql)
    }
    
    func save(softwareInfo: SoftwareInfo){
        if(softwareInfo.date_update_text==nil){
            softwareInfo.date_update_text = String()
        }
        if(softwareInfo.description==nil){
            softwareInfo.description = String()
        }
        if(softwareInfo.information_link==nil){
            softwareInfo.information_link = String()
        }
        if(softwareInfo.license_link==nil){
            softwareInfo.license_link = String()
        }
        
        let sql = "insert or replace into software_info (id, version, version_build, date_update, desc, download_link, information_link, license_link) VALUES (?,?,?,?,?,?,?,?);"
        
        let params : [Any] = [softwareInfo.id, softwareInfo.version, softwareInfo.versionBuild, softwareInfo.date_update_text, softwareInfo.description, softwareInfo.download_link, softwareInfo.information_link, softwareInfo.license_link]
        let id = db.execSql(sql, params:params as Array<AnyObject>?)
    }
    
    func getLastSoftwareInfo() -> SoftwareInfo? {
        let softwareInfo = SoftwareInfo()

        let stmt = db.query("SELECT * FROM software_info order by id desc limit 1 ")
        while (db.nextRow(stmt)){
            softwareInfo.id = db.getInt(stmt, index: 0)
            softwareInfo.version = db.getString(stmt, index: 1)
            softwareInfo.versionBuild = db.getInt(stmt, index: 2)
            softwareInfo.date_update = db.getDate(stmt, index: 3)
            softwareInfo.description = db.getString(stmt, index: 4)
            softwareInfo.download_link = db.getString(stmt, index: 5)
            softwareInfo.information_link = db.getString(stmt, index: 6)
            softwareInfo.license_link = db.getString(stmt, index: 7)

        }
        db.closeStatement(stmt)
        if(softwareInfo.id == nil || softwareInfo.id == 0){
            return nil
        }

        return softwareInfo
    }


}

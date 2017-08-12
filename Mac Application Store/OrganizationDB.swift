//
//  OrganizationDB.swift
//  Mac Application Store
//
//  Created by Rafael Ortiz on 07/01/17.
//  Copyright © 2017 Nextneo. All rights reserved.
//

import Foundation

class OrganizationDB {
    var db: SQLiteHelper
    
    init() {
        self.db = SQLiteHelper(database:"macapplicationstore.db")
    }
    
    func tableExists() -> Bool {
        var isExists : Int
        isExists = 0
        let stmt = db.query("SELECT count(*) FROM sqlite_master WHERE type = 'table' AND name = 'organization' ")
        while (db.nextRow(stmt)){
            isExists = db.getInt(stmt, index: 0)
            break
        }
        if(isExists<=0){
            return false
        }
        return true
    }
    
    func dropTable(){
        let dropSql = "drop table if exists organization"
        db.execSql(dropSql)
    }
    
    
    func createTable(){
        let createSql = "create table if not exists organization (id integer primary key, name text)"
        db.execSql(createSql)
    }
    
    func save(organization: Organization){
        let sql = "insert or replace into organization (id, name) VALUES (?,?);"
        
        let params : [Any] = [organization.id, organization.name]
        let id = db.execSql(sql, params:params as Array<AnyObject>!)
    }
    
    
    func getAllOrganization() -> Array<Organization> {
        var organizations : Array<Organization> = []
        let stmt = db.query("SELECT * FROM organization ")
        while (db.nextRow(stmt)){
            let c = Organization()
            c.id = db.getInt(stmt, index: 0)
            c.name = db.getString(stmt, index: 1)
            organizations.append(c)
        }
        db.closeStatement(stmt)
        return organizations
    }
    
    func getOrganizationById(organizationId: Int) -> Organization? {
        let organization = Organization()
        if(organizationId > 0){
            let stmt = db.query("SELECT * FROM organization WHERE id = ? ",params:[organizationId as AnyObject])
            while (db.nextRow(stmt)){
                organization.id = db.getInt(stmt, index: 0)
                organization.name = db.getString(stmt, index: 1)
            }
            db.closeStatement(stmt)
            if(organization.id == nil || organization.id == 0){
                return nil
            }
        }
        return organization
    }
    
    
    
    func close(){
        self.db.close()
    }
}

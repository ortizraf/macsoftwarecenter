//
//  SQLiteObjc.h
//  Mac Application Store
//
//  Created by Rafael Ortiz on 07/01/17.
//  Copyright © 2017 Nextneo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface SQLiteObjc : NSObject

+ (void) bindText:(sqlite3_stmt *)stmt idx:(int)idx withString:(NSString*)s;

+ (NSString*) getText:(sqlite3_stmt *)stmt idx:(int)idx;

@end

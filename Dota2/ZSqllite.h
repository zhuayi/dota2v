//
//  ZSqllite.h
//  Dota2
//
//  Created by zhuayi on 14-5-25.
//  Copyright (c) 2014年 zhuayi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define DBNAME    @"Dota2.sqlite"
#define NAME      @"name"
#define AGE       @"age"
#define ADDRESS   @"address"
#define TABLENAME @"PERSONINFO"

@interface ZSqllite : NSObject
{
    sqlite3 *db; 
}

-(void) init_db;
-(void) exists_table : (NSString *) tablename;
- (BOOL)excuteSQLWithCString:(const char *)sqlCmd;
@end

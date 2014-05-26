//
//  ZSqllite.m
//  Dota2
//
//  Created by zhuayi on 14-5-25.
//  Copyright (c) 2014年 zhuayi. All rights reserved.
//

#import "ZSqllite.h"

@implementation ZSqllite


- (void) init_db
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:DBNAME];
    
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK)
    {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }
}

-(void) exists_table : (NSString *) tablename
{
    NSString * sql = [NSString stringWithFormat:@"SELECT count(*) FROM sqlite_master WHERE type='table' AND name='%@'",tablename];
    NSLog(@"sql == %@",sql);
    
    //NSString * sql2 = @"CREATE TABLE \"video\" (\"id\" INTEGER PRIMARY KEY, \"title\" VARCHAR, \"litpic\" VARCHAR);";
    [self queryAllCustomers:sql];
}

- (NSArray *)queryAllCustomers : (NSString *) sqlCmd
{
    NSMutableArray * array = [[NSMutableArray alloc] init];

    sqlite3_stmt * statement;
    int state = sqlite3_prepare_v2(db, [sqlCmd UTF8String], -1, &statement, nil);
    
    //int state = sqlite3_prepare_v2(db, sqlCmd, -1, &statement, nil);
    if (state == SQLITE_OK)
    {
        NSLog(@" >> Succeed to prepare statement. %@", sqlCmd);
    }
    NSInteger index = 0;
    while (sqlite3_step(statement) == SQLITE_ROW)
    {

        //char * cstrName = (char *)sqlite3_column_text(statement, 0);
        //char * cstrAddress = (char *)sqlite3_column_text(statement, 1);
        //int age = sqlite3_column_int(statement, 2);
        //NSString * name = [NSString stringWithCString:cstrName encoding:NSUTF8StringEncoding];
        //NSString * address = [NSString stringWithCString:cstrAddress encoding:NSUTF8StringEncoding];
        
        //KSCustomer * customer = [[KSCustomer alloc] initWith:name address:address age:age];
        
        //[array addObject:customer];
        //NSLog(@"   >> Record %d : %@ %@ %d", index++, name, address, age);
    }
    sqlite3_finalize(statement);
   // NSLog(@" >> Query %@ records.", statement);
    return array;
}

- (BOOL)excuteSQLWithCString:(const char *)sqlCmd
{
    char * errorMsg;
    int state = sqlite3_exec(db, sqlCmd, NULL, NULL, &errorMsg);
    if (state == SQLITE_OK)
    {
        NSLog(@" >> Succeed to %@", [NSString stringWithCString:sqlCmd encoding:NSUTF8StringEncoding]);
    }
    else
    {
        NSLog(@" >> Failed to %@. Error: %@",[NSString stringWithCString:sqlCmd encoding:NSUTF8StringEncoding],[NSString stringWithCString:errorMsg encoding:NSUTF8StringEncoding]);
        sqlite3_free(errorMsg);
    }
    
    return (state == SQLITE_OK);
}

//执行sql
-(void)query:(NSString *)sql
{
    NSLog(@"sql=====>%@",sql);
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库操作数据失败!");
    }
}

@end

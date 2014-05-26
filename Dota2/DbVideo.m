//
//  DbVideo.m
//  Dota2
//
//  Created by zhuayi on 14-5-25.
//  Copyright (c) 2014年 zhuayi. All rights reserved.
//

#import "DbVideo.h"

@implementation DbVideo


//连接数据库
-(void) connect
{
    self.dataPath = NSHomeDirectory();
    self.dataPath = [self.dataPath stringByAppendingPathComponent:@"Documents/Dota2.sqlite"];
    databases = [FMDatabase databaseWithPath:self.dataPath];
    BOOL res = [databases open];
    if (res == NO)
    {
        NSLog(@"打开失败");
    }
    else
    {
        NSLog(@"数据库打开成功");
    }
}


-(void)create_table_video
{
    [self connect];
    
    NSString * sql = @"CREATE TABLE  if not exists video (vid,video_title, video_pic,video_url ,status);";
    BOOL res = [databases executeUpdate:sql];
    if (res == NO)
    {
        NSLog(@"%@ === 创建失败",sql);
        //关闭数据库
    }
    else if(res==YES)
    {
        NSLog(@"创建成功");
    }
    
    [databases close];
}

-(void)create_table_video_list
{
    [self connect];
    
    NSString * sql = @"CREATE TABLE  if not exists video_list (vid,video_url ,status);";
    BOOL res = [databases executeUpdate:sql];
    if (res == NO)
    {
        NSLog(@"%@ === 创建失败",sql);
        //关闭数据库
    }
    else if(res==YES)
    {
        NSLog(@"创建成功");
    }
    
    [databases close];
}


//写入数据库
-(void) insert_video : (NSString *)vid  video_pic : (NSString *) video_pic video_title : (NSString *) video_title  video_url : (NSString *) video_url
{
    
    //先查询是否已经存在了
    NSMutableArray * array = [self fetch_video_by_videid:vid];
    NSLog(@"array ==== %@",array);
    if (array.count == 0)
    {
        [self connect];
        BOOL res = [databases executeUpdate:@"insert into video values (?,?,?,?,?)",vid, video_title, video_pic,video_url,@"0"];
        
        if (res == NO)
        {
            NSLog(@"插入失败");
        }
        
        [databases close];
    }
    
}

-(NSMutableArray * )fetch_video_by_videid : (NSString *) videoid
{
    [self connect];
    
    FMResultSet* set = [databases executeQuery:@"select * from video where vid = ?",videoid];
    
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:0];
    
    while ([set next])
    {
        
        NSArray * _array = [[NSArray alloc] initWithObjects:
                            [set stringForColumn:@"vid"],
                            [set stringForColumn:@"video_title"],
                            [set stringForColumn:@"video_pic"],
                            [set stringForColumn:@"video_url"],
                            [set stringForColumn:@"status"],
                            nil];
        [array addObject:_array];
        
    }
    [databases close];
    NSLog(@"array === %@",array);
    return array;
}


-(NSMutableArray * )fetch_video_list
{
    [self connect];
    
    FMResultSet* set = [databases executeQuery:@"select * from video "];
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:0];
    
    while ([set next])
    {
        
        NSArray * _array = [[NSArray alloc] initWithObjects:
                            [set stringForColumn:@"vid"],
                            [set stringForColumn:@"video_title"],
                            [set stringForColumn:@"video_pic"],
                            [set stringForColumn:@"video_url"],
                            [set stringForColumn:@"status"],
                            nil];
        
        [array addObject:_array];
        
    }
    [databases close];
    
    return array;
}

-(void)update_video_pic_by_vid : (NSString *) videoid video_pic : (NSString *) video_pic
{
    [self connect];
    
    BOOL res = [databases executeUpdate:@"update video set video_pic = ? where vid = ?",video_pic,videoid];
    
    if (res == NO)
    {
        NSLog(@"插入失败");
    }
    
    [databases close];
}


-(NSMutableArray * )fetch_video_list_by_videid_video_url : (NSString *) videoid video_url : (NSString *) video_url
{
    [self connect];
    
    NSLog(@"select * from video_list where vid = '%@' and video_url = '%@'",videoid,video_url);
    FMResultSet* set = [databases executeQuery:@"select * from video_list where vid = ? and video_url = ?",videoid,video_url];
    NSLog(@"query === %@",[set query]);
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:0];
    
    while ([set next])
    {
        
        NSArray * _array = [[NSArray alloc] initWithObjects:
                            [set stringForColumn:@"vid"],
                            [set stringForColumn:@"video_url"],
                            [set stringForColumn:@"status"],
                            nil];
        [array addObject:_array];
        
    }
    [databases close];
    NSLog(@"array === %@",array);
    return array;
}



//写入数据库
-(void) insert_video_list : (NSString *)vid   video_url : (NSString *) video_url
{
    
    //先查询是否已经存在了
    NSMutableArray * array = [self fetch_video_list_by_videid_video_url:vid video_url:video_url];
    if (array.count == 0)
    {
        [self connect];
        BOOL res = [databases executeUpdate:@"insert into video_list values (?,?,?)",vid, video_url,@"0"];
        
        if (res == NO)
        {
            NSLog(@"插入失败");
        }
        
        [databases close];
    }
    
}

@end

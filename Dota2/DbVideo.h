//
//  DbVideo.h
//  Dota2
//
//  Created by zhuayi on 14-5-25.
//  Copyright (c) 2014年 zhuayi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@interface DbVideo : NSObject
{
    FMDatabase * databases;
}

@property(nonatomic,strong) NSString * dataPath;

-(void)create_table_video;//创建数据库
-(void)create_table_video_list;//创建数据库

-(void) insert_video : (NSString *)vid  video_pic : (NSString *) video_pic video_title : (NSString *) video_title  video_url : (NSString *) video_url;
-(void) insert_video_list : (NSString *)vid   video_url : (NSString *) video_url;
-(NSMutableArray * )fetch_video_by_videid : (NSString *) videoid;
-(NSMutableArray * )fetch_video_list;
-(void)update_video_pic_by_vid : (NSString *) videoid video_pic : (NSString*) video_pic;
@end

//
//  ZFindTableViewController.h
//  daigou
//
//  Created by zhuayi on 5/12/14.
//  Copyright (c) 2014 zhuayi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DbVideo.h"
@interface ZFindTableViewController : ZTableViewController
{
    UIProgressView *progressView;
    double proValue;
    NSTimer *timer;
    DbVideo * database;
}

@property (nonatomic,retain) NSString * path;
@property (nonatomic,strong) NSMutableArray * videoList;
@property (assign) int  vid;
-(void) insert_video : (NSString *)vid  video_pic : (NSString *) video_pic video_title : (NSString *) video_title  video_url : (NSString *) video_url;
@end

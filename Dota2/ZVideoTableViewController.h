//
//  ZVideoTableViewController.h
//  daigou
//
//  Created by zhuayi on 5/14/14.
//  Copyright (c) 2014 zhuayi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vitamio.h"
@class ZPlayViewController;
@interface ZVideoTableViewController : ZTableViewController
{
    //NSString* videoPath;
    //UIWebView * webView;
    NSString * DetailID;
    NSString * video_title;
    
    ZPlayViewController * playbox;
}



@property(assign) int vid;

@property (nonatomic,strong) NSMutableArray * list;

@property (nonatomic,strong) UIView * VideoBox;

@property (nonatomic,retain) NSString * url;


@end

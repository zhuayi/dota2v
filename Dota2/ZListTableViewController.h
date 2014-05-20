//
//  ZListTableViewController.h
//  Dota2-Video
//
//  Created by zhuayi on 5/15/14.
//  Copyright (c) 2014 zhuayi. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ZListTableViewController : ZTableViewController
{
    
    NSString * Class_title;
    
    int page;
}

@property (nonatomic,strong) NSMutableArray * list;

@property(assign) int ClassId;

@property(assign) int HeroId;
@end

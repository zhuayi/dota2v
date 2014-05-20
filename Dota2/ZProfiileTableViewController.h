//
//  ZProfiileTableViewController.h
//  daigou
//
//  Created by zhuayi on 5/12/14.
//  Copyright (c) 2014 zhuayi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZProfiileTableViewController : ZTableViewController


@property (nonatomic,strong) NSDictionary * list;

@property (nonatomic,strong) NSMutableArray * hero_list;

@property (nonatomic,retain) NSDictionary * hero_type;

@property (nonatomic,retain) NSDictionary * filter;
@end

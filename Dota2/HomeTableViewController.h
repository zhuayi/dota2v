//
//  MainTableViewController.h
//  daigou
//
//  Created by zhuayi on 5/11/14.
//  Copyright (c) 2014 zhuayi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZModelHome;
@interface HomeTableViewController : ZTableViewController
{
    //ZModelHome * homeData;
//    
//    EGORefreshTableHeaderView *_refreshHeaderView;
//    
//    //  Reloading var should really be your tableviews datasource
//    //  Putting it here for demo purposes
//    BOOL _reloading;

}


@property (nonatomic,strong) NSMutableArray * list;



@end

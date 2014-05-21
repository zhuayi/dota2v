//
//  ZTableViewController.h
//  Dota2-Video
//
//  Created by zhuayi on 5/16/14.
//  Copyright (c) 2014 zhuayi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZModelHome.h"
@class ZModelHome;
@class MJRefreshBaseView;
@class MJRefreshHeaderView;
@class MJRefreshFooterView;

@protocol BaseControllerDelegate <NSObject>

- (void)back;

@end

@interface ZTableViewController : UITableViewController<BaseControllerDelegate>
{
    ZModelHome * homeData;
    
    MJRefreshHeaderView * header;
    MJRefreshFooterView * footer;
    
    id<BaseControllerDelegate> _baseControllerDelegate;
    
    //loding加载
    UIView *_mLoadingWaitView;
    UILabel *_mLoadingStatusLabel;
    UIActivityIndicatorView *_mLoadingActivityIndicator;
    UIImageView *_mNoNetworkImageView;
    
}
//- (id <BaseControllerDelegate>) baseControllerDelegate;

//@property (nonatomic, assign) (id)<BaseControllerDelegate> baseControllerDelegate;
@property(nonatomic,assign) id <BaseControllerDelegate> delegate;

//zhuayi 自定义回调方法,用来设置下拉刷新后的回调
- (void)doneloadingReloadTableData;
- (void)addHeaderReload : (UITableView * )tableView delegate : (id) delegate;
- (void)addFootReload : (UITableView * )tableView delegate : (id) delegate;

//*****loding加载
- (void)http_Async : (NSString *) url;
- (void)removeLoadingMaskView;
- (void)loadDataFailed;
- (void)http_result : (NSString *) responseString;
//字符串转字典
- (NSDictionary *) get_dict_by_strings: (NSString *) strings;
@property(nonatomic,strong) NSString * responseString;
@end

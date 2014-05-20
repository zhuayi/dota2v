//
//  ZTabBarViewController.h
//  weibo
//
//  Created by zhuayi on 5/8/14.
//  Copyright (c) 2014 zhuayi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTabBarViewController : UITabBarController


@property (assign) NSString * is_Top;

//button count
@property (assign) int button_count;

@property (nonatomic,strong) UIImageView *tabBarView; //自定义的覆盖原先的tarbar的控件

//背景图片
@property (assign) NSString * tabBarbackgimage ;

//按钮选中状态背景
@property (nonatomic,strong) NSString * tabBarbackgimage_select ;

//点击按钮
@property (nonatomic,strong) id target;

//点击按钮
@property (assign) int target_key;

//按钮点击
- (void) buttonClick : (id) sender;

//根据key操作按钮点击
- (void)showViewByButtonKey : (int) key;

- (id) show;

@end

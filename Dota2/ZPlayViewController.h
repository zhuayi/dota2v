//
//  ZPlayViewController.h
//  Dota2-Video
//
//  Created by zhuayi on 5/17/14.
//  Copyright (c) 2014 zhuayi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vitamio.h"
#define kBackviewDefaultRect        CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 180)
//@protocol tableviewDelegate <NSObject>
//@optional
//-(void)navigationBarHidden;
//@end

@interface ZPlayViewController : UIViewController  <VMediaPlayerDelegate>
{
    //*****************Vitamio 播放器开始
    VMediaPlayer       *mMPayer;

    long   mCurPostion;//播放时长
    long   mDuration;//总时间
    UILabel * bubbleMsgLbl; //loding状态
    UILabel * fullPosLbl; // 总时长控件
    UILabel * curPosLbl;//播放时长控件
    NSTimer            *mSyncSeekTimer;
    BOOL isShowMenu;
    NSURL * videoURL;
    NSUserDefaults * userinfo;
    BOOL is_write_time;
}

//*****************Vitamio 播放器开始
@property (nonatomic, retain) UIActivityIndicatorView * activityIndicator;
@property (nonatomic, retain) UIView    *playViewbox;
@property (nonatomic, retain) UIView    *playstatbox;
@property (nonatomic, retain) UIView    *playbgbox;
@property (nonatomic, retain) UIView    *playViewbox_click;
@property (nonatomic, strong) UIButton * play;
@property (nonatomic, retain) UIButton * full;
@property (nonatomic, retain) UIButton * play_reruns;
@property (nonatomic, strong) NSString* videoPath;
@property (nonatomic, strong) NSString* videoID;
@property (nonatomic, strong) NSString* videoTitle;
@property (nonatomic, strong) NSString* videoPic;
@property (nonatomic, strong) NSTimer* settimeout;
@property (nonatomic, strong) UISlider * slider;
@property (nonatomic, assign) BOOL progressDragging;
-(void) play_Video;
- (void) full:(UIButton *) button;
@property(nonatomic,strong) id tableviewDelegate;
//zhuayi 自定义回调方法,用来设置下拉刷新后的回调
- (void) PlayViewIsFull; //全屏时
- (void) PlayViewNoFull; //回到不全屏
- (void) SettableviewDelegate:(id) delegate;
- (void) removePlayViewbox;
- (void) reset;
@end




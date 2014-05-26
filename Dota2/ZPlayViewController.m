//
//  ZPlayViewController.m
//  Dota2-Video
//
//  Created by zhuayi on 5/17/14.
//  Copyright (c) 2014 zhuayi. All rights reserved.
//

#import "ZPlayViewController.h"
#import "ZFindTableViewController.h"
@interface ZPlayViewController ()

@end

@implementation ZPlayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //self.view.backgroundColor = [UIColor yellowColor];
        //self.view
        //self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
    }
    return self;
}
//viewwillapper
-(void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    userinfo = [NSUserDefaults standardUserDefaults];
    
    
//    float navigation_height;
//    if (IsIOS7)
//    {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//        navigation_height = 64.f;
//    }
//    else
//    {
//        navigation_height = 64.f;
//    }
    //self.view.frame = CGRectMake(0, navigation_height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - navigation_height);
    NSLog(@"self.view.frame === %@",self.view);
    // Do any additional setup after loading the view.
    
    self.playViewbox = [[UIView alloc] initWithFrame:kBackviewDefaultRect];
    self.playViewbox.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_playViewbox];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
                     UIActivityIndicatorViewStyleWhite];
    _activityIndicator.hidden = NO;
    _activityIndicator.center = self.playViewbox.center;
    
    [self.playViewbox addSubview:_activityIndicator];
    
    //添加手势
    self.playViewbox_click = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.playViewbox.frame.size.width, self.playViewbox.frame.size.height - 35)];
    //self.playViewbox_click.backgroundColor = [UIColor redColor];
    [_playViewbox addSubview:self.playViewbox_click];
//    UILabel * errorTips = [[UILabel alloc] initWithFrame:self.playViewbox_click.frame];
//    errorTips.backgroundColor = [UIColor clearColor];
//    errorTips.textColor = [UIColor whiteColor];
//    errorTips.textAlignment = NSTextAlignmentCenter;
//    errorTips.font = [UIFont systemFontOfSize:16.];
//    errorTips.text = @"视频加载失败.请检查网络...";
//    [_playViewbox addSubview:errorTips];
    
    UITapGestureRecognizer * tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showMenu)];
    [self.playViewbox_click addGestureRecognizer:tapGesture];
    
    //下载状态
    bubbleMsgLbl = [[UILabel alloc] initWithFrame:self.playViewbox_click.frame];
    bubbleMsgLbl.backgroundColor = [UIColor clearColor];
    bubbleMsgLbl.textAlignment = NSTextAlignmentCenter;
    bubbleMsgLbl.text = @"";
    bubbleMsgLbl.textColor = [UIColor whiteColor];
    bubbleMsgLbl.font = [UIFont systemFontOfSize:16.];
    [self.playViewbox_click addSubview:bubbleMsgLbl];
    
    //重播按钮
    _play_reruns = [[UIButton alloc] initWithFrame:CGRectMake((self.playViewbox_click.frame.size.width - 77 )/2, (self.playViewbox_click.frame.size.height - 77 )/2, 77, 77)];
    [_play_reruns setBackgroundImage:[UIImage imageNamed:@"scan_the_results_play"] forState:UIControlStateNormal];
    [_play_reruns addTarget:self action:@selector(play_reset:) forControlEvents:UIControlEventTouchUpInside];
    [self.playViewbox_click addSubview:_play_reruns];
    
    //增加状态条
    self.playstatbox = [[UIView alloc] initWithFrame:CGRectMake(0, self.playViewbox.frame.size.height - 35, self.playViewbox.frame.size.width, 35)];
    self.playstatbox.backgroundColor = [UIColor clearColor];
    self.playstatbox.autoresizingMask = UIViewAutoresizingNone;
    [self.playViewbox addSubview:self.playstatbox];
    NSLog(@"playstatbox === %@",self.playstatbox);
    
    
    
    //透明遮罩背景
    _playbgbox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.playstatbox.frame.size.width, 35)];
    _playbgbox.backgroundColor = [UIColor blackColor];
    _playbgbox.alpha = 0.6;
    _playbgbox.autoresizingMask = UIViewAutoresizingNone;
    [self.playstatbox addSubview:_playbgbox];
    
    //播放按钮
    _play = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 35)];
    //_play.backgroundColor = [UIColor redColor];
    _play.tag = 109;
    //_play.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [_play setImage:[UIImage imageNamed:@"player_pause"] forState:UIControlStateNormal];
    [_play setImage:[UIImage imageNamed:@"player_play"] forState:UIControlStateSelected];
    [_play addTarget:self action:@selector(play_pause:) forControlEvents:UIControlEventTouchUpInside];
    [self.playstatbox addSubview:_play];
    
    //全屏按钮
    _full = [[UIButton alloc] initWithFrame:CGRectMake(self.playViewbox.frame.size.width - 40,0, 40, 35)];
    //_full.backgroundColor = [UIColor redColor];
    _full.tag = 110;
    [_full setImage:[UIImage imageNamed:@"adFullScreen"] forState:UIControlStateNormal];
    [_full setImage:[UIImage imageNamed:@"player_fullBtn"] forState:UIControlStateSelected];
    [_full addTarget:self action:@selector(full:) forControlEvents:UIControlEventTouchUpInside];
    [self.playstatbox addSubview:_full];
    
    //播放时间
    curPosLbl = [[UILabel alloc] initWithFrame:CGRectMake(35, 8, 70, 20)];
    //curPosLbl.backgroundColor = [UIColor yellowColor];
    curPosLbl.backgroundColor = [UIColor clearColor];
    curPosLbl.text = @"00:00:00";
    curPosLbl.textColor = [UIColor whiteColor];
    curPosLbl.font = [UIFont systemFontOfSize:11.];
    [self.playstatbox addSubview:curPosLbl];
    
    //滑块
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(85, 1, 145, self.playstatbox.frame.size.height)];
    _slider.backgroundColor = [UIColor clearColor];
    _slider.minimumValue = 0;
    _slider.maximumValue = 1;
    if (IsIOS7)
    {
        [_slider setTintColor:UIColorFromRGB(0x67cb47)];
    }
    [_slider setThumbImage:[UIImage imageNamed:@"player_drag"] forState:UIControlStateHighlighted];
    [_slider setThumbImage:[UIImage imageNamed:@"player_drag"] forState:UIControlStateNormal];
    [_slider addTarget:self action:@selector(dragProgressSliderAction:) forControlEvents:UIControlEventValueChanged];
    [self.playstatbox addSubview:_slider];
    
    //总播放时间
    fullPosLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.playViewbox.frame.size.width - 40 - 20 - 30 , 8, 70, 20)];
    fullPosLbl.backgroundColor = [UIColor clearColor];
    fullPosLbl.text = @"00:00:00";
    fullPosLbl.textColor = [UIColor whiteColor];
    fullPosLbl.font = [UIFont systemFontOfSize:11.];
    [self.playstatbox addSubview:fullPosLbl];
    
    
    //右侧分享区域
//    UIView * right_share =  [[UIView alloc] initWithFrame:CGRectMake(self.playViewbox_click.frame.size.width - 40, (self.playViewbox_click.frame.size.height - 100) / 2, 30, 100)];
//    right_share.backgroundColor = [UIColor redColor];
//    [self.playViewbox addSubview:right_share];
//    
//    UIButton * downButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    downButton.backgroundColor = [UIColor yellowColor];
//    [downButton addTarget:self action:@selector(downvideo) forControlEvents:UIControlEventTouchUpInside];
//    [right_share addSubview:downButton];
    
    if (!mMPayer)
    {
        mMPayer = [VMediaPlayer sharedInstance];
        [mMPayer setupPlayerWithCarrierView:self.playViewbox withDelegate:self];
    }
    
    NSLog(@"tableviewDelegate == ===$$$$$=== = %@",_tableviewDelegate);
    
}

//下载视频
-(void) downvideo
{
    ZFindTableViewController * down = [[ZFindTableViewController alloc] init];
    [down insert_video:self.videoID video_pic:self.videoPic video_title:self.videoTitle video_url:self.videoPath];
    //NSLog(@"title == %@ ,pic ===%@ ,path=== %@, videid === %@",self.videoTitle,self.videoPic,self.videoPath,self.videoID);
}

- (void) PlayViewIsFull
{
    
}
- (void) PlayViewNoFull
{
    
}
- (void)SettableviewDelegate: (UITableView * )tableView delegate : (id) delegate
{
    self.tableviewDelegate = delegate;
}

-(void) play_Video
{
    _play_reruns.hidden = YES;
    bubbleMsgLbl.text = @"加载中...";
    [self prepareVideo];
}

//暂停
- (void) play_pause :(UIButton *) button
{
    if (button.selected == 0)
    {
        button.selected = YES;
        [mMPayer pause];
    }
    else
    {
        button.selected = NO;
        [mMPayer start];
    }
}

//滑块滑动
-(void)dragProgressSliderAction:(id)sender
{
	UISlider *sld = (UISlider *)sender;
	[mMPayer seekTo:(long)(sld.value * mDuration)];
    curPosLbl.text = [self timeToHumanString:(long)(sld.value * mDuration)];
    //记录下播放时间
    [self update_history];
}

//quanping
-(void) isfull
{
    //为了兼容IOS6 只能这么写了
    float ios_height = IOS_HEIGHT;
    
    if (!IsIOS7)
    {
        ios_height = ios_height - 20;
    }
    
    CGAffineTransform at = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
    
    at = CGAffineTransformTranslate(at, 200, 0);
    [self.playViewbox setTransform:at];
    NSLog(@"wodth === %f",IOS_WIDTH);
    
    self.playViewbox.frame = CGRectMake(0,0,IOS_WIDTH, ios_height);
    self.playViewbox_click.frame = CGRectMake(0,0,ios_height, IOS_WIDTH - 35);
    self.playstatbox.frame = CGRectMake(0,320 - 35, ios_height, 35);
    self.playbgbox.frame = CGRectMake(0,0,ios_height, 35);
    _play.frame = CGRectMake(0, 0, 40, 35);
    _full.frame = CGRectMake(ios_height - 40,0, 40, 35);
    fullPosLbl.frame = CGRectMake(ios_height - 40 - 20 - 30 , 8, 70, 20);
    _activityIndicator.center = CGPointMake(ios_height/2,IOS_WIDTH/2);
    _slider.frame =  CGRectMake(85, 1, ios_height - 175, self.playstatbox.frame.size.height);
    bubbleMsgLbl.frame = self.playViewbox_click.frame;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [_tableviewDelegate PlayViewIsFull];
}


- (void) isNotfull
{
    //self.playViewbox.frame = kBackviewDefaultRect;
    CGAffineTransform at = CGAffineTransformMakeRotation(0);
    
    at = CGAffineTransformTranslate(at, 0, 0);
    
    [self.playViewbox setTransform:at];
    
    NSLog(@"width === %f",[UIScreen mainScreen].bounds.size.height);
    
    self.playViewbox.frame = kBackviewDefaultRect;
    self.playbgbox.frame = CGRectMake(0,0,self.playViewbox.frame.size.width, 35);
    self.playstatbox.frame = CGRectMake(0,self.playViewbox.frame.size.height - 35, self.playViewbox.frame.size.width, 35);
    self.playViewbox_click.frame = CGRectMake(0,0,self.playViewbox.frame.size.width, self.playViewbox.frame.size.height - 35);
    _play.frame = CGRectMake(0, 0, 40, 35);
    _full.frame = CGRectMake(self.playViewbox.frame.size.width - 40,0, 40, 35);
    fullPosLbl.frame = CGRectMake(self.playViewbox.frame.size.width - 40 - 20 - 30 , 8, 70, 20);
    _activityIndicator.center = self.playViewbox.center;
    _slider.frame =  CGRectMake(85, 1, IOS_WIDTH - 175, self.playstatbox.frame.size.height);
    bubbleMsgLbl.frame = self.playViewbox_click.frame;
    
    [[UIApplication sharedApplication] setStatusBarHidden: NO];
    [_tableviewDelegate PlayViewNoFull];
}

//全屏
- (void) full:(UIButton *) button
{
    [UIView animateWithDuration:0.3 animations:^{
        NSLog(@"button.selected === %d",button.selected);
        if (button.selected == 1)
        {
            
            [self isNotfull];
            button.selected = NO;
            
        }
        else
        {
            [self isfull];
            button.selected = YES;
        }
        //[self syncUIStatus];
        NSLog(@"NAL 1NBV &&&& backview.frame=%@", NSStringFromCGRect(self.playstatbox.frame));
    }];
 
    NSLog(@"playstatbox ======= %@",self.playstatbox);
}

//重新播放
- (void) play_reset:(UIButton *) button
{
    [self play_Video];
}

- (void) showMenu
{
    
    if (isShowMenu)
    {
        self.playstatbox.hidden = NO;
        isShowMenu = NO;
        
    }
    else
    {
        self.playstatbox.hidden = YES;
        isShowMenu = YES;
    }
}

- (void) reset
{
    [mMPayer reset];
}

- (void) removePlayViewbox
{
    [mMPayer reset];
    [_settimeout invalidate];
	[mSyncSeekTimer invalidate];
	mSyncSeekTimer = nil;
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [mMPayer unSetupPlayer];
}
//-(void) viewWillAppear:(BOOL)animated
//{
//    
//    [mMPayer unSetupPlayer];
//}

- (void)dealloc
{
	[mMPayer unSetupPlayer];
}
//准备播放视频
-(void)prepareVideo
{
    NSLog(@"_activityIndicator  === %@",_activityIndicator);
    [_activityIndicator startAnimating];
    if(_videoPath)
    {
        //_videoPath = @"http://v.youku.com/player/getRealM3U8/vid/XNzEzMTA1OTA4/type/video.m3u8";
        //播放时不要锁屏
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        
        //_videoPath = @"http://218.249.126.47/69716648D764A848D67A2E529E/0300020D0C538142B6876508EF0033CAA1B33A-3A17-F5FF-11E0-F01F102BE4CB.flv.ts";
        videoURL = [NSURL URLWithString:_videoPath];
        
        [mMPayer setDataSource:videoURL];
        
        [mMPayer prepareAsync];
    }
}

//记录播放时间
- (void) update_history
{
    //BOOL isPlaying = [mMPayer isPlaying];
    if (!self.progressDragging)
    {
        mDuration  = [mMPayer getDuration];
        
        if (mDuration > 0)
        {
            long time = (long)(mCurPostion);
            
            [userinfo setInteger:time forKey:_videoPath];
            [userinfo synchronize];
            
            NSLog(@"开始记录时间!!!%@",[self timeToHumanString:(long)([userinfo integerForKey:_videoPath])]);
        }
        
    }
}

//播放开始
- (void)mediaPlayer:(VMediaPlayer *)player didPrepared:(id)arg
{
    //显示“暂停”两字
    //_btnPlayOrPause.selected = YES;
    // didPrepared = YES;
    //****设置播放总时间
    mDuration = [player getDuration];
    mCurPostion  = [mMPayer getCurrentPosition];
    fullPosLbl.text = [self timeToHumanString:(long)(mDuration)];
    NSLog(@"mCurPostion  %ld",mCurPostion);
    curPosLbl.text = [self timeToHumanString:(long)(mCurPostion)];
    [_activityIndicator stopAnimating];
    [player start];
    [player seekTo:[userinfo integerForKey:_videoPath]];
    _settimeout = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(update_history) userInfo:nil repeats:YES];
    mSyncSeekTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                      target:self
                                                    selector:@selector(syncUIStatus)
                                                    userInfo:nil
                                                     repeats:YES];
    

}

-(void)quicklyStopMovie
{
	[mMPayer reset];
	[mSyncSeekTimer invalidate];
    [_settimeout invalidate];
	mSyncSeekTimer = nil;
	_slider.value = 0.0;
	//self.progressSld.segments = nil;
	curPosLbl.text = @"00:00:00";
	fullPosLbl.text = @"00:00:00";
	//self.downloadRate.text = nil;
	mDuration = 0;
	mCurPostion = 0;
	//[self stopActivity];
	//[self setBtnEnableStatus:YES];
	[UIApplication sharedApplication].idleTimerDisabled = NO;
}


//播放结束
- (void)mediaPlayer:(VMediaPlayer *)player playbackComplete:(id)arg
{
    [self isNotfull];
    UIButton * button = (UIButton *)[self.playstatbox viewWithTag:110];
    button.selected = NO;
    
    [self quicklyStopMovie];
    [userinfo setInteger:0 forKey:_videoPath];
    [userinfo synchronize];
    _play_reruns.hidden = NO;
    //is_write_time = NO;
    //[userinfo setInteger:0 forKey:_videoPath];
    //[userinfo synchronize];
    //[mMPayer reset];
}

- (void)mediaPlayer:(VMediaPlayer *)player error:(id)arg
{
    //[mMPayer unSetupPlayer];
    //错误信息
    bubbleMsgLbl.text = @"视频加载失败.请检查网络...";
    [_activityIndicator stopAnimating];
    NSLog(@"VMediaPlayer Error: %@", arg);
}

//缓冲开始
- (void)mediaPlayer:(VMediaPlayer *)player bufferingStart:(id)arg
{
	self.progressDragging = YES;
	NSLog(@"NAL 2HBT &&&&&&&&&&&&&&&&.......&&&&&&&&&&&&&&&&&");
    [player pause];
    UIButton * button = (UIButton *)[self.playstatbox viewWithTag:109];
    button.selected = YES;
    bubbleMsgLbl.hidden = NO;
}

//缓冲中
- (void)mediaPlayer:(VMediaPlayer *)player bufferingUpdate:(id)arg
{
//	if (!self.bubbleMsgLbl.hidden) {
//		self.bubbleMsgLbl.text = [NSString stringWithFormat:@"Buffering... %d%%",
//								  [((NSNumber *)arg) intValue]];
//	}
    bubbleMsgLbl.text = [NSString stringWithFormat:@"加载%d%%",[((NSNumber *)arg) intValue]];
    NSLog(@"loding == %@",[NSString stringWithFormat:@"Buffering... %d%%",[((NSNumber *)arg) intValue]]);
}

//缓冲结束
- (void)mediaPlayer:(VMediaPlayer *)player bufferingEnd:(id)arg
{
    UIButton * button = (UIButton *)[self.playstatbox viewWithTag:109];
    button.selected = NO;
    bubbleMsgLbl.hidden =  YES;
	[player start];
    self.progressDragging = NO;
    
    //[self paste:_play];
}

- (void)mediaPlayer:(VMediaPlayer *)player seekComplete:(id)arg
{
    //is_write_time = YES;
    NSLog(@"arg === %@",arg);
}
- (void)mediaPlayer:(VMediaPlayer *)player notSeekable:(id)arg
{
	self.progressDragging = NO;
	NSLog(@"notSeekable=====");
}

- (void)mediaPlayer:(VMediaPlayer *)player setupPlayerPreference:(id)arg
{
	// Set buffer size, default is 1024KB(1*1024*1024).
    //	[player setBufferSize:256*1024];
	[player setBufferSize:512*1024];
    //	[player setAdaptiveStream:YES];
    
	[player setVideoQuality:VMVideoQualityHigh];
    
	//player.useCache = YES;
	//[player setCacheDirectory:[self getCacheRootDirectory]];
}

-(NSString *)timeToHumanString:(unsigned long)ms
{
    unsigned long seconds, h, m, s;
    char buff[128] = { 0 };
    NSString *nsRet = nil;
    
    seconds = ms / 1000;
    h = seconds / 3600;
    m = (seconds - h * 3600) / 60;
    s = seconds - h * 3600 - m * 60;
    snprintf(buff, sizeof(buff), "%02ld:%02ld:%02ld", h, m, s);
    nsRet = [[NSString alloc] initWithCString:buff
                                     encoding:NSUTF8StringEncoding];
    
    return nsRet;
}

//重置按钮坐标
- (void) syncUIStatus
{
    if (!self.progressDragging)
    {
        mCurPostion  = [mMPayer getCurrentPosition];
        [self.slider setValue:(float)mCurPostion/mDuration];
        fullPosLbl.text = [self timeToHumanString:(long)(mDuration)];
        curPosLbl.text = [self timeToHumanString:(long)(mCurPostion)];
    }
    
}


- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark VMediaPlayerDelegate Implement / Cache

- (void)mediaPlayer:(VMediaPlayer *)player cacheNotAvailable:(id)arg
{
	NSLog(@"NAL .... media can't cache.");
	//self.progressSld.segments = nil;
}

- (void)mediaPlayer:(VMediaPlayer *)player cacheStart:(id)arg
{
	NSLog(@"NAL 1GFC .... media caches index : %@", arg);
}

- (void)mediaPlayer:(VMediaPlayer *)player cacheUpdate:(id)arg
{
	NSArray *segs = (NSArray *)arg;
    NSLog(@"NAL .... media cacheUpdate, %d, %@", segs.count, segs);
//	if (mDuration > 0) {
//		NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
//		for (int i = 0; i < segs.count; i++) {
//			float val = (float)[segs[i] longLongValue] / mDuration;
//			[arr addObject:[NSNumber numberWithFloat:val]];
//		}
//		self.progressSld.segments = arr;
//	}
}

- (void)mediaPlayer:(VMediaPlayer *)player cacheSpeed:(id)arg
{
    NSLog(@"NAL .... media cacheSpeed: %dKB/s", [(NSNumber *)arg intValue]);
}

- (void)mediaPlayer:(VMediaPlayer *)player cacheComplete:(id)arg
{
	NSLog(@"NAL .... media cacheComplete");
	//self.progressSld.segments = @[@(0.0), @(1.0)];
}


- (NSString *)getCacheRootDirectory
{
	NSString *cache = [NSString stringWithFormat:@"%@/Library/Caches/MediasCaches", NSHomeDirectory()];
    if (![[NSFileManager defaultManager] fileExistsAtPath:cache]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cache
								  withIntermediateDirectories:YES
												   attributes:nil
														error:NULL];
    }
	return cache;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

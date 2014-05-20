//
//  ZPlayViewController.m
//  Dota2-Video
//
//  Created by zhuayi on 5/17/14.
//  Copyright (c) 2014 zhuayi. All rights reserved.
//

#import "ZPlayViewController.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    userinfo = [NSUserDefaults standardUserDefaults];
    
    
    float navigation_height;
    if (IsIOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        navigation_height = 64.f;
    }
    else
    {
        navigation_height = 44.f;
    }
    self.view.frame = CGRectMake(0, navigation_height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - navigation_height);
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
    
    UITapGestureRecognizer * tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showMenu)];
    [self.playViewbox_click addGestureRecognizer:tapGesture];
    
    NSLog(@"self.playViewbox.frame.size.height === %f",self.playViewbox.frame.size.height);
    //增加状态条
    self.playstatbox = [[UIView alloc] initWithFrame:CGRectMake(0, self.playViewbox.frame.size.height - 35, self.playViewbox.frame.size.width, 35)];
    //self.playstatbox.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
    self.playstatbox.autoresizingMask = UIViewAutoresizingNone;
    [self.playViewbox addSubview:self.playstatbox];
    
    //透明遮罩背景
    _playbgbox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.playstatbox.frame.size.width, 35)];
    _playbgbox.backgroundColor = [UIColor blackColor];
    _playbgbox.alpha = 0.6;
    _playbgbox.autoresizingMask = UIViewAutoresizingNone;
    [self.playstatbox addSubview:_playbgbox];
    
    //播放按钮
    _play = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 35)];
    //_play.backgroundColor = [UIColor redColor];
    //_play.tag = 109;
    //_play.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [_play setImage:[UIImage imageNamed:@"player_pause"] forState:UIControlStateNormal];
    [_play setImage:[UIImage imageNamed:@"player_play"] forState:UIControlStateSelected];
    [_play addTarget:self action:@selector(play_pause:) forControlEvents:UIControlEventTouchUpInside];
    [self.playstatbox addSubview:_play];
    
    //全屏按钮
    _full = [[UIButton alloc] initWithFrame:CGRectMake(self.playViewbox.frame.size.width - 40,0, 40, 35)];
    //_full.backgroundColor = [UIColor redColor];
    [_full setImage:[UIImage imageNamed:@"adFullScreen"] forState:UIControlStateNormal];
    [_full setImage:[UIImage imageNamed:@"player_fullBtn"] forState:UIControlStateSelected];
    [_full addTarget:self action:@selector(full:) forControlEvents:UIControlEventTouchUpInside];
    [self.playstatbox addSubview:_full];
    
    //播放时间
    curPosLbl = [[UILabel alloc] initWithFrame:CGRectMake(35, 8, 70, 20)];
    curPosLbl.backgroundColor = [UIColor clearColor];
    curPosLbl.text = @"";
    curPosLbl.textColor = [UIColor whiteColor];
    curPosLbl.font = [UIFont systemFontOfSize:11.];
    [self.playstatbox addSubview:curPosLbl];
    
    //总播放时间
    fullPosLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.playViewbox.frame.size.width - 40 - 20 - 30 , 8, 70, 20)];
    fullPosLbl.backgroundColor = [UIColor clearColor];
    fullPosLbl.text = @"";
    fullPosLbl.textColor = [UIColor whiteColor];
    fullPosLbl.font = [UIFont systemFontOfSize:11.];
    [self.playstatbox addSubview:fullPosLbl];
    
    if (!mMPayer)
    {
        mMPayer = [VMediaPlayer sharedInstance];
        [mMPayer setupPlayerWithCarrierView:self.playViewbox withDelegate:self];
    }
    
    NSLog(@"tableviewDelegate == ===$$$$$=== = %@",_tableviewDelegate);
    
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
//全屏
- (void) full:(UIButton *) button
{
    [UIView animateWithDuration:0.3 animations:^{
        NSLog(@"button.selected === %d",button.selected);
        if (button.selected == 1)
        {
            
            //self.playViewbox.frame = kBackviewDefaultRect;
            CGAffineTransform at = CGAffineTransformMakeRotation(0);
            
            at = CGAffineTransformTranslate(at, 0, 0);
            
            [self.playViewbox setTransform:at];
            
            NSLog(@"width === %f",[UIScreen mainScreen].bounds.size.height);
            
            self.playViewbox.frame = kBackviewDefaultRect;
            self.playbgbox.frame = CGRectMake(0,0,self.playViewbox.frame.size.width, 35);
            self.playstatbox.frame = CGRectMake(0,self.playViewbox.frame.size.height - 35, self.playViewbox.frame.size.width, 35);
            _play.frame = CGRectMake(0, 0, 40, 35);
            _full.frame = CGRectMake(self.playViewbox.frame.size.width - 40,0, 40, 35);
            fullPosLbl.frame = CGRectMake(self.playViewbox.frame.size.width - 40 - 20 - 30 , 8, 70, 20);
            _activityIndicator.center = self.playViewbox.center;
            [[UIApplication sharedApplication] setStatusBarHidden: NO];
            button.selected = NO;
            [_tableviewDelegate PlayViewNoFull];
        } else
        {
            //self.playViewbox.frame = self.view.bounds;
            
            CGAffineTransform at = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
            
            at = CGAffineTransformTranslate(at, 200, 0);
            [self.playViewbox setTransform:at];
            //[self.playbgbox setTransform:at];
            NSLog(@"wodth === %f",IOS_WIDTH);
  
            self.playViewbox.frame = CGRectMake(0,0,IOS_WIDTH, IOS_HEIGHT);
            self.playViewbox_click.frame = CGRectMake(0,0,IOS_HEIGHT, IOS_WIDTH - 35);
            self.playstatbox.frame = CGRectMake(0,320 - 35, IOS_HEIGHT, 35);
            self.playbgbox.frame = CGRectMake(0,0,IOS_HEIGHT, 35);
            _play.frame = CGRectMake(0, 0, 40, 35);
            _full.frame = CGRectMake(IOS_HEIGHT - 40,0, 40, 35);
            fullPosLbl.frame = CGRectMake(IOS_HEIGHT - 40 - 20 - 30 , 8, 70, 20);
            _activityIndicator.center = CGPointMake(IOS_HEIGHT/2,IOS_WIDTH/2);
            [[UIApplication sharedApplication] setStatusBarHidden: YES];
            [_tableviewDelegate PlayViewIsFull];
            button.selected = YES;
        }
        //[self syncUIStatus];
        NSLog(@"NAL 1NBV &&&& backview.frame=%@", NSStringFromCGRect(self.playstatbox.frame));
    }];
 
    NSLog(@"playstatbox ======= %@",self.playstatbox);
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
-(void) viewWillAppear:(BOOL)animated
{
    
    [mMPayer unSetupPlayer];
}
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
        videoURL = [NSURL URLWithString:_videoPath];
        [mMPayer setDataSource:videoURL];
        
        [mMPayer prepareAsync];
    }
}

//记录播放时间
- (void) update_history
{
    mDuration  = [mMPayer getDuration];
    long time = (long)(mCurPostion);
    
    [userinfo setInteger:time forKey:_videoPath];
    [userinfo synchronize];
    
    NSLog(@"开始记录时间!!!%@",[self timeToHumanString:(long)([userinfo integerForKey:_videoPath])]);
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


//播放结束
- (void)mediaPlayer:(VMediaPlayer *)player playbackComplete:(id)arg
{
    [player reset];
}

- (void)mediaPlayer:(VMediaPlayer *)player error:(id)arg
{
    NSLog(@"VMediaPlayer Error: %@", arg);
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
    mCurPostion  = [mMPayer getCurrentPosition];
    fullPosLbl.text = [self timeToHumanString:(long)(mDuration)];
    curPosLbl.text = [self timeToHumanString:(long)(mCurPostion)];
}


- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];

}
////********************屏幕旋转 START
////ios5
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//
//{
//    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
//}
//
////ios6
//-(NSUInteger)supportedInterfaceOrientations
//
//{
//    return UIInterfaceOrientationMaskAll;
//}
//
//- (BOOL)shouldAutorotate
//{
//    return NO;
//}
//
////********************屏幕旋转 END

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

//
//  ZTabBarViewController.m
//  weibo
//
//  Created by zhuayi on 5/8/14.
//  Copyright (c) 2014 zhuayi. All rights reserved.
//

#import "ZTabBarViewController.h"
@interface ZTabBarViewController ()
{
}
@end


@implementation ZTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.delegate = self;
}

- (void) setTabPosition : (NSString *) is_top
{
    self.is_Top = is_top;
}

- (id) show
{
    float view_y = 0.0;
    
    self.tabBar.hidden = YES;
    
    float height = [UIScreen mainScreen].bounds.size.height;
    //view_y = 22;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        height = height - 20;
    }
    
    view_y = height-49;
    NSLog(@"[UIScreen mainScreen].bounds.size.height === %f",view_y);
    
    CGRect view_postion = CGRectMake(0, view_y, [UIScreen mainScreen].bounds.size.width, 49);
    
    _tabBarView = [[UIImageView alloc] initWithFrame:view_postion];
    _tabBarView.image = [UIImage imageNamed:_tabBarbackgimage];
    //_tabBarView.frame = CGRectMake(0, 50, 320, 480);
    
    self.button_count = self.viewControllers.count;

    for (int i = 0; i < self.button_count; i++)
    {
        [_tabBarView addSubview:[self pushButtonView:self.viewControllers[i] : i]];
    }
    _tabBarView.userInteractionEnabled = YES;
    
    //_tabBarView.tag = 999;
    
    //changeViewController:btn

    [self.view addSubview:_tabBarView];
    
    if (self.selectedIndex > 0)
    {
        [self buttonClick:[self.view viewWithTag:self.selectedIndex]];
    }
    //NSLog(@"selectedIndex====%@",[self.view viewWithTag:0]);
    return self;
}

////根据key操作按钮点击
- (void)showViewByButtonKey : (int) key
{
    [self buttonClick:[self.view viewWithTag:key]];
}


//填充按钮
- (id) pushButtonView : (id) object : (int) key
{
    float gap ;
    
    gap = _tabBarView.frame.size.width / self.button_count;
    
    UIButton * button = [[UIButton alloc] init];
    button.frame = CGRectMake(gap * key, 1, gap, 49);
    [button setImage:[object tabBarItem].image forState:UIControlStateNormal];
    [button setImage:[object tabBarItem].selectedImage forState:UIControlStateDisabled];
    
    [button setBackgroundImage:[UIImage imageNamed:_tabBarbackgimage_select] forState:UIControlStateDisabled];
    
    button.adjustsImageWhenHighlighted = NO;
    button.adjustsImageWhenDisabled = YES;

    if (key == self.selectedIndex)
    {
        //NSLog(@"button_key === %d",key);
        [button setEnabled:NO];
        _target = button;
    }
    button.tag = key;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    
    
    return button;
}


//按钮点击
- (void) buttonClick : (id) sender
{
    
int tag = [sender tag];
//    
//    CATransition *myTransition= [CATransition animation];//创建CATransition
//    myTransition.duration =0.3;//持续时长0.3秒
//    myTransition.timingFunction=UIViewAnimationCurveEaseInOut;//计时函数，从头到尾的流畅度
//    myTransition.type = @"moveIn";//动画类型
//    
//    CATransition *myTransition2= [CATransition animation];//创建CATransition
//    myTransition2.duration =0.3;//持续时长0.3秒
//    myTransition2.timingFunction=UIViewAnimationCurveEaseInOut;//计时函数，从头到尾的流畅度
//    myTransition2.type = @"moveIn";//动画类型
//    
//    if (_target_key > tag)
//    {
//        myTransition.subtype= kCATransitionFromLeft;//子类型
//        myTransition2.subtype= kCATransitionFromRight;//子类型
//    }
//    else
//    {
//        myTransition2.subtype= kCATransitionFromLeft;//子类型
//        myTransition.subtype= kCATransitionFromRight;//子类型
//    }
//    
//    
//    //((UINavigationController *)[self.viewControllers objectAtIndex:[sender tag]]).view.layer;
//    
//    NSLog(@"self.navigationController == %@",[self.viewControllers objectAtIndex:tag]);
//    [((UINavigationController *)[self.viewControllers objectAtIndex:tag]).view.layer addAnimation:myTransition forKey:nil];
//    [((UINavigationController *)[self.viewControllers objectAtIndex:_target_key]).view.layer addAnimation:myTransition2 forKey:nil];
    
    self.selectedIndex = tag;
    [sender setEnabled:NO];
    if (sender != _target)
    {
        [_target setEnabled:YES];
    }
    _target_key = tag;
    _target = sender;
    //NSLog(@"%@",[self.viewControllers[[sender tag]] view]);
}

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

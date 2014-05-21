//
//  ZVideoTableViewController.m
//  daigou
//
//  Created by zhuayi on 5/14/14.
//  Copyright (c) 2014 zhuayi. All rights reserved.
//

#import "ZVideoTableViewController.h"
#import "ASIHTTPRequest.h"
#import "LeveyTabBarController.h"
#import "ZPlayViewController.h"
#import "ZModelHome.h"

@interface ZVideoTableViewController ()

@end

@implementation ZVideoTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        //self.tableView.backgroundColor = [UIColor colorWithRed:232.0f/255.0f  green:232.0f/255.0f  blue:232.0f/255.0f  alpha:1];
 
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    

    float navigation_height = 0;
    if (!IsIOS7)
    {
        navigation_height = 84.f;
    }
    playbox = [[ZPlayViewController alloc] init];
    playbox.view.frame = CGRectMake(0, navigation_height, IOS_WIDTH, 180);
    [playbox setTableviewDelegate:self];
    self.tableView.tableHeaderView = playbox.view;
  
    NSLog(@"playbox.view == %@",self.view);
    //下拉刷新
    [self addHeaderReload:self.tableView delegate:self];
    
    _baseControllerDelegate = self;
}


- (void) doneloadingReloadTableData
{
    [playbox reset];
    [self willPlay];
}

- (void)back
{
    [playbox removePlayViewbox];
}

//即将播放,加载远程信息
- (void) willPlay
{
    NSString * newid = [NSString stringWithFormat:@"%d", _vid];
    DetailID = [DETAIL_URL stringByAppendingString:newid];
    
    [self http_Async:DetailID];
}

- (void) http_result:(NSString *)responseString
{
    NSDictionary * weatherDic = [self get_dict_by_strings:responseString];
    self.title = [[weatherDic objectForKey:@"item"] objectForKey:@"video_title"];
    _list = [weatherDic objectForKey:@"top_video_list"];
    
    [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    playbox.videoPath = [[weatherDic objectForKey:@"item"] objectForKey:@"video_url"];
    
    [playbox play_Video];

}

//- (void)viewWillAppear
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.leveyTabBarController hidesTabBar:YES animated:YES];
    
    [self willPlay];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.leveyTabBarController hidesTabBar:NO animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if (section == 0 )
    {
        return 1;
    }
    return _list.count;
}


- (void) PlayViewIsFull
{
    self.tableView.tableHeaderView.frame = [UIScreen mainScreen].bounds;
    //self.tableView.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    self.tableView.scrollEnabled = NO;
}

- (void) PlayViewNoFull
{
    //self.tableView.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, 320, 180);
    NSLog(@"view === %@",self.view);
    NSLog(@"self.tableView.tableHeaderView === %@",self.tableView.tableHeaderView);
    
    self.tableView.scrollEnabled = YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d", [indexPath section],indexPath.row];//以indexPath来唯一确定cell
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

        if (indexPath.section == 0)
        {

            cell = [homeData setcelltitle: cell title:@"视频点击排行"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

        }
        else// if (indexPath.section == 2)
        {
            
            //背景
            UIImageView * imageview_bg = [[UIImageView alloc] init];
            imageview_bg.image = [UIImage imageNamed:@"home_nav_bg_cen"];
            imageview_bg.frame = CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, 130);
            [cell setBackgroundView:imageview_bg];
            cell.textLabel.text = [_list[indexPath.row] objectForKey:@"video_title"];
            cell.textLabel.font = [UIFont systemFontOfSize:13.f];
        }
    }
    
    return cell;
}


//改变行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 39;
    if  (indexPath.section   == 0)
    {
        return 180;
    }
    else
    {
        return 39;
    }
    
}

//组间距
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}


// 选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath section === %d",indexPath.section);
    if (indexPath.section == 1)
    {
        [playbox reset];
        _vid = [[_list[indexPath.row] objectForKey:@"id"]  intValue];
        [self willPlay];
    }
}

-(void) dealloc
{
    [playbox removePlayViewbox];
}
@end

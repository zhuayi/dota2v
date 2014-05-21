//
//  MainTableViewController.m
//  daigou
//
//  Created by zhuayi on 5/11/14.
//  Copyright (c) 2014 zhuayi. All rights reserved.
//

#import "HomeTableViewController.h"
#import "ZVideoTableViewController.h"
#import "ZListTableViewController.h"
@interface HomeTableViewController ()

@end

@implementation HomeTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        //self.tableView.backgroundColor = [UIColor colorWithRed:255/255.0f  green:255/255.0f  blue:255/255.0f  alpha:1];
        
        self.title = @"首页";

        
   
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //下拉刷新
    [self addHeaderReload:self.tableView delegate:self];
    [homeData getHomeTbaleList:INDEX_URL delegate:self];
    
    self.navigationItem.leftBarButtonItem.customView.hidden = YES;
    
}


- (void) doneloadingReloadTableData
{
    [homeData getHomeTbaleList:INDEX_URL delegate:self];
}

- (void) viewWillAppear:(BOOL)animated
{
    
    //取数据
    
    [self.leveyTabBarController hidesTabBar:NO animated:NO];
    //self.navigationItem.hidesBackButton = YES;
    //self.navigationItem.backBarButtonItem
}


- ( void )requestFinished:( ASIHTTPRequest *)request
{
    
    NSError *error ;
    NSData *responseData = [request responseData];
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    
    NSLog(@"weatherDic === %@",error);
    _list = [[NSMutableArray alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"幻灯片", nil],
                             [[NSArray alloc] initWithObjects:@"最近更新", nil],
                             [weatherDic objectForKey:@"new_video_list"],
                             [[NSArray alloc] initWithObjects:@"精彩集锦", nil],
                             [weatherDic objectForKey:@"jijin_index_list"],
                             [[NSArray alloc] initWithObjects:@"英雄视频", nil],
                             [weatherDic objectForKey:@"hero_list"],
                             [[NSArray alloc] initWithObjects:@"知名解说", nil],
                             [weatherDic objectForKey:@"jieshuo_video_list"],
                             [[NSArray alloc] initWithObjects:@"比赛视频", nil],
                             [weatherDic objectForKey:@"bisai_index_list"],
                             nil];
    
    [self removeLoadingMaskView];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [_list[section] count];
    if (section == 6)
    {
        return  (count/3);
    }
    else if (count > 1 && section %2  == 0 )
    {
        return  (count/2);
    }
    
    return count;
}


- (void)play:(UITapGestureRecognizer *)gesture
{
    ZVideoTableViewController * Video = [[ZVideoTableViewController alloc] init];
    
    Video.vid = gesture.view.tag;
    
    [self.navigationController pushViewController:Video animated:YES];
    
}

- (void)hero:(UITapGestureRecognizer *)gesture
{
    ZListTableViewController * list = [[ZListTableViewController alloc] init];
    
    NSLog(@"gesture.view.tag%d",gesture.view.tag);
    list.HeroId = gesture.view.tag;
    
    [self.navigationController pushViewController:list animated:YES];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    // Configure the cell...
    if (!cell)
    {
        cell = [[UITableViewCell alloc] init];
        UIImageView * imageview = [[UIImageView alloc] init];
        //顶部幻灯片
        if (indexPath.section == 0 && indexPath.row == 0)
        {
            imageview.image = [UIImage imageNamed:@"hometop"];
            imageview.frame = CGRectMake(0, 0, 320, 171);
            [cell setBackgroundView:imageview];
        }
        //最近更新
        else if  (indexPath.section  % 2 == 0)
        {
            //背景
            UIImageView * imageview_bg = [[UIImageView alloc] init];
            imageview_bg.image = [UIImage imageNamed:@"home_nav_bg_cen"];
            imageview_bg.frame = CGRectMake(0,0,320, 130);
            [cell setBackgroundView:imageview_bg];
            
            //英雄视频
            if (indexPath.section == 6)
            {
                cell = [homeData setcelllist : cell num:3 pic_height : 50  datalist:_list[indexPath.section] cellForRowAtIndexPath:indexPath delegate:self selectors:@selector(hero:)];
            }
            else
            {
                cell = [homeData setcelllist : cell num:2 pic_height : 85  datalist:_list[indexPath.section] cellForRowAtIndexPath:indexPath delegate:self selectors:@selector(play:)];
            }
        }
        else
        {
            
            cell = [homeData setcelltitle: cell title:_list[indexPath.section][0]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

//改变行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == 0 && [indexPath section] == 0)
    {
        return 171;
    }
    else if  (indexPath.section  % 2 == 0)
    {
        if (indexPath.section == 6)
        {
            return 75;
        }
        return 130;
    }
    else
    {
        return 39;
    }

}

//组间距
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    else if  (section  % 2 == 0)
    {
        return 0;
    }
    else
    {
        return 3;
    }
}

// 选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 5)
    {
        self.leveyTabBarController.selectedIndex = 2;
        //NSLog(@"加载英雄啊 %d",[indexPath section]);
        //[self play];
    }
    else if ([indexPath section] == 1 || [indexPath section] == 3 || [indexPath section] == 7  || [indexPath section] == 9 )
    {
        NSLog(@"=====加载视频列表");
        
        ZListTableViewController * list = [[ZListTableViewController alloc] init];
        
        if ([indexPath section] == 3)
        {
            list.ClassId = 2;
        }
        
        if ([indexPath section] == 7)
        {
            list.ClassId = 1;
        }
        
        if ([indexPath section] == 9)
        {
            list.ClassId = 3;
        }
        
        [self.navigationController pushViewController:list animated:YES];
    }
}





@end

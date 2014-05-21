//
//  ZProfiileTableViewController.m
//  daigou
//
//  Created by zhuayi on 5/12/14.
//  Copyright (c) 2014 zhuayi. All rights reserved.
//

#import "ZProfiileTableViewController.h"
#import "ZListTableViewController.h"
#import "ZModelHome.h"

@interface ZProfiileTableViewController ()

@end

@implementation ZProfiileTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        //self.tableView.backgroundColor = [UIColor colorWithRed:232.0f/255.0f  green:232.0f/255.0f  blue:232.0f/255.0f  alpha:1];
        
        self.title = @"英雄列表";
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [self http_Async:HERO_LIST_URL];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem.customView.hidden = YES;
}

- (void) http_result:(NSString *)http_result
{
    NSDictionary * weatherDic = [self get_dict_by_strings:http_result];
    
    _list = [weatherDic objectForKey:@"hero_list"];
    _hero_type = [weatherDic objectForKey:@"hero_type"];
    
    //设置组
    _hero_list = [NSMutableArray arrayWithCapacity:6];
    for (int i = 1 ; i<= _hero_type.count ; i++)
    {
        NSString * headername;
        headername = [NSString stringWithFormat:@"%d",i];
        [_hero_list addObject:[_hero_type objectForKey:headername]];
    }
    
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
    return _hero_type.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSString * headername = [NSString stringWithFormat:@"%d",(section+1)];
    NSLog(@"_list objectForKey:headername === %@",[_list objectForKey:headername]);
    return [[_list objectForKey:headername] count];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" ];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] init];

        UIImageView * imageview_info_1 = [[UIImageView alloc] initWithFrame:CGRectMake(5,8.5,37, 37)];
        
        SDWebImageManager * manager = [SDWebImageManager sharedManager];
        //[_list[indexPath.row] objectForKey:@"pic"]
        int key = indexPath.section+1;
        NSString * headername = [NSString stringWithFormat:@"%d",key];
        
        NSDictionary * hero_info = [_list objectForKey:headername][indexPath.row];
       
        [manager downloadWithURL:[NSURL URLWithString:[hero_info objectForKey:@"pic"]]
                         options:0
                        progress:^(NSInteger receivedSize, NSInteger expectedSize)
         {
             // progression tracking code
         }
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
         {
             if (image)
             {
                 // do something with image
                 imageview_info_1.image = image;
             }
         }];
        
        [cell addSubview:imageview_info_1];
        
        //写入TAG
        UILabel * taglist = [[UILabel alloc] initWithFrame:CGRectMake(50, 30, 200, 20)];
        taglist.text = [hero_info objectForKey:@"tag"];
        taglist.font = [UIFont systemFontOfSize:10.f];
        taglist.textColor = [UIColor colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1];
        [cell addSubview:taglist];
        
        //写入title
        UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(50, 8.5, 200, 20)];
        title.text = [hero_info objectForKey:@"name"];
        title.font = [UIFont boldSystemFontOfSize:14.f];
        [cell addSubview:title];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
//        for (int i = 0; i< 4; i++)
//        {
//            UIImageView * jineng = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jineng.png"]];
//            jineng.frame = CGRectMake(290-30*i-7*i, 15, 28, 28);
//            [cell addSubview:jineng];
//        }
    }
    return cell;
}


//改变行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}


//缩进
-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 5;
    
}
//组间距
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    view.backgroundColor = [UIColor colorWithRed:232.0f/255.0f  green:232.0f/255.0f  blue:232.0f/255.0f  alpha:1];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 329, 50)];
    label.backgroundColor = [UIColor clearColor];
    
    NSString * headername;
    headername = [NSString stringWithFormat:@"%d",(section+1)];
    
    //NSLog(@"_hero_type objectAtIndex:section === %@",[_hero_type objectForKey:headername]);
    //label.text = [_hero_type objectForKey:headername];
    label.text = _hero_list[section];
    [view addSubview:label];
    return  view;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    return @"";
}


// 选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZListTableViewController * list = [[ZListTableViewController alloc] init];
    
    NSString * headername = [NSString stringWithFormat:@"%d",(indexPath.section+1)];
    
    int heroid =  [[[_list objectForKey:headername][indexPath.row] objectForKey:@"id"] intValue];
    list.HeroId = heroid;
    [self.navigationController pushViewController:list animated:YES];
    
}
// 实现索引功能
- (NSArray *) sectionIndexTitlesForTableView : (UITableView *) tableView
{
    
    return _hero_list;
}

- (void) dealloc
{
    _list = nil;
    _hero_list = nil;
}
@end

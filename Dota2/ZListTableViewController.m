//
//  ZListTableViewController.m
//  Dota2-Video
//
//  Created by zhuayi on 5/15/14.
//  Copyright (c) 2014 zhuayi. All rights reserved.
//

#import "ZListTableViewController.h"
#import "LeveyTabBarController.h"
#import "ZVideoTableViewController.h"
@interface ZListTableViewController ()

@end

@implementation ZListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        //self.tableView.backgroundColor = [UIColor colorWithRed:232.0f/255.0f  green:232.0f/255.0f  blue:232.0f/255.0f  alpha:1];
        
        self.title = @"正在加载...";
        
        self.tableView.delegate = self;
        _list  = [NSMutableArray arrayWithCapacity:60];
    }
    return self;
}

//清除UITableView底部多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    //下拉刷新
    [self addFootReload:self.tableView delegate:self];
    
    _baseControllerDelegate = self;
}
- (void)back
{
    
}

- (NSString * ) getUrl
{
    if (page == 0)
    {
        page = 1;
    }
    NSString * _page = [NSString stringWithFormat:@"%d", page];
    
    NSString * url;
    NSString * classid;
    //NSLog(@"_ClassId === %@",_ClassId);
    if ((int)_ClassId <= 0)
    {
        url = [GET_LIST_BY_HEROID stringByReplacingOccurrencesOfString:@"#page#" withString:_page];
        classid = [NSString stringWithFormat:@"%d", _HeroId];
    }
    else
    {
        url = [GET_LIST_BY_TYPE stringByReplacingOccurrencesOfString:@"#page#" withString:_page];
        classid = [NSString stringWithFormat:@"%d", _ClassId];
    }
    
    url = [url stringByReplacingOccurrencesOfString:@"#classid#" withString:classid];
    
    return url;
}

- (void) doneloadingReloadTableData
{
    page++;
    
    [homeData getHomeTbaleList:[self getUrl] delegate:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [homeData getHomeTbaleList:[self getUrl] delegate:self];
}

//- (void)viewWillAppear
-(void)viewWillAppear:(BOOL)animated
{
    [self.leveyTabBarController hidesTabBar:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.leveyTabBarController hidesTabBar:NO animated:YES];
}

- ( void )requestFinished:( ASIHTTPRequest *)request
{
    
    NSError *error ;
    NSData *responseData = [request responseData];
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
   [self removeLoadingMaskView];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString * classid = [NSString stringWithFormat:@"%d", _ClassId];
        self.title  = [[[weatherDic objectForKey:@"video_type"] objectForKey:classid] objectForKey:@"name"];
        
        if (self.title == nil)
        {
            NSLog(@"weatherDic == %@",weatherDic);
            NSString * name  = [[weatherDic objectForKey:@"hero"]  objectForKey:@"name"];
            
            if (name != [NSNull null])
            {
                self.title = [NSString stringWithFormat:@"<<%@>>视频",name];
            }
            else
            {
                self.title = @"最新视频";
            }
            
        }

        for (NSObject * object in [weatherDic objectForKey:@"list"])
        {
            [_list addObject:object];
            //NSLog(@"object === %@",_list);
        }
        
        //_list = [weatherDic objectForKey:@"list"];
        [self.tableView reloadData];
    });

}


//返回
-(void) goback
{
    [self.navigationController popViewControllerAnimated:YES];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
//    if (section == 0)
//    {
//        return  1;
//    }
    return (_list.count/2);
}

- (void)play:(UITapGestureRecognizer *)gesture
{
    ZVideoTableViewController * Video = [[ZVideoTableViewController alloc] init];
    
    //NSLog(@"gesture.view.tag == %@",gesture.view.tag);
    Video.vid = gesture.view.tag;
    
    //[delegate.nava]
    [self.navigationController pushViewController:Video animated:YES];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    // Configure the cell...
    if (!cell)
    {
        cell = [[UITableViewCell alloc] init];
//        if (indexPath.section == 0)
//        {
//            //[cell addSubview:[self showGoBackView]];
//            cell = [homeData showGoBackView:cell titlestring:Class_title delete:self];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//        else
//        {
        
            //背景
            UIImageView * imageview_bg = [[UIImageView alloc] init];
            imageview_bg.image = [UIImage imageNamed:@"home_nav_bg_cen"];
            imageview_bg.frame = CGRectMake(0,0,320, 130);
            [cell setBackgroundView:imageview_bg];
            
            cell = [homeData setcelllist : cell num:2 pic_height: 85 datalist: _list cellForRowAtIndexPath:indexPath  delegate:self selectors:@selector(play:)];

        //}
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

//改变行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0)
//    {
//        return 35;
//    }
    return 130;
}

-(void) dealloc
{
    _list = nil;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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

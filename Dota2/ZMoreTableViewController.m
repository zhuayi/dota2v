//
//  ZMoreTableViewController.m
//  daigou
//
//  Created by zhuayi on 5/12/14.
//  Copyright (c) 2014 zhuayi. All rights reserved.
//

#import "ZMoreTableViewController.h"

@interface ZMoreTableViewController ()

@end

@implementation ZMoreTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        //self.tableView.backgroundColor = [UIColor colorWithRed:232.0f/255.0f  green:232.0f/255.0f  blue:232.0f/255.0f  alpha:1];
        
        self.title = @"关于我们";
    
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.leftBarButtonItem.customView.hidden = YES;
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 160)];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"about"]];
    
    self.tableView.tableHeaderView = view;
}

- (void) viewWillAppear:(BOOL)animated
{
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"titlebar"] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                                     [UIColor colorWithRed:255 green:255 blue:255 alpha:1], UITextAttributeTextColor,
//                                                                     [UIColor colorWithRed:255 green:255 blue:255 alpha:1], UITextAttributeTextShadowColor,
//                                                                     [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
//                                                                     nil]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    // Configure the cell...
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] init];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.backgroundColor = [UIColor whiteColor];
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"版本更新";
        }
        else
        {
            cell.textLabel.text = @"关注我们";
        }
    }
    return cell;
}

//组间距
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 160;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 160)];
//    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"about"]];
//    
//    return view;
//}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 160)];
    //view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"about"]];
    UIImageView * qq = [[UIImageView alloc] initWithFrame:CGRectMake(25, 20, 50, 57)];
    qq.image = [UIImage imageNamed:@"qq"];
    [view addSubview:qq];
    
    UIImageView * weibo = [[UIImageView alloc] initWithFrame:CGRectMake(120, 20, 71, 57)];
    weibo.image = [UIImage imageNamed:@"weibo"];
    [view addSubview:weibo];
    
    UIImageView * weixin = [[UIImageView alloc] initWithFrame:CGRectMake(230, 20, 57, 57)];
    weixin.image = [UIImage imageNamed:@"weixin"];
    [view addSubview:weixin];
    
    UILabel * copy =  [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 320, 30)];
    copy.text = @"Copyright© 2014 Dota2V.com All Rights Reserved";
    copy.font = [UIFont systemFontOfSize:10];
    copy.textColor = [UIColor colorWithRed:120./255. green:120./255. blue:120./255. alpha:1];
    copy.textAlignment = UIBaselineAdjustmentAlignCenters;
    [view addSubview:copy];
    
    return view;
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

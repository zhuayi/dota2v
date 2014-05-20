//
//  ZCategoryViewController.m
//  Dota2-Video
//
//  Created by zhuayi on 5/17/14.
//  Copyright (c) 2014 zhuayi. All rights reserved.
//

#import "ZCategoryViewController.h"
#import "ZListTableViewController.h"
@interface ZCategoryViewController ()

@end

@implementation ZCategoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"分类";
        
        self.view.backgroundColor = [UIColor whiteColor];
        //self.view.backgroundColor = [UIColor colorWithRed:227/255.0f  green:224/255.0f  blue:225./255.0f  alpha:1];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    
}

- (void) viewWillAppear:(BOOL)animated
{
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"titlebar"] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                                     [UIColor colorWithRed:255 green:255 blue:255 alpha:1], UITextAttributeTextColor,
//                                                                     [UIColor colorWithRed:255.f green:255 blue:255 alpha:1], UITextAttributeTextShadowColor,
//                                                                     [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
//                                                                     nil]];
    
    category = [[NSArray alloc] initWithObjects:
                [[NSArray alloc] initWithObjects:@"最近更新",@"0", nil],
                [[NSArray alloc] initWithObjects:@"直播视频",@"999", nil],
                [[NSArray alloc] initWithObjects:@"热门赛事",@"998", nil],
                [[NSArray alloc] initWithObjects:@"解说视频",@"1", nil],
                [[NSArray alloc] initWithObjects:@"精彩集锦",@"2", nil],
                [[NSArray alloc] initWithObjects:@"比赛视频",@"3", nil],
                [[NSArray alloc] initWithObjects:@"教学视频",@"4", nil],
                [[NSArray alloc] initWithObjects:@"战队视频",@"5", nil],
                [[NSArray alloc] initWithObjects:@"外籍高手",@"6", nil],
                nil];
    
    int height_gap = 0,width_gap = 0;;
    for (int i = 0 ; i< category.count ; i++)
    {
        //int * tag = [[category[i] objectAtIndex:1] intValue];
        int classId = [category[i][1] intValue];
        NSString * image_name = [NSString stringWithFormat:@"categoy_%d",i];
        [self.view addSubview:[self insertBox:(30 + (width_gap*51)*2) postion_y:(32 + 77 * height_gap + 30*height_gap) name :category[i][0] tag:classId image:image_name]];
        width_gap++;
        if ((i+1) %3 == 0)
        {
            height_gap++;
            width_gap = 0;
        }
    }
}

- (void) goToList:(UITapGestureRecognizer *)gesture
{
    ZListTableViewController * list = [[ZListTableViewController alloc] init];
    
    list.ClassId = gesture.view.tag;
    
    [self.navigationController pushViewController:list animated:YES];

    
    NSLog(@"tag ====%d",gesture.view.tag);
}


- (UIView *) insertBox : (int)  position_x postion_y : (int) postion_y name : (NSString *) name tag:(int) tag image : (NSString *) image
{
    UIView * box = [[UIView alloc] init];
    box.frame = CGRectMake(position_x, postion_y , 52, 77);
    
    UIImageView * icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
    icon.frame = CGRectMake(0, 0, 50, 50);
    [box addSubview:icon];
    
    NSLog(@"name ====%@",name);
    UILabel * namebox = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, 50, 27)];
    namebox.text = name;
    namebox.font = [UIFont systemFontOfSize:12.f];
    namebox.textColor = [UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:1];
    [box addSubview:namebox];

    UITapGestureRecognizer * tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToList:)];
    box.userInteractionEnabled = YES;
    box.tag = tag;
    [box addGestureRecognizer:tapGesture];

    return box;
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

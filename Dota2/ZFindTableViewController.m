//
//  ZFindTableViewController.m
//  daigou
//
//  Created by zhuayi on 5/12/14.
//  Copyright (c) 2014 zhuayi. All rights reserved.
//

#import "ZFindTableViewController.h"
#import "ASINetworkQueue.h"
@interface ZFindTableViewController ()
{
    ASINetworkQueue * networkQueue ;
}
@end

@implementation ZFindTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        
        self.title = @"下载列表";
       
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _path = [NSSearchPathForDirectoriesInDomains ( NSDocumentDirectory , NSUserDomainMask , YES ) objectAtIndex : 0 ];
    _path = [_path stringByAppendingPathComponent :@"dota2"];
    
    
    //self.vid = 2;
    
    //创建数据库
    database = [[DbVideo alloc] init];
    [database create_table_video];
    [database create_table_video_list];
    
    
    
    NSLog(@"self.videoList === %@",self.videoList);
    
    //[database insert_video:@"123" title:@"测试的" litpic:@"http://g4.ykimg.com/0100641F464FD786B3D73B068D81A64A3EECCE-5863-A375-0073-AADF81F3B8A4"];
    
 
    
    progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 100, 320, 100)];
    progressView.progressViewStyle = UIProgressViewStyleBar;
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 50.0f);
    progressView.transform = transform;
    proValue = 0;
    //timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeProgress) userInfo:nil repeats:YES];
    //[self.view addSubview:progressView];
    
    
    
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 100, 30)];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    
    //[self.view addSubview:button];
    
}

-(void) down_video_pic : (NSString *) video_pic video_id : (NSString *) video_id
{
    NSURL *url = [ NSURL URLWithString : video_pic ];
    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :url];
    
    NSString * exestr = [NSString stringWithFormat:@"%@/%@.jpg",video_id,[video_pic lastPathComponent]];
    NSString * path  = [_path stringByAppendingPathComponent : exestr];
    [request setDownloadDestinationPath :path];
    [request setUserInfo :[ NSDictionary dictionaryWithObject :exestr forKey : @"TargetPath" ]];
    [request startAsynchronous];
    [request setCompletionBlock :^( void ){
        
        //下载完毕更新图片
        [database update_video_pic_by_vid:[NSString stringWithFormat:@"%d",_vid] video_pic:exestr];
        [self.tableView reloadData];
        
    }];
    
}

-(void) mkdirPath
{
    NSError * error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:_path])
    {
        NSLog(@"%@,目录未找到,创建目录",_path);
        [[NSFileManager defaultManager] createDirectoryAtPath:_path withIntermediateDirectories:YES attributes:nil error:&error];
    }
    NSString * path = [_path stringByAppendingPathComponent : [NSString stringWithFormat:@"/%d",self.vid]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSLog(@"%@,目录未找到,创建目录",path);
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    }

    
}

-(void) insert_video : (NSString *)vid  video_pic : (NSString *) video_pic video_title : (NSString *) video_title  video_url : (NSString *) video_url
{
    self.vid = [vid intValue];
    
    [self mkdirPath];
    [database insert_video:vid video_pic:video_pic video_title:video_title video_url:video_url];
    [self down_video_pic:video_pic video_id:vid]; //下载图片
    [self Downm3u8:video_url video_id:vid]; //下载m3u8文件
    
}

-(void)viewWillAppear:(BOOL)animated
{
   
    //[self insert_video:@"2" video_pic:@"http://g1.ykimg.com/0100641F464FD50B483317068D81A60C6F345B-6C42-2219-37D3-1F11CE17173F" video_title:@"【西瓦幽鬼DOTA2】Tongfu VS WE 第三场" video_url:@"http://v.youku.com/player/getRealM3U8/vid/XNDExMjg1ODc2/type/video.m3u8"];
    self.videoList = [database fetch_video_list];
    [self.tableView reloadData];
}

-(void) resolve_m3u8 : (NSString *) path video_id : (NSString *) video_id
{
    //开始解析
    //NSLog ( @"%@ 开始解析 !" ,pathurl);
    //[NSFileHandle alloc] fileDescriptor
    NSData * reader = [NSData dataWithContentsOfFile:path];
    NSString * str = [[NSString alloc] initWithData:reader encoding:NSUTF8StringEncoding];
    //NSLog(@"====%@",str);
    
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:@"http:(.*?)\r" options:NSRegularExpressionUseUnixLineSeparators error:nil];
    
    NSArray * firstMatch = [regex matchesInString:str options:0 range:NSMakeRange(0, [str length])];;
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:str options:0 range:NSMakeRange(0, [str length])];
    
    NSLog(@"numberOfMatches === %d",numberOfMatches);
    
    if (firstMatch)
    {
        for (NSTextCheckingResult *match in firstMatch)
        {
            
            NSRange range = [match range];
            //NSLog(@"%d,%d,%@",range.location,range.length,[str substringWithRange:range]);
            NSString * rangUrl = [str substringWithRange:range];
            rangUrl = [rangUrl stringByReplacingOccurrencesOfString:@"\r" withString:@""];;
            NSLog(@"\n========================================\n%d==%@\n============================",rangUrl.length,rangUrl);
            //[database insert_video_list:video_id video_url:rangUrl];
            //[self pushDownQueue:rangUrl];
        }
        firstMatch = nil;
        //[self pushDownQueue:@"http://218.61.209.12/65711E90B41498130E59AE2ABD/0300020D0C538142B6876508EF0033CAA1B33A-3A17-F5FF-11E0-F01F102BE4CB.flv.ts?ts_start=200&ts_end=216&ts_seg_no=466"];
        NSLog(@"networkQueue go ==== start");
        //[networkQueue go];
    }
}


- (void) Downm3u8 : (NSString *) pathurl video_id : (NSString *) video_id
{
    NSURL *url = [ NSURL URLWithString : pathurl ];
    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :url];

    NSString * exestr = [NSString stringWithFormat:@"%@/%@",video_id,[pathurl lastPathComponent]];
    NSString * path  = [_path stringByAppendingPathComponent : exestr];
    
    //检查文件如果存在则不下载
    //path
    NSFileManager * filemanage = [NSFileManager defaultManager];
    if ([filemanage fileExistsAtPath:path])
    {
        [self resolve_m3u8:path video_id:video_id];
    }
    else
    {
        [request setDownloadDestinationPath :path];
        [request setUserInfo :[ NSDictionary dictionaryWithObject :exestr forKey : @"TargetPath" ]];
        [request startAsynchronous];
        [request setCompletionBlock :^( void )
         {
             //如果是m3u8则解析
             if ([[pathurl pathExtension] isEqualToString:@"m3u8"])
             {
                 [self resolve_m3u8:path video_id:video_id];
                 
             }
         }];
        
        [request setFailedBlock :^( void ){
            NSLog ( @"%@ download failed !" ,pathurl);}
         ];

    }
    
}

- (void) pushDownQueue : (NSString *) pathurl
{
    NSURL *url = [ NSURL URLWithString : pathurl ];
    NSLog ( @"%@ is push !" ,url);
    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :url];
    
    NSString * exestr = [pathurl lastPathComponent];
    NSString * path  = [_path stringByAppendingPathComponent : exestr];
    
    [request setDownloadDestinationPath :path];
    [request setUserInfo :[ NSDictionary dictionaryWithObject :exestr forKey : @"TargetPath" ]];
    
    [request setCompletionBlock :^( void )
    {
        NSLog ( @"%@ download souress !" ,pathurl);
        
    }];
    
    [request setFailedBlock :^( void ){
        NSLog ( @"%@ download failed !" ,pathurl);
    }];
    
    [networkQueue addOperation :request];

}


-(void) action
{
    _path = [ NSSearchPathForDirectoriesInDomains ( NSDocumentDirectory , NSUserDomainMask , YES ) objectAtIndex : 0 ];
    _path = [_path stringByAppendingPathComponent : @"dota2" ];
    
    NSError * error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:_path])
    {
        NSLog(@"%@,目录未找到,创建目录",_path);
        [[NSFileManager defaultManager] createDirectoryAtPath:_path withIntermediateDirectories:YES attributes:nil error:&error];
    }
    if (! networkQueue )
    {
        networkQueue = [[ ASINetworkQueue alloc ] init ];
    }
    [networkQueue setShowAccurateProgress : YES ];
    [networkQueue setDownloadProgressDelegate : progressView ];
    [networkQueue setDelegate : self ];
    
    
    NSString * url = @"http://v.youku.com/player/getRealM3U8/vid/XNzE2NzE5NDYw/type/video.m3u8";
    
    //[self Downm3u8:url];
    
    NSLog(@"error === %@",error);

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.videoList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" ];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] init];
        
        NSString * imagepath = [_path stringByAppendingPathComponent : [NSString stringWithFormat:@"%@",self.videoList[indexPath.row][2]]];
        NSLog(@"imagepath == %@",imagepath);
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 100, 59)];
        image.image = [UIImage imageWithContentsOfFile:imagepath];
        [cell.contentView addSubview:image];
        
        UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(110, 2, 190, 45)];
        title.text = self.videoList[indexPath.row][1];
        title.font = [UIFont systemFontOfSize:13];
        //自动折行设置
        title.lineBreakMode = UILineBreakModeCharacterWrap;
        title.numberOfLines = 0;
        [cell.contentView addSubview:title];
        
        
        UILabel * downStart = [[UILabel alloc] initWithFrame:CGRectMake(110, 47, 70, 20)];
        
        if ([self.videoList[indexPath.row][4] isEqualToString:@"0"])
        {
            downStart.text = @"等待开始";
        }
        else
        {
            downStart.text = @"完成:100%";
        }
        
        //downStart.textAlignment = UIBaselineAdjustmentAlignCenters;
        downStart.font = [UIFont systemFontOfSize:10];
        downStart.textColor = [UIColor colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1];
        [cell.contentView addSubview:downStart];
//        UIProgressView * progressCellView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, 320, 85)];
//        progressCellView.progressViewStyle = UIProgressViewStyleBar;
//        CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 85);
//        progressCellView.transform = transform;
//        progressCellView.alpha = .3;
//        progressCellView.progress = 0.4;
//        [cell.contentView addSubview:progressCellView];
        
        
        //cell.textLabel.text = @"视频";
    }
    
    // Configure the cell...
    
    return cell;
}

//改变行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

@end

//
//  ZModelHome.m
//  daigou
//
//  Created by zhuayi on 5/13/14.
//  Copyright (c) 2014 zhuayi. All rights reserved.
//

#import "ZModelHome.h"
#import "ASIHTTPRequest.h"
#import "ZVideoTableViewController.h"
#import "ASIDownloadCache.h"
@implementation ZModelHome



//************ ASIHTTPRequest 设置
- (void)getHomeTbaleList : (NSString *) url delegate : (id) delegatea
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL :[ NSURL URLWithString : url]];
    [request setDelegate : delegatea];
    
    [request startAsynchronous];
}

//************ ASIHTTPRequest end




- (void)play:(UITapGestureRecognizer *)gesture
{
    ZVideoTableViewController * Video = [[ZVideoTableViewController alloc] init];
    
    //NSLog(@"gesture.view.tag == %@",gesture.view.tag);
    Video.vid = gesture.view.tag;
    
    //[delegate.nava]
    //[self.navigationController pushViewController:Video animated:YES];
    
}


//设置内容区域
- (UITableViewCell *) setcelllist : (UITableViewCell *)cell num : (int ) num pic_height : (int) pic_height datalist : (NSMutableArray *) datalist cellForRowAtIndexPath:(NSIndexPath *)indexPath delegate: (id) delegate selectors : (SEL) selectors
{
    
    UIFont * font = [UIFont systemFontOfSize:11.f];
    float width , max_width = 310;//[UIScreen mainScreen].bounds.size.width;
    width = (int)max_width / num;
    width = (int)width;
    int font_height = 30;
    
    if (num == 3)
    {
        font_height = 10;
    }
    
    CGRect titleCGRect = CGRectMake(-2, pic_height+10, width-10, font_height);
    
    for (int i = 0; i < num; i++)
    {
        //点击事件
        UITapGestureRecognizer * tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:delegate action:selectors];
        NSLog(@"delegate======%@",delegate);
        //tapGesture.delegate = delegate;
        //[UIFont]
        UILabel  * labletitle = [[UILabel alloc] init];
        //咨询图
        UIImageView * imageview_info_1 = [[UIImageView alloc] initWithFrame:CGRectMake(0,5,width-10, pic_height)];
        //imageview_info_1.tag = i;
        NSDictionary *  list = datalist[i+num * indexPath.row];
        UIView * left = [[UIView alloc] init];
        
        left.userInteractionEnabled = YES;
        left.tag = [[list objectForKey:@"id"] intValue];
        //NSLog(@"aaa=%@",left.tag);

        [left addGestureRecognizer:tapGesture];
        left.frame = CGRectMake(10+width*i, 0, width-10, pic_height+font_height);
        
        NSString * pic;
        if (num == 2)
        {
            pic = [list objectForKey:@"video_pic"];
        }
        else
        {
            pic = [list objectForKey:@"pic"];
        }
        
        //懒加载图片
        NSLog(@"pic === %@",pic);
        
        SDWebImageManager * manager = [SDWebImageManager sharedManager];
        [manager downloadWithURL:[NSURL URLWithString:pic]
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
        
        [left addSubview:imageview_info_1];
        
        if (num == 2)
        {
            labletitle.text = [list objectForKey:@"video_title"];
        }
        else
        {
            labletitle.text = [list objectForKey:@"name"];
        }
        
        labletitle.frame = titleCGRect;
        labletitle.font = font;
        labletitle.textAlignment = UIBaselineAdjustmentAlignCenters;
        //自动折行设置
        labletitle.lineBreakMode = UILineBreakModeCharacterWrap;
        labletitle.numberOfLines = 0;
        
        [left addSubview:labletitle];
        
        [cell addSubview:left];
    }
    cell.textLabel.font = [UIFont fontWithName:nil size:12.f];
    
    return cell;
}

-(void)goback
{
    
}
// 返回状态栏
//-(UITableViewCell *) showGoBackView : (UITableViewCell *) cell titlestring: (NSString *) titlestring delete : (id) delete
//{
//    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 35)];
//    view.backgroundColor = [UIColor blackColor];
//    //view.alpha = 0.5;
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    [button setBackgroundImage:[UIImage imageNamed:@"preview_arrowleft_icon"] forState:UIControlStateNormal];
//    button.frame = CGRectMake(0, 0, 35, 35);
//    [button addTarget:delete action:@selector(goback) forControlEvents:UIControlEventTouchDown];
//    
//    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, [UIScreen mainScreen].bounds.size.width - 35, 35)];
//    title.text = titlestring;
//    title.font = [UIFont fontWithName:nil size:14];
//    title.textColor = [UIColor whiteColor];
//    [view addSubview:title];
//    [view addSubview:button];
//    
//    [cell addSubview:view];
//    
//    return cell;
//}

//设置tableview 标题栏
- (UITableViewCell *) setcelltitle : (UITableViewCell *) cell title:(NSString *) title
{
    //背景
    UIImageView * imageview_bg = [[UIImageView alloc] init];
    imageview_bg.image = [UIImage imageNamed:@"home_nav_bg"];
    imageview_bg.frame = CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, 39);
    [cell setBackgroundView:imageview_bg];
    
    UIImageView * imageview = [[UIImageView alloc] init];
    imageview.image = [UIImage imageNamed:@"Fav_Filter_ALL"];
    imageview.frame = CGRectMake(10, 8.5, 22, 20);
    [cell.contentView addSubview:imageview];
    cell.indentationLevel = 4;
    
    //cell.backgroundColor = [UIColor redColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14.f];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.text = title;
    return cell;
}



@end

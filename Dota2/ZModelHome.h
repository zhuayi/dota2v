//
//  ZModelHome.h
//  daigou
//
//  Created by zhuayi on 5/13/14.
//  Copyright (c) 2014 zhuayi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface ZModelHome : NSObject
{
    
}

//@property (nonatomic,strong) NSMutableArray * list;
//
@property (nonatomic,strong) id navDelegate;

@property (nonatomic,strong) NSMutableArray * list;

- (void)getHomeTbaleList : (NSString *) url  delegate : (id) delegatea;

-(void)goback;


//设置内容区域
- (UITableViewCell *) setcelllist : (UITableViewCell *)cell num : (int ) num pic_height : (int) pic_height datalist : (NSMutableArray *) datalist cellForRowAtIndexPath:(NSIndexPath *)indexPath delegate: (id) delegate selectors : (SEL) selectors;

- (void)selectors:(UITapGestureRecognizer *)gesture;

//返回条
//-(UITableViewCell *) showGoBackView : (UITableViewCell *) cell titlestring: (NSString *) titlestring delete : (id) delete;

//设置tableview 标题栏
- (UITableViewCell *) setcelltitle : (UITableViewCell *) cell title:(NSString *) title;

@end

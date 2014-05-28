//
//  ZFuntion.h
//  Dota2
//
//  Created by zhuayi on 14-5-28.
//  Copyright (c) 2014年 zhuayi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZFuntion : NSObject



//*****转换json
+(NSString *) json_decode : (NSDictionary *) array;


//获取bundle_identfier
+(NSString *) get_bundle_identfier;

//获取app版本号
+(NSString *) get_app_version;

//获取display name
+(NSString *) get_display_name;

//获取device_type, iphone or ipad
+(NSString *) get_device_type;

//获取ios版本号
+(NSString *) get_device_version;

//获取设备信息
+(NSMutableDictionary *) get_device_info_list;

//推送设备信息
-(void)push_device_info_to_server : (NSString *) post_url post_data : (NSDictionary *) post_data delegate : (id) delegate;
@end

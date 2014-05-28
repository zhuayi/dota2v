//
//  ZFuntion.m
//  Dota2
//
//  Created by zhuayi on 14-5-28.
//  Copyright (c) 2014年 zhuayi. All rights reserved.
//

#import "ZFuntion.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
@implementation ZFuntion


+(NSString *) json_decode : (NSDictionary *) array
{
    
    NSLog(@"array === %@",array);
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonText = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonText;
}


+(NSString *) get_bundle_identfier
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

+(NSString *) get_app_version
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+(NSString *) get_display_name
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

+(NSString *)get_device_type
{
    return  [UIDevice currentDevice].model;
}

+(NSString *) get_device_version
{
    return [UIDevice currentDevice].systemVersion;
}

+(NSMutableDictionary *) get_device_info_list
{
    NSMutableDictionary * device_info = [NSMutableDictionary dictionary];
    [device_info setObject:[ZFuntion get_bundle_identfier] forKey:@"bundle_identfier"];
    [device_info setObject:[ZFuntion get_app_version] forKey:@"app_version"];
    [device_info setObject:[ZFuntion get_display_name] forKey:@"display_name"];
    [device_info setObject:[ZFuntion get_device_type] forKey:@"device_type"];
    [device_info setObject:[ZFuntion get_device_version] forKey:@"device_version"];
    
    return device_info;
}

-(void)push_device_info_to_server : (NSString *) post_url post_data : (NSDictionary *) post_data delegate : (id) delegate
{
    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[ NSURL URLWithString : post_url]];
    
    for (NSString *key in post_data)
    {
        [request setPostValue:post_data[key] forKey:key];
    }
    [request setDelegate:delegate];
    [request startAsynchronous];
}

@end

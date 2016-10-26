//
//  LDParameterFilter.m
//  BLKNetworkDemo
//
//  Created by HangqiLiu on 2016/10/18.
//  Copyright © 2016年 bianlike. All rights reserved.
//

#import "LDParameterFilter.h"

@implementation LDParameterFilter

- (NSDictionary *)filterParameter:(NSDictionary *)originParameter withRequest:(BLKRequest *)request {
    
    NSMutableDictionary *currentParameter = [originParameter mutableCopy];
    currentParameter[@"unique_id"] = @"fasdfghjhgfdsdfghgfd";
    return [currentParameter copy];
}

@end

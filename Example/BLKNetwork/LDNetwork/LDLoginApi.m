//
//  LedaoLoginApi.m
//  BLKNetworkDemo
//
//  Created by HangqiLiu on 2016/10/18.
//  Copyright © 2016年 bianlike. All rights reserved.
//

#import "LDLoginApi.h"
#import "NSString+MD5.h"

@implementation LDLoginApi {
    
    NSString *_username;
    NSString *_password;
}

- (NSString *)baseUrl {
    
    return @"http://testapp.blkee.com/api";
}

- (NSString *)requestUrl {
    
    return @"user/login";
}

- (BLKRequestMethod)requestMethod {
    
    return BLKRequestMethodPOST;
}

- (NSDictionary *)parameters {
    
    return @{
             @"account":_username,
             @"passwd":[_password MD5String]
             };
}


- (instancetype)initWithUsername:(NSString *)username password:(NSString *)password {
    
    if (self = [super init]) {
        
        _username = username;
        _password = password;
    }
    return self;
}

@end

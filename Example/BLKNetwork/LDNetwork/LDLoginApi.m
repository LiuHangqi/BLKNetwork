//
//  LedaoLoginApi.m
//  BLKNetworkDemo
//
//  Created by HangqiLiu on 2016/10/18.
//  Copyright © 2016年 bianlike. All rights reserved.
//

#import "LDLoginApi.h"
#import "NSString+MD5.h"

@implementation LDLoginApi
//{
//    
//    NSString *_username;
//    NSString *_password;
//}

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
             @"account":self.username,
             @"passwd":[self.password MD5String]
             };
}


- (instancetype)initWithUsername:(NSString *)username password:(NSString *)password {
    
    if (self = [super init]) {
        
        self.username = username;
        self.password = password;
    }
    return self;
}

@end

//
//  LoginApi.m
//  BLKNetwork
//
//  Created by liu on 2017/1/16.
//  Copyright © 2017年 LiuHangqi. All rights reserved.
//

#import "LoginApi.h"

@implementation LoginApi

- (NSString *)baseUrl {
    
    return @"http://testapp.blkee.com/api";
}

- (NSString *)requestUrl {
    
    return @"user/login";
}

- (id)requestParameters {
    
    return @{@"account":@"18560123803",@"passwd":@"12345qwert"};
}

- (BLKRequestMethod)requestMethod {
    
    return BLKRequestMethodPOST;
}

- (BLKRequestSerializerType)requestSerializer {
    
    return BLKRequestSerializerTypeHTTP;
}

- (BLKResponseSerializerType)responseSerializer {
    
    return BLKResponseSerializerTypeJSON;
}

@end

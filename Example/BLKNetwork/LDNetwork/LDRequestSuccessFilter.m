//
//  LDRequestSuccessFilter.m
//  BLKNetworkDemo
//
//  Created by HangqiLiu on 2016/10/18.
//  Copyright © 2016年 bianlike. All rights reserved.
//

#import "LDRequestSuccessFilter.h"
#import "BLKRequest.h"

@implementation LDRequestSuccessFilter

- (BOOL)filterSuccessWithRequest:(BLKRequest *)request {
    
    BOOL success = NO;
    NSInteger resultCode = [request.responseObject[@"result_code"] integerValue];
    NSString *resultMessage = request.responseObject[@"result_msg"];
    NSDictionary *resultObject = request.responseObject[@"result"];
    
    if (resultCode !=100001) {
        
        NSString *errorMsg = @"";
        
        if (resultCode == 100000) {
            
            errorMsg = @"服务器异常，请重试";
        }
        else if (resultCode == 100002) {
            
            errorMsg = @"缺少参数";
        }
        else if (resultCode == 100004) {
            
            errorMsg = @"请使用POST";
        }
        else if (resultCode == 100003) {
            
            errorMsg = @"登陆过期";
            //发送登陆过期的通知
        }
        else {
            errorMsg = resultMessage;
        }
        request.responseError = [NSError errorWithDomain:@"" code:resultCode userInfo:@{NSLocalizedDescriptionKey:errorMsg}];
        request.responseObject = nil;
        success = NO;
    }
    else {
        
        request.responseObject = resultObject;
        success = YES;
    }
    
    return success;
}

@end

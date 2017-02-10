//
//  LDRequestSuccessFilter.m
//  BLKNetwork
//
//  Created by liu on 2017/1/17.
//  Copyright © 2017年 LiuHangqi. All rights reserved.
//

#import "LDRequestSuccessFilter.h"
#import "BLKBaseRequest.h"

@implementation LDRequestSuccessFilter

- (BOOL)filterSuccessWithRequest:(BLKBaseRequest *)request {
    
    BOOL success = NO;
    NSInteger resultCode = [request.responseJSONObject[@"result_code"] integerValue];
    NSString *resultMessage = request.responseJSONObject[@"result_msg"];
    NSDictionary *resultObject = request.responseJSONObject[@"result"];
    
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
        request.error = [NSError errorWithDomain:@"" code:resultCode userInfo:@{NSLocalizedDescriptionKey:errorMsg}];
        request.responseJSONObject = nil;
        success = NO;
    }
    else {
        
        request.responseJSONObject = resultObject;
        success = YES;
    }
    
    return success;

}

@end

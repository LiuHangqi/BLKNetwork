//
//  LedaoRequestManager.m
//  BLKNetworkDemo
//
//  Created by HangqiLiu on 2016/10/18.
//  Copyright © 2016年 bianlike. All rights reserved.
//

#import "LDRequestManager.h"
#import "LDLoginApi.h"
#import "LDParameterFilter.h"
#import "LDRequestSuccessFilter.h"
#import "BLKRequestQueueConfig.h"

@interface LDRequestManager ()

@property (nonatomic, strong) BLKRequestQueue *queue;
@property (nonatomic, strong) BLKRequestQueueConfig *config;

@end

@implementation LDRequestManager

+ (instancetype)sharedInstance {
    
    static LDRequestManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[LDRequestManager alloc]init];
    });
    
    return shared;
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password success:(BLKRequestCompletionBlock)success failure:(BLKRequestCompletionBlock)failure {
    
    LDLoginApi *login = [[LDLoginApi alloc]initWithUsername:username password:password];
    [self.queue startRequest:login success:success failure:failure];
}

- (BLKRequestQueue *)queue {
    
    if (!_queue) {
        
        _queue = [[BLKRequestQueue alloc]initWithConfig:self.config];
    }
    
    return _queue;
}

- (BLKRequestQueueConfig *)config {
    
    if (!_config) {
        
        _config = [[BLKRequestQueueConfig alloc]init];
        _config.parameterFilter = [[LDParameterFilter alloc]init];
        _config.requestSuccessFilter = [[LDRequestSuccessFilter alloc]init];
    }
    
    return _config;
}

@end

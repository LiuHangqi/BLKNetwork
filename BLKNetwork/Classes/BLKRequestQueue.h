//
//  BLKRequestQueue.h
//  BLKNetworkDemo
//
//  Created by HangqiLiu on 2016/10/17.
//  Copyright © 2016年 bianlike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLKRequest.h"
#import "BLKRequestQueueConfig.h"
@interface BLKRequestQueue : NSObject

@property (nonatomic, strong) BLKRequestQueueConfig *config;

- (instancetype)initWithConfig:(BLKRequestQueueConfig *)config;

- (void)startRequest:(BLKRequest *)request completion:(BLKRequestCompletionBlock)completion;

- (void)cancelRequest:(BLKRequest *)request;

- (void)cancelAllRequest;

@end

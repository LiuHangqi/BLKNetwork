//
//  BLKNetworkConfig.m
//  BLKNetworkDemo
//
//  Created by HangqiLiu on 2016/10/18.
//  Copyright © 2016年 bianlike. All rights reserved.
//

#import "BLKNetworkConfig.h"

@implementation BLKNetworkConfig

+ (instancetype)sharedConfig {
    
    static id sharedConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedConfig = [[self alloc]init];
    });
    
    return sharedConfig;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        
    }
    
    return self;
}

@end

//
//  LedaoRequestManager.h
//  BLKNetworkDemo
//
//  Created by HangqiLiu on 2016/10/18.
//  Copyright © 2016年 bianlike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLKRequestQueue.h"

@interface LDRequestManager : NSObject

+ (instancetype)sharedInstance;

- (void)loginWithUsername:(NSString *)username password:(NSString *)password success:(BLKRequestCompletionBlock)success failure:(BLKRequestCompletionBlock)failure;

@end

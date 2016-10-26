//
//  BLKViewController.m
//  BLKNetwork
//
//  Created by LiuHangqi on 10/21/2016.
//  Copyright (c) 2016 LiuHangqi. All rights reserved.
//

#import "BLKViewController.h"
#import "LDRequestManager.h"

@interface BLKViewController ()

@end

@implementation BLKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[LDRequestManager sharedInstance]loginWithUsername:@"123456" password:@"23456" success:^(__kindof BLKRequest *request) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"alert" message:request.responseObject[@"token"] preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
    } failure:^(__kindof BLKRequest *request) {
        
        NSLog(@"error:%@",request.responseError);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

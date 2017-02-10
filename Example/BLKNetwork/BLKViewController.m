//
//  BLKViewController.m
//  BLKNetwork
//
//  Created by LiuHangqi on 10/21/2016.
//  Copyright (c) 2016 LiuHangqi. All rights reserved.
//

#import "BLKViewController.h"
#import "LoginApi.h"



@interface BLKViewController ()

@end

@implementation BLKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
   
}


- (IBAction)click:(id)sender {
    
    LoginApi *login = [[LoginApi alloc]init];
    [login startWithCompletionBlockWithSuccess:^(__kindof BLKBaseRequest *request) {
    
        NSLog(@"success:%@",request);
    } failure:^(__kindof BLKBaseRequest *request) {
        
        NSLog(@"failure:%@",request.error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

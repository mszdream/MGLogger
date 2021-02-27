//
//  MGViewController.m
//  MGLogger
//
//  Created by hello on 02/27/2021.
//  Copyright (c) 2021 hello. All rights reserved.
//

#import "MGViewController.h"
#import <MGLogger/MGLogger.h>

@interface MGViewController ()

@end

@implementation MGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btnTest = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTest.frame = CGRectMake(10, 50, 100, 32);
    [btnTest setTitle:@"添加日志" forState:UIControlStateNormal];
    [btnTest addTarget:self action:@selector(btnTestClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnTest];
}

- (void)btnTestClicked:(id)sender {
    mgLog(@"1");
    mgLog(@"2");
    mgLog(@"3");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

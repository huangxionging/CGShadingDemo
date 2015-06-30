//
//  ViewController.m
//  CGShadingDemo
//
//  Created by huangxiong on 15/6/26.
//  Copyright (c) 2015年 New_Life. All rights reserved.
//

#import "ViewController.h"
#import "ShadingView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet ShadingView *shadingView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [_shadingView setBackgroundImage];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

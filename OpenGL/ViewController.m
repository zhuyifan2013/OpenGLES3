//
//  ViewController.m
//  OpenGL
//
//  Created by Yifan on 2017/4/12.
//  Copyright © 2017年 Yifan. All rights reserved.
//

#import "ViewController.h"
#import "MyGLView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:[[MyGLView alloc] initWithFrame:self.view.frame]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

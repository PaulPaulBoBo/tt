//
//  ViewController.m
//  tt
//
//  Created by l on 2021/2/23.
//

#import "ViewController.h"
#import "TRTCCloud.h"
#import "PlayViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"直播流客户端测试";
    UIButton *start = [UIButton buttonWithType:(UIButtonTypeCustom)];
    start.backgroundColor = [UIColor whiteColor];
    start.frame = self.view.frame;
    [start addTarget:self action:@selector(startAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [start setTitle:@"START" forState:(UIControlStateNormal)];
    [start setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    [self.view addSubview:start];
}

-(void)startAction:(UIButton *)sender {
    PlayViewController *vc = [[PlayViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

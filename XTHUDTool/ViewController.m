//
//  ViewController.m
//  XTHUDTool
//
//  Created by 晓童 韩 on 16/1/27.
//  Copyright © 2016年 晓童 韩. All rights reserved.
//

#import "ViewController.h"
#import "XTHUDTool.h"

#define RandomTime ((arc4random() % 5) + 0.4)

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)successDidClick:(UIButton *)button {
    switch (button.tag) {
        case 0:
            NSLog(@"成功（带详细，在view中）");
            [XTHUDTool showSuccessHUDWithMsg:@"提示成功" detailMsg:@"成功详细" inView:self.view];
            break;
        case 1:
            NSLog(@"成功（不带详细，view传入nil）");
            [XTHUDTool showSuccessHUDWithMsg:@"提示成功" inView:nil];
            break;
        default:
            break;
    }
}

- (IBAction)errorDidClick:(UIButton *)button {
    switch (button.tag) {
        case 0:
            NSLog(@"失败（带详细，在view中）");
            [XTHUDTool showErrorHUDWithMsg:@"提示失败" detailMsg:@"失败详细" inView:self.view];
            break;
        case 1:
            NSLog(@"失败（不带详细，view传入nil）");
            [XTHUDTool showErrorHUDWithMsg:@"提示失败" inView:nil];
            break;
        default:
            break;
    }
}

- (IBAction)loadingDidClick:(UIButton *)button {
    switch (button.tag) {
        case 0: {
            NSLog(@"加载（带详细，在View中）");
            [XTHUDTool showLoadingHUDWithMsg:@"提示加载" detailMsg:@"加载详细" inView:self.view];
            __weak typeof(self) weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(RandomTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [XTHUDTool hideLoadingHUDInView:weakSelf.view];
            });
            break;
        }
        case 1: {
            NSLog(@"加载（不带详细，view传入nil）");
            [XTHUDTool showLoadingHUDWithMsg:@"提示加载" inView:self.view];
            __weak typeof(self) weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(RandomTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [XTHUDTool hideLoadingHUDInView:weakSelf.view];
            });
            break;
        }
        default:
            break;
    }
}

- (IBAction)multiHUD:(UIButton *)button {
    switch (button.tag) {
        case 0: {
            NSLog(@"加载后成功");
            [XTHUDTool showLoadingHUDWithMsg:@"提示加载" detailMsg:@"加载详细" inView:self.view];
            __weak typeof(self) weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(RandomTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [XTHUDTool showSuccessHUDWithMsg:@"提示成功" detailMsg:nil inView:weakSelf.view];
            });
            break;
        }
        case 1: {
            NSLog(@"加载后失败");
            [XTHUDTool showLoadingHUDWithMsg:@"提示加载" detailMsg:@"加载详细" inView:self.view];
            __weak typeof(self) weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(RandomTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [XTHUDTool showErrorHUDWithMsg:@"提示失败" detailMsg:nil inView:weakSelf.view];
            });
            break;
        }
        case 2: {
            NSLog(@"两次显示加载并成功");
            [XTHUDTool showLoadingHUDWithMsg:@"提示加载" detailMsg:nil inView:self.view];
            int64_t time = RandomTime;
            __weak typeof(self) weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [XTHUDTool showLoadingHUDWithMsg:@"第二次提示加载" detailMsg:nil inView:weakSelf.view];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((time + RandomTime) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [XTHUDTool showSuccessHUDWithMsg:@"提示成功" detailMsg:@"提示成功详细" inView:weakSelf.view];
            });
            break;
        }
        default:
            break;
    }
}




@end

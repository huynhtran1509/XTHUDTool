//
//  ProgressHUDViewController.m
//  XTHUDTool
//
//  Created by 晓童 韩 on 16/1/28.
//  Copyright © 2016年 晓童 韩. All rights reserved.
//

#import "ProgressHUDViewController.h"
#import "XTHUDTool.h"
#import <JGProgressHUD.h>

@interface ProgressHUDViewController ()

@property (nonatomic, strong) JGProgressHUD *myHUD;

@end

@implementation ProgressHUDViewController

- (IBAction)showPieHUD:(UIButton *)button {
    switch (button.tag) {
        case 0:
            NSLog(@"饼状HUD");
            self.myHUD = [XTHUDTool showPieHUDWithMsg:@"饼状HUD" detailMsg:@"已完成0%" inView:self.view];
            [self performSelector:@selector(updateHUDWithProgress:) withObject:@(0) afterDelay:0.1f];
            break;
        case 1:
            NSLog(@"环状HUD");
            self.myHUD = [XTHUDTool showRingHUDWithMsg:@"环状HUD" detailMsg:@"已完成0%" inView:self.view];
            [self performSelector:@selector(updateHUDWithProgress:) withObject:@(0) afterDelay:0.1f];
            break;
            break;
        default:
            break;
    }
}

- (void)updateHUDWithProgress:(int)progress {
    progress += 1;
    [self.myHUD setProgress:progress/100.0f animated:NO];
    self.myHUD.detailTextLabel.text = [NSString stringWithFormat:@"%i%%已完成", progress];
    if (progress == 100) {
        dispatch_async(dispatch_get_main_queue(), ^{
            int type = arc4random() % 2;
            switch (type) {
                case 0:
                    [XTHUDTool showSuccessHUDWithMsg:@"下载成功" inView:self.view];
                    break;
                case 1:
                    [XTHUDTool showErrorHUDWithMsg:@"下载成功" inView:self.view];
                    break;
                default:
                    break;
            }
        });
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self updateHUDWithProgress:progress];
        });
    }
}

@end

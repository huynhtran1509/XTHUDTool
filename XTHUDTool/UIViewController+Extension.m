//
//  UIViewController+Extension.m
//  XTHUDTool
//
//  Created by 晓童 韩 on 16/1/28.
//  Copyright © 2016年 晓童 韩. All rights reserved.
//

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    NSArray *viewsArray = [window subviews];
    if([viewsArray count] > 0) {
        UIView *frontView = [viewsArray objectAtIndex:0];
        id nextResponder = [frontView nextResponder];
        if([nextResponder isKindOfClass:[UIViewController class]]) {
            result = nextResponder;
            NSLog(@"if:%@", result);
        } else {
            result = window.rootViewController;
            NSLog(@"else:%@", result);
        }
    }
    return result;
}

@end

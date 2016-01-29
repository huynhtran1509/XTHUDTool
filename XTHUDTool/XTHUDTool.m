//
//  XTHUDTool.m
//  XTHUDTool
//
//  Created by 晓童 韩 on 16/1/27.
//  Copyright © 2016年 晓童 韩. All rights reserved.
//

#import "XTHUDTool.h"
#import "UIViewController+Extension.h"

@implementation XTHUDTool

/**
 *  用于保存页面的每个HUD动画，用来防止重复出现HUD
 */
static NSMutableDictionary* _HUDMapping;

+ (NSMutableDictionary*)HUDMapping {
    if (!_HUDMapping) {
        _HUDMapping = [NSMutableDictionary dictionary];
    }
    return _HUDMapping;
}

#pragma mark - HUD 添加到 View
+ (JGProgressHUD *)showSuccessHUDWithMsg:(NSString*)successMsg inView:(UIView *)view {
    return [self showHUDWithMsg:successMsg detailMsg:nil inView:view HUDType:XTHUDTypeSuccess];
}

+ (JGProgressHUD *)showSuccessHUDWithMsg:(NSString*)successMsg detailMsg:(NSString*)detailMsg inView:(UIView *)view {
    return [self showHUDWithMsg:successMsg detailMsg:detailMsg inView:view HUDType:XTHUDTypeSuccess];
}

+ (JGProgressHUD *)showErrorHUDWithMsg:(NSString*)errorMsg inView:(UIView *)view {
    return [self showHUDWithMsg:errorMsg detailMsg:nil inView:view HUDType:XTHUDTypeError];
}

+ (JGProgressHUD *)showErrorHUDWithMsg:(NSString*)errorMsg detailMsg:(NSString*)detailMsg inView:(UIView *)view {
    return [self showHUDWithMsg:errorMsg detailMsg:detailMsg inView:view HUDType:XTHUDTypeError];
}

+ (JGProgressHUD *)showLoadingHUDWithMsg:(NSString*)msg inView:(UIView *)view {
    return [self showHUDWithMsg:msg detailMsg:nil inView:view HUDType:XTHUDTypeLoading];
}

+ (JGProgressHUD *)showLoadingHUDWithMsg:(NSString*)msg detailMsg:(NSString*)detailMsg inView:(UIView *)view {
    return [self showHUDWithMsg:msg detailMsg:detailMsg inView:view HUDType:XTHUDTypeLoading];
}

+ (JGProgressHUD *)showHUDWithMsg:(NSString *)msg detailMsg:(NSString *)detailMsg inView:(UIView *)view HUDType:(XTHUDType)HUDType {
    
    if (view) {
        JGProgressHUD *curProgressHUD = [[self HUDMapping] objectForKey:view.description];
        if (!curProgressHUD) {  // 如果当前的view存在加载的信息
            curProgressHUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
            [[self HUDMapping] setObject:curProgressHUD forKey:view.description];
        }
        
        if (XTHUDStyleZoom) {
            JGProgressHUDFadeZoomAnimation *animation = [JGProgressHUDFadeZoomAnimation animation];
            curProgressHUD.animation = animation;
        }
        
        if (XTHUDStyleShadow) {
            curProgressHUD.HUDView.layer.shadowColor = [UIColor blackColor].CGColor;
            curProgressHUD.HUDView.layer.shadowOffset = CGSizeZero;
            curProgressHUD.HUDView.layer.shadowOpacity = 0.4f;
            curProgressHUD.HUDView.layer.shadowRadius = 8.0f;
        }
        
        curProgressHUD.textLabel.text = msg;
        curProgressHUD.detailTextLabel.text = detailMsg;
        curProgressHUD.interactionType = JGProgressHUDInteractionTypeBlockAllTouches;
        curProgressHUD.exclusiveTouch = YES;
        curProgressHUD.indicatorView = nil;
        curProgressHUD.detailTextLabel.text = nil;
        if (detailMsg && detailMsg.length > 0) {
            curProgressHUD.detailTextLabel.text = detailMsg;
        }
        switch (HUDType) {
            case XTHUDTypeSuccess:
                curProgressHUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
                break;
            case XTHUDTypeLoading:
                curProgressHUD.indicatorView = [[JGProgressHUDIndeterminateIndicatorView alloc] initWithHUDStyle:curProgressHUD.style];
                break;
            case XTHUDTypeError:
                curProgressHUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
                break;
            case XTHUDTypePie:
                curProgressHUD.indicatorView = [[JGProgressHUDPieIndicatorView alloc] initWithHUDStyle:curProgressHUD.style];
                break;
            case XTHUDTypeRing:
                curProgressHUD.indicatorView = [[JGProgressHUDRingIndicatorView alloc] initWithHUDStyle:curProgressHUD.style];
                break;
            default:
                curProgressHUD.indicatorView = nil;
                break;
        }
        
        if (!curProgressHUD.isVisible) {
            [curProgressHUD showInView:view];
        }
        
        if (HUDType == XTHUDTypeSuccess || HUDType == XTHUDTypeError) {
            //此时可能出现transitioning为YES的情况，则无法进行dismiss
            [curProgressHUD setValue:@(NO) forKey:@"transitioning"];
            [curProgressHUD dismissAfterDelay:XTHUDStyleDuration];
            [[self HUDMapping] performSelector:@selector(removeObjectForKey:) withObject:view.description afterDelay:XTHUDStyleDuration];
        }
        return curProgressHUD;
    } else {
        UIViewController *currentVC = [UIViewController getCurrentVC];
        if (currentVC) {
            return [self showHUDWithMsg:msg detailMsg:detailMsg inView:currentVC.view HUDType:HUDType];
        }
    }
    return nil;
}



+ (void)hideLoadingHUDInView:(UIView *)view {
    if ([self HUDMapping].count <= 0) {
        return;
    }
    if (view) {
        JGProgressHUD *hud = [[self HUDMapping] objectForKey:view.description];
        if (hud) {
            [hud dismissAnimated:YES];
            [[self HUDMapping] removeObjectForKey:view.description];
        }
    } else {
        UIViewController *currentVC = [UIViewController getCurrentVC];
        if (currentVC) {
            [self hideLoadingHUDInView:currentVC.view];
        }
    }
}

+ (JGProgressHUD *)showPieHUDWithMsg:(NSString *)msg detailMsg:(NSString *)detailMsg inView:(UIView *)view {
    return [self showHUDWithMsg:msg detailMsg:detailMsg inView:view HUDType:XTHUDTypePie];
}

+ (JGProgressHUD *)showRingHUDWithMsg:(NSString *)msg detailMsg:(NSString *)detailMsg inView:(UIView *)view {
    return [self showHUDWithMsg:msg detailMsg:detailMsg inView:view HUDType:XTHUDTypeRing];
}

@end

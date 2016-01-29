//
//  TXProgressTool.m
//  txmanios
//
//  Created by 晓童 韩 on 15/12/25.
//  Copyright © 2015年 up366. All rights reserved.
//

#import "TXProgressTool.h"
#define HUDText @"请稍候..."

@implementation TXProgressTool

/**
 *  用于保存页面的每个loading动画，用来防止重复出现HUD
 */
static NSMutableDictionary* loadingViewMapping;

#pragma mark - showLoadingIfNeed
+ (JGProgressHUD*)showLoadingIfNeed:(UIView*)loadingView {
    return [self showLoadingIfNeed:loadingView hudText:HUDText];
}

+ (JGProgressHUD *)showLoadingIfNeed:(UIView *)loadingView hudText:(NSString *)text
{
    if (!loadingViewMapping) {
        loadingViewMapping = [NSMutableDictionary dictionary];
    }
    
    JGProgressHUD *curProgressHUD = nil;
    if (loadingView) {
        curProgressHUD = [loadingViewMapping objectForKey:loadingView.description];
        if (!curProgressHUD) {  // 如果当前的view存在加载的信息
            curProgressHUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
            [loadingViewMapping setObject:curProgressHUD forKey:loadingView.description];
        }
        
        curProgressHUD.textLabel.text = text;
        curProgressHUD.interactionType = JGProgressHUDInteractionTypeBlockAllTouches;
        curProgressHUD.indicatorView = [[JGProgressHUDIndeterminateIndicatorView alloc] initWithHUDStyle:curProgressHUD.style];
        
        if (!curProgressHUD.isVisible) {
            [curProgressHUD showInView:loadingView];
        }
    }
    return curProgressHUD;
}

#pragma mark - showSuccessMsgIfNeed
+ (void)showSuccessMsgIfNeed:(NSString*)successMsg onLoading:(UIView*)loadingView {
    [self showSuccessMsgIfNeed:successMsg detailMsg:nil onLoading:loadingView showSuccessMsg:YES];
}

+ (void)showSuccessMsgIfNeed:(NSString*)successMsg detailMsg:(NSString*)detailMsg onLoading:(UIView*)loadingView {
    [self showSuccessMsgIfNeed:successMsg detailMsg:detailMsg onLoading:loadingView showSuccessMsg:YES];
}

+ (void)showSuccessMsgIfNeed:(NSString *)successMsg detailMsg:(NSString *)detailMsg onLoading:(UIView *)loadingView showSuccessMsg:(BOOL)showSuccessMsg {
    [self showMsgIfNeed:successMsg detailMsg:detailMsg onLoading:loadingView showMsg:showSuccessMsg];
}

/**
 *  显示信息，后期可继续封装。同时可将类型（成功或失败或其他）也封装为参数
 *
 *  @param msg         msg
 *  @param detailMsg   detailMsg
 *  @param loadingView loadingView
 *  @param showMsg     showMsg
 */
+ (void)showMsgIfNeed:(NSString *)msg detailMsg:(NSString *)detailMsg onLoading:(UIView *)loadingView showMsg:(BOOL)showMsg {
    if (!showMsg)
        return;
    
    if (!loadingViewMapping) {
        loadingViewMapping = [NSMutableDictionary dictionary];
    }
    
    if (loadingView) {
        JGProgressHUD *curProgressHUD = [loadingViewMapping objectForKey:loadingView.description];
        if (!curProgressHUD) {  // 如果当前的view存在加载的信息
            curProgressHUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
            [loadingViewMapping setObject:curProgressHUD forKey:loadingView.description];
        }
        
        curProgressHUD.textLabel.text = msg;
        curProgressHUD.detailTextLabel.text = nil;
        curProgressHUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
        curProgressHUD.layoutChangeAnimationDuration = 0.3;
        curProgressHUD.exclusiveTouch = YES;
        if (detailMsg && detailMsg.length > 0) {
            curProgressHUD.detailTextLabel.text = detailMsg;
        }
        
        if (!curProgressHUD.isVisible)
            [curProgressHUD showInView:loadingView];
        
        __weak JGProgressHUD *weakHUD = curProgressHUD;
        __weak UIView *weakLoadingView = loadingView;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (weakHUD) {
                [weakHUD dismissAnimated:YES];
            }
            if (weakLoadingView) {
                [loadingViewMapping removeObjectForKey:weakLoadingView.description];
            }
        });
    } else {
//        UIViewController *currentVC = [TXControllerTool getCurrentVC];
//        if (currentVC) {
//            [self showMsgIfNeed:msg detailMsg:detailMsg onLoading:currentVC.view];
//        }
    }
}


#pragma mark - showErrorMsg
/**
 *  展示错误信息
 *
 *  @param errorMsg 错误信息
 *  @param hud      HUD
 */
+ (void)showErrorMsg:(NSString*)errorMsg onHUD:(JGProgressHUD*)hud showErrorMsg:(BOOL)showErrorMsg {
    if (hud) {  // 如果存在hud
        if (showErrorMsg) {
            hud.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
            hud.layoutChangeAnimationDuration = 0.3;
            
            hud.textLabel.text = errorMsg;
            hud.detailTextLabel.text = nil;
            
            __weak JGProgressHUD *weakHUD = hud;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (weakHUD) {
                    if (weakHUD.targetView)
                        [loadingViewMapping removeObjectForKey:weakHUD.targetView.description];
                    [weakHUD dismissAnimated:YES];
                }
            });
        } else {
            [hud dismissAnimated:YES];
        }
    } else if (showErrorMsg) {  // 如果不存在hud并且需要展示错误信息的话，则直接获取当前controller并且进行提示
//        UIViewController *currentVC = [TXControllerTool getCurrentVC];
//        if (currentVC) {
//            [self showErrorMsgIfNeed:errorMsg onLoading:currentVC.view];
//        }
    }
}

+ (void)showErrorMsgIfNeed:(NSString*)errorMsg onLoading:(UIView*)loadingView {
    [self showErrorMsgIfNeed:errorMsg onLoading:loadingView showErrorMsg:YES];
}

+ (void)showErrorMsgIfNeed:(NSString*)errorMsg onLoading:(UIView*)loadingView showErrorMsg:(BOOL)showErrorMsg
{
    [self showErrorMsgIfNeed:errorMsg detailMsg:nil onLoading:loadingView showErrorMsg:showErrorMsg];
}

+ (void)showErrorMsgIfNeed:(NSString*)errorMsg detailMsg:(NSString*)detailMsg onLoading:(UIView*)loadingView {
    [self showErrorMsgIfNeed:errorMsg detailMsg:detailMsg onLoading:loadingView showErrorMsg:YES];
}

+ (void)showErrorMsgIfNeed:(NSString *)errorMsg detailMsg:(NSString *)detailMsg onLoading:(UIView *)loadingView showErrorMsg:(BOOL)showErrorMsg {
    if (!showErrorMsg)
        return;
    
    if (!loadingViewMapping) {
        loadingViewMapping = [NSMutableDictionary dictionary];
    }
    
    if (loadingView) {
        JGProgressHUD *curProgressHUD = [loadingViewMapping objectForKey:loadingView.description];
        if (!curProgressHUD) {  // 如果当前的view存在加载的信息
            curProgressHUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
            [loadingViewMapping setObject:curProgressHUD forKey:loadingView.description];
        }
        
        curProgressHUD.textLabel.text = errorMsg;
        curProgressHUD.detailTextLabel.text = nil;
        curProgressHUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
        curProgressHUD.layoutChangeAnimationDuration = 0.3;
        curProgressHUD.exclusiveTouch = YES;
        if (detailMsg && detailMsg.length > 0) {
            curProgressHUD.detailTextLabel.text = detailMsg;
        }
        
        if (!curProgressHUD.isVisible)
            [curProgressHUD showInView:loadingView];
        
        __weak JGProgressHUD *weakHUD = curProgressHUD;
        __weak UIView *weakLoadingView = loadingView;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (weakHUD) {
                [weakHUD dismissAnimated:YES];
            }
            if (weakLoadingView) {
                [loadingViewMapping removeObjectForKey:weakLoadingView.description];
            }
        });
    } else {
//        UIViewController *currentVC = [TXControllerTool getCurrentVC];
//        if (currentVC) {
//            [self showErrorMsgIfNeed:errorMsg detailMsg:detailMsg onLoading:currentVC.view];
//        }
    }
    
}

#pragma mark - showMsgIfNeed
+ (void)showMsgIfNeed:(NSString*)successMsg detailMsg:(NSString*)detailMsg onLoading:(UIView*)loadingView {
    [self showMsgIfNeed:successMsg detailMsg:detailMsg onLoading:loadingView showMsg:YES];
}

+ (void)showMsgIfNeed:(NSString*)msg onLoading:(UIView*)loadingView {
    [self showMsgIfNeed:msg detailMsg:nil onLoading:nil showMsg:YES msgType:TXProgressTypeNormal];
}

/**
 *  显示信息，待封装
 *
 *  @param msg         信息
 *  @param detailMsg   细节
 *  @param loadingView
 *  @param showMsg     要不要显示
 *  @param msgType     信息类型
 */
+ (void)showMsgIfNeed:(NSString *)msg detailMsg:(NSString *)detailMsg onLoading:(UIView *)loadingView showMsg:(BOOL)showMsg  msgType:(TXProgressType)msgType {
    if (!showMsg)
        return;
    
    if (!loadingViewMapping) {
        loadingViewMapping = [NSMutableDictionary dictionary];
    }
    
    if (loadingView) {
        JGProgressHUD *curProgressHUD = [loadingViewMapping objectForKey:loadingView.description];
        if (!curProgressHUD) {  // 如果当前的view存在加载的信息
            curProgressHUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
            [loadingViewMapping setObject:curProgressHUD forKey:loadingView.description];
        }
        
        curProgressHUD.textLabel.text = msg;
        curProgressHUD.detailTextLabel.text = nil;
        curProgressHUD.layoutChangeAnimationDuration = 0.3;
        curProgressHUD.exclusiveTouch = YES;
        switch (msgType) {
            case TXProgressTypeSuccess:
                curProgressHUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
                break;
            case TXProgressTypeLoading:
                curProgressHUD.indicatorView = [[JGProgressHUDIndeterminateIndicatorView alloc] init];
                break;
            case TXProgressTypeError:
                curProgressHUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
                break;
            case TXProgressTypePie:
                curProgressHUD.indicatorView = [[JGProgressHUDPieIndicatorView alloc] init];
                break;
            default:
                curProgressHUD.indicatorView = nil;
                break;
        }
        
        if (detailMsg && detailMsg.length > 0) {
            curProgressHUD.detailTextLabel.text = detailMsg;
        }
        
        if (!curProgressHUD.isVisible)
            [curProgressHUD showInView:loadingView];
        
        __weak JGProgressHUD *weakHUD = curProgressHUD;
        __weak UIView *weakLoadingView = loadingView;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (weakHUD) {
                [weakHUD dismissAnimated:YES];
            }
            if (weakLoadingView) {
                [loadingViewMapping removeObjectForKey:weakLoadingView.description];
            }
        });
    } else {
//        UIViewController *currentVC = [TXControllerTool getCurrentVC];
//        if (currentVC) {
//            [self showMsgIfNeed:msg detailMsg:detailMsg onLoading:currentVC.view];
//        }
    }
}

//#pragma mark - 
//+ (JGProgressHUD *)showPieHUDIfNeed:(NSString *)errorMsg detailMsg:(NSString *)detailMsg onLoading:(UIView *)loadingView showErrorMsg:(BOOL)showErrorMsg
//{
//    if (!loadingViewMapping) {
//        loadingViewMapping = [NSMutableDictionary dictionary];
//    }
//    
//    JGProgressHUD *curProgressHUD = nil;
//    if (loadingView) {
//        curProgressHUD = [loadingViewMapping objectForKey:loadingView.description];
//        if (!curProgressHUD) {  // 如果当前的view存在加载的信息
//            curProgressHUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
//            [loadingViewMapping setObject:curProgressHUD forKey:loadingView.description];
//        }
//        
//        curProgressHUD.textLabel.text = text;
//        curProgressHUD.interactionType = JGProgressHUDInteractionTypeBlockAllTouches;
//        curProgressHUD.indicatorView = [[JGProgressHUDIndeterminateIndicatorView alloc] initWithHUDStyle:curProgressHUD.style];
//        
//        if (!curProgressHUD.isVisible) {
//            [curProgressHUD showInView:loadingView];
//        }
//    }
//    return curProgressHUD;
//
//}

#pragma mark - hideLoadingViewIfNeed
+ (void)hideLoadingViewIfNeed:(UIView*)toLoadingView {
    if (loadingViewMapping && toLoadingView) {
        JGProgressHUD *hud = [loadingViewMapping objectForKey:toLoadingView.description];
        if (hud) {
            [hud dismissAnimated:YES];
            [loadingViewMapping removeObjectForKey:toLoadingView.description];
        }
    }
}
@end

//
//  TXProgressTool.h
//  txmanios
//
//  Created by 晓童 韩 on 15/12/25.
//  Copyright © 2015年 up366. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JGProgressHUD.h>

typedef NS_ENUM (NSUInteger, TXProgressType){
    TXProgressTypeLoading = 0, //加载中
    TXProgressTypeSuccess = 1, //成功
    TXProgressTypeError = 2, //失败
    TXProgressTypeNormal = 3, //信息
    TXProgressTypePie = 4, //饼状提示
    //其他待定
};

@interface TXProgressTool : NSObject

/**
 *  如果需要展示loading的话则进行展示
 *
 *  @param loadingView 需要展示至那个view上
 */
+ (JGProgressHUD*)showLoadingIfNeed:(UIView*)loadingView;
+ (JGProgressHUD*)showLoadingIfNeed:(UIView*)loadingView hudText:(NSString*)text;

/**
 *  如果需要展示错误信息
 *
 *  @param errorMsg    错误信息字符串
 *  @param loadingView 需要展示至那个view上
 */
+ (void)showErrorMsgIfNeed:(NSString*)errorMsg onLoading:(UIView*)loadingView;
+ (void)showErrorMsgIfNeed:(NSString*)errorMsg detailMsg:(NSString*)detailMsg onLoading:(UIView*)loadingView;
+ (void)showErrorMsg:(NSString*)errorMsg onHUD:(JGProgressHUD*)hud showErrorMsg:(BOOL)showErrorMsg;
+ (void)showErrorMsgIfNeed:(NSString*)errorMsg onLoading:(UIView*)loadingView showErrorMsg:(BOOL)showErrorMsg;

/**
 *  显示成功信息
 *
 *  @param successMsg  成功信息字符串
 *  @param loadingView 需要展示至那个view上
 */
+ (void)showSuccessMsgIfNeed:(NSString*)successMsg onLoading:(UIView*)loadingView;
+ (void)showSuccessMsgIfNeed:(NSString*)successMsg detailMsg:(NSString*)detailMsg onLoading:(UIView*)loadingView;

/**
 *  展示信息
 *
 *  @param successMsg
 *  @param loadingView
 */
+ (void)showMsgIfNeed:(NSString*)msg onLoading:(UIView*)loadingView;

/**
 *  隐藏loading的动画
 *
 *  @param toLoadingView loading所在的view
 */
+ (void)hideLoadingViewIfNeed:(UIView*)toLoadingView;

@end

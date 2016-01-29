//
//  XTHUDTool.h
//  XTHUDTool
//
//  Created by 晓童 韩 on 16/1/27.
//  Copyright © 2016年 晓童 韩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JGProgressHUD.h>

/**
 *  是否显示放大缩小效果
 */
static const BOOL XTHUDStyleZoom = YES;

/**
 *  阴影效果
 */
static const BOOL XTHUDStyleShadow = YES;

/**
 *  背景蒙版
 */
static const BOOL XTHUDStyleDim = YES;

/**
 *  持续时间
 */
static const float XTHUDStyleDuration = 1.0f;

typedef NS_ENUM (NSUInteger, XTHUDType){
    XTHUDTypeLoading = 0, //加载中
    XTHUDTypeSuccess = 1, //成功
    XTHUDTypeError = 2, //失败
    XTHUDTypeNormal = 3, //信息
    XTHUDTypePie = 4, //饼状提示
    XTHUDTypeRing = 5,
    //其他待定
};

@interface XTHUDTool : NSObject

#pragma mark - 成功
/**
 *  显示成功信息
 *
 *  @param successMsg 成功信息
 *  @param view       要展示的view，若为nil，则展示到当前控制器最上方的view
 */
+ (JGProgressHUD *)showSuccessHUDWithMsg:(NSString*)successMsg inView:(UIView *)view;
+ (JGProgressHUD *)showSuccessHUDWithMsg:(NSString*)successMsg detailMsg:(NSString*)detailMsg inView:(UIView *)view;

#pragma mark - 失败
+ (JGProgressHUD *)showErrorHUDWithMsg:(NSString*)errorMsg inView:(UIView *)view;
+ (JGProgressHUD *)showErrorHUDWithMsg:(NSString*)errorMsg detailMsg:(NSString*)detailMsg inView:(UIView *)view;

#pragma mark - 加载中
+ (JGProgressHUD *)showLoadingHUDWithMsg:(NSString*)msg inView:(UIView *)view;
+ (JGProgressHUD *)showLoadingHUDWithMsg:(NSString*)msg detailMsg:(NSString*)detailMsg inView:(UIView *)view;

#pragma mark - 饼状及环状
+ (JGProgressHUD *)showPieHUDWithMsg:(NSString *)msg detailMsg:(NSString *)detailMsg inView:(UIView *)view;
+ (JGProgressHUD *)showRingHUDWithMsg:(NSString *)msg detailMsg:(NSString *)detailMsg inView:(UIView *)view;

#pragma mark - 通用
/**
 *  隐藏 Loading HUD
 *
 *  @param view 如果为nil，则消除key window上的hud
 */
+ (void)hideLoadingHUDInView:(UIView *)view;
@end

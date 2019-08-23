//
//  UIView+CHZAnimations.h
//  TclIntelliCom
//
//  Created by Wymann Chan on 2019/8/23.
//  Copyright © 2019 tcl. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 动画状态

 - AnimationStatus_BasicMoveBegin: 线性位移动画（无弹性）开始
 - AnimationStatus_BasicMoveEnd: 线性位移动画（无弹性）结束
 - AnimationStatus_SpringMoveBegin: 线性位移动画（弹性）开始
 - AnimationStatus_SpringMoveEnd: 线性位移动画（弹性）结束
 - AnimationStatus_BreathBegin: 呼吸动画 开始
 - AnimationStatus_BreathEnd: 呼吸动画 结束
 - AnimationStatus_RotationBegin: 旋转动画 开始
 - AnimationStatus_RotationEnd: 旋转动画 结束
 */
typedef NS_ENUM(NSInteger, AnimationStatus) {
    AnimationStatus_BasicMoveBegin = 0,
    AnimationStatus_BasicMoveEnd = 1,
    AnimationStatus_SpringMoveBegin = 2,
    AnimationStatus_SpringMoveEnd = 3,
    AnimationStatus_BreathBegin = 4,
    AnimationStatus_BreathEnd = 5,
    AnimationStatus_RotationBegin = 6,
    AnimationStatus_RotationEnd = 7,
};

typedef void(^AnimationStatusBlock)(AnimationStatus status);

//弹性动画配置参数
@interface SpringConfiguration : NSObject

/** 质量，影响图层运动时的弹簧惯性，质量越大，弹簧拉伸和压缩的幅度越大 默认值:1 */
@property (nonatomic) CGFloat mass;
/** 刚度系数(劲度系数/弹性系数)，刚度系数越大，形变产生的力就越大，运动越快。默认值:100 */
@property (nonatomic) CGFloat stiffness;
/** 阻尼系数，阻止弹簧伸缩的系数，阻尼系数越大，停止越快。默认:10 */
@property (nonatomic) CGFloat damping;
/** 初始速率，动画视图的初始速度大小。默认值:0 */
@property (nonatomic) CGFloat initialVelocity;
/** 当设置为YES时，动画结束后，移除layer层的；当设置为NO时，保持动画结束时layer的状态 */
@property (nonatomic) BOOL removedOnCompletion;

@end

@interface UIView (CHZAnimations)

#pragma mark - Property
/**
 动画状态回调
 */
@property (nonatomic, copy) AnimationStatusBlock animationStatusBlock;

#pragma mark - 线性位移动画（无弹性）
/**
 UIView 线性位移动画（无弹性）

 @param startRect 开始位置
 @param endRect 最后位置
 @param during 动画时间
 */
- (void)basicMoveFromFrame:(CGRect)startRect
                   toFrame:(CGRect)endRect
                    during:(CGFloat)during;

#pragma mark - 线性位移动画（弹性）
/**
 UIView 线性位移动画（弹性）
 
 @param startRect 开始位置
 @param endRect 最后位置
 @param springConfiguration 弹性动画配置参数
 */
- (void)springMoveFromFrame:(CGRect)startRect
                    toFrame:(CGRect)endRect
        springConfiguration:(SpringConfiguration *)springConfiguration;

#pragma mark - 无限呼吸动画（循环）
/**
 开始呼吸动画
 
 @param breathDuring 每呼吸一次耗时
 */
- (void)startBreathWithDuring:(CGFloat)breathDuring;

/**
 停止呼吸动画
 */
- (void)stopBreath;

#pragma mark - 无限旋转动画（循环）
/**
 开始无限转圈动画
 
 @param rotationDuring 每圈耗时
 @param clockWise 是否顺时针
 */
- (void)startInfiniteRotatingWithDuring:(CGFloat)rotationDuring
                              clockWise:(BOOL)clockWise;

/**
 停止无限转圈动画
 */
- (void)stopInfiniteRotation;

@end

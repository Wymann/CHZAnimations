//
//  UIView+CHZAnimations.m
//  TclIntelliCom
//
//  Created by Wymann Chan on 2019/8/23.
//  Copyright © 2019 tcl. All rights reserved.
//

#import "UIView+CHZAnimations.h"
#import <objc/runtime.h>

static NSString *AnimationStatusBlockKey = @"AnimationStatusBlockKey";

#define BreathAnimtionKey @"BreathAnimtionKey"
#define RotationAnimtionKey @"RotationAnimtionKey"
#define SpringMoveAnimtionKey @"SpringMoveAnimtionKey"

@implementation SpringConfiguration

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mass = 1;
        self.stiffness = 100;
        self.damping = 10;
        self.initialVelocity = 0;
        self.removedOnCompletion = NO;
    }
    return self;
}

@end

@interface UIView()<CAAnimationDelegate>

@end

@implementation UIView (CHZAnimations)

#pragma mark - Setter
-(void)setAnimationStatusBlock:(AnimationStatusBlock)animationStatusBlock {
    objc_setAssociatedObject(self, &AnimationStatusBlockKey, animationStatusBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - Getter
-(AnimationStatusBlock)animationStatusBlock {
    return objc_getAssociatedObject(self, &AnimationStatusBlockKey);
}

#pragma mark - 线性位移动画（无弹性）
/** UIView 线性位移动画 */
- (void)basicMoveFromFrame:(CGRect)startRect
                   toFrame:(CGRect)endRect
                    during:(CGFloat)during {
    if (self.animationStatusBlock) {
        self.animationStatusBlock(AnimationStatus_BasicMoveBegin);
    }
    [UIView animateWithDuration:during animations:^{
        self.frame = endRect;
    } completion:^(BOOL finished) {
        if (self.animationStatusBlock) {
            self.animationStatusBlock(AnimationStatus_BasicMoveEnd);
        }
    }];
}

#pragma mark - 线性位移动画（弹性）
/** UIView 线性位移动画（弹性） */
- (void)springMoveFromFrame:(CGRect)startRect
                    toFrame:(CGRect)endRect
        springConfiguration:(SpringConfiguration *)springConfiguration {
    if (self.animationStatusBlock) {
        self.animationStatusBlock(AnimationStatus_SpringMoveBegin);
    }
    self.frame = startRect;
    if (springConfiguration) {
        CASpringAnimation *springAnimation = [CASpringAnimation animationWithKeyPath:@"bounds"];
        springAnimation.fromValue = [NSValue valueWithCGRect:startRect];
        springAnimation.toValue = [NSValue valueWithCGRect:endRect];
        springAnimation.mass = springConfiguration.mass;
        springAnimation.stiffness = springConfiguration.stiffness;
        springAnimation.damping = springConfiguration.damping;
        springAnimation.initialVelocity = springConfiguration.initialVelocity;
        springAnimation.duration = springAnimation.settlingDuration;
        
        CASpringAnimation *springAnimation2 = [CASpringAnimation animationWithKeyPath:@"position"];
        CGPoint startCenter = CGPointMake(CGRectGetMinX(startRect) + CGRectGetWidth(startRect)/2, CGRectGetMinY(startRect) + CGRectGetHeight(startRect)/2);
        CGPoint endCenter = CGPointMake(CGRectGetMinX(endRect) + CGRectGetWidth(endRect)/2, CGRectGetMinY(endRect) + CGRectGetHeight(endRect)/2);
        springAnimation2.fromValue = [NSValue valueWithCGPoint:startCenter];
        springAnimation2.toValue = [NSValue valueWithCGPoint:endCenter];
        springAnimation2.mass = springConfiguration.mass;
        springAnimation2.stiffness = springConfiguration.stiffness;
        springAnimation2.damping = springConfiguration.damping;
        springAnimation2.initialVelocity = springConfiguration.initialVelocity;
        springAnimation2.duration = springAnimation.settlingDuration;
        
        CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
        groupAnimation.delegate = self;
        groupAnimation.animations = @[springAnimation, springAnimation2];
        groupAnimation.fillMode = kCAFillModeBoth;
        groupAnimation.removedOnCompletion = springConfiguration.removedOnCompletion;
        groupAnimation.duration = springAnimation.settlingDuration;
        [self.layer addAnimation:groupAnimation forKey:SpringMoveAnimtionKey];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = endRect;
        } completion:^(BOOL finished) {
            if (self.animationStatusBlock) {
                self.animationStatusBlock(AnimationStatus_SpringMoveEnd);
            }
        }];
    }
}

#pragma mark - 无限呼吸动画（循环）
/**
 开始呼吸动画
 */
- (void)startBreathWithDuring:(CGFloat)breathDuring {
    [self stopBreath];
    if (self.animationStatusBlock) {
        self.animationStatusBlock(AnimationStatus_BreathBegin);
    }
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.delegate = self;
    scaleAnimation.duration = breathDuring;
    scaleAnimation.repeatCount = HUGE_VALF;
    scaleAnimation.autoreverses = YES; //每次动画是否再动态回到原位
    //removedOnCompletion为NO保证app切换到后台动画再切回来时动画依然执行
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fromValue = @(0.6);
    scaleAnimation.toValue = @(1.2);
    [self.layer addAnimation:scaleAnimation forKey:BreathAnimtionKey];
}

/**
 停止呼吸动画
 */
- (void)stopBreath {
    [self.layer removeAnimationForKey:BreathAnimtionKey];
    if (self.animationStatusBlock) {
        self.animationStatusBlock(AnimationStatus_BreathEnd);
    }
}

#pragma mark - 无限旋转动画（循环）
/**
 开始无限转圈动画
 */
- (void)startInfiniteRotatingWithDuring:(CGFloat)rotationDuring
                              clockWise:(BOOL)clockWise {
    [self stopInfiniteRotation];
    if (self.animationStatusBlock) {
        self.animationStatusBlock(AnimationStatus_RotationBegin);
    }
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.delegate = self;
    if (clockWise) {
        animation.fromValue = [NSNumber numberWithFloat:0.0];
        animation.toValue = [NSNumber numberWithFloat:M_PI * 2];
    } else {
        animation.fromValue = [NSNumber numberWithFloat:M_PI * 2];
        animation.toValue = [NSNumber numberWithFloat:0.0];
    }
    animation.duration = rotationDuring;
    animation.repeatCount = MAXFLOAT;
    [self.layer addAnimation:animation forKey:@"rotation-layer"];
}

/**
 停止无限转圈动画
 */
- (void)stopInfiniteRotation {
    [self.layer removeAnimationForKey:@"rotation-layer"];
    if (self.animationStatusBlock) {
        self.animationStatusBlock(AnimationStatus_RotationEnd);
    }
}

#pragma mark - CAAnimationDelegate
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.animationStatusBlock) {
        if([self.layer animationForKey:SpringMoveAnimtionKey] == anim) {
            self.animationStatusBlock(AnimationStatus_SpringMoveEnd);
        } else if([self.layer animationForKey:BreathAnimtionKey] == anim) {
            self.animationStatusBlock(AnimationStatus_BreathEnd);
        } else if([self.layer animationForKey:RotationAnimtionKey] == anim) {
            self.animationStatusBlock(AnimationStatus_RotationEnd);
        }
    }
}

@end

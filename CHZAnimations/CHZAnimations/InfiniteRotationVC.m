//
//  InfiniteRotationVC.m
//  CHZAnimations
//
//  Created by Wymann Chan on 2019/8/23.
//  Copyright © 2019 TCLSmartHome. All rights reserved.
//

#import "InfiniteRotationVC.h"

@interface InfiniteRotationVC ()

@property (nonatomic, strong) UILabel *animationView;

@end

@implementation InfiniteRotationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"无限旋转动画（循环）";
    
    self.animationView = [[UILabel alloc] initWithFrame:CGRectMake(80, 200, 150, 150)];
    self.animationView.backgroundColor = [UIColor darkGrayColor];
    self.animationView.layer.cornerRadius = 150/2;
    self.animationView.clipsToBounds = YES;
    self.animationView.font = [UIFont systemFontOfSize:14.0];
    self.animationView.textColor = [UIColor whiteColor];
    self.animationView.text = @"停止";
    self.animationView.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.animationView];
    
    //监听动画回调
    self.animationView.animationStatusBlock = ^(AnimationStatus status) {
        if (status == AnimationStatus_RotationBegin) {
            NSLog(@"动画开始");
        } else if (status == AnimationStatus_RotationEnd) {
            NSLog(@"动画结束");
        }
    };
    
    //添加点击动作
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopAnimation)];
    [self.animationView addGestureRecognizer:tap];
    self.animationView.userInteractionEnabled = YES;
}

/** 停止无限旋转动画 */
- (void)stopAnimation {
    [self.animationView stopInfiniteRotation];
}

#pragma mark - override
-(void)startPlayAnimation {
    [super startPlayAnimation];
    //开始无限旋转动画
    [self.animationView startInfiniteRotatingWithDuring:2 clockWise:YES];
}

@end

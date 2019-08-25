//
//  BasicMoveVC.m
//  CHZAnimations
//
//  Created by 陈怀章 on 2019/8/25.
//  Copyright © 2019 TCLSmartHome. All rights reserved.
//

#import "BasicMoveVC.h"

@interface BasicMoveVC ()

@property (nonatomic, strong) UILabel *animationView;

@end

@implementation BasicMoveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"线性位移动画（无弹性）";
    
    self.animationView = [[UILabel alloc] initWithFrame:CGRectMake(80, 200, 150, 150)];
    self.animationView.backgroundColor = [UIColor redColor];
    self.animationView.font = [UIFont systemFontOfSize:14.0];
    self.animationView.textColor = [UIColor whiteColor];
    self.animationView.text = @"归位";
    self.animationView.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.animationView];
    
    //监听动画回调
    self.animationView.animationStatusBlock = ^(AnimationStatus status) {
        if (status == AnimationStatus_BasicMoveBegin) {
            NSLog(@"动画开始");
        } else if (status == AnimationStatus_BasicMoveEnd) {
            NSLog(@"动画结束");
        }
    };
    
    //添加点击动作
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopAnimation)];
    [self.animationView addGestureRecognizer:tap];
    self.animationView.userInteractionEnabled = YES;
}

/** 回到原来位置 */
- (void)stopAnimation {
    [self.animationView basicMoveFromFrame:self.animationView.frame toFrame:CGRectMake(80, 200, 150, 150) during:0.5];
}

#pragma mark - override
-(void)startPlayAnimation {
    [super startPlayAnimation];
    //开始位移动画
    [self.animationView basicMoveFromFrame:CGRectMake(80, 200, 150, 150) toFrame:CGRectMake(80, 300, 100, 100) during:0.5];
}

@end

//
//  MYZLockView.m
//  PasscodeLockDemo
//
//  Created by MA806P on 16/7/25.
//  Copyright © 2016年 myz. All rights reserved.
//

#import "MYZLockView.h"
#import "MYZGestureView.h"
#import "MYZPasscodeView.h"

@interface MYZLockView ()

@property (nonatomic, weak) UIImageView * headImgView;

@property (nonatomic, weak) MYZGestureView * gestureView;

@property (nonatomic, weak) MYZPasscodeView * passcodeView;

@end

@implementation MYZLockView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor =[UIColor colorWithWhite:0.667 alpha:1.0];
        
        CGFloat headWH = 70.0;
        CGFloat headY = 0.14 * ([UIScreen mainScreen].bounds.size.height);
        CGFloat headX = ([UIScreen mainScreen].bounds.size.width - headWH) * 0.5;
        
        UIImageView * headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(headX, headY, headWH, headWH)];
        headImgView.image = [UIImage imageNamed:@"head"];
        headImgView.layer.cornerRadius = headWH * 0.5;
        headImgView.layer.masksToBounds = YES;
        [self addSubview:headImgView];
        self.headImgView = headImgView;
        
    }
    return self;
}


- (void)setShowGestureViewBool:(BOOL)showGestureViewBool
{
    _showGestureViewBool = showGestureViewBool;
    
    if (showGestureViewBool)
    {
        __weak typeof(self) weakSelf = self;
        MYZGestureView * gestureView = [[MYZGestureView alloc] init];
        gestureView.hideGesturePath = ![[NSUserDefaults standardUserDefaults] boolForKey:GesturePathText];
        gestureView.gestureResult = ^(NSString * gestureCode){
            
            NSString * saveGestureCode = [[NSUserDefaults standardUserDefaults] objectForKey:GestureCodeKey];
            NSLog(@" MYZLockView -- %@ == old %@", gestureCode, saveGestureCode);
            if ([gestureCode isEqualToString:saveGestureCode])
            {
                [weakSelf closse];
                return YES;
            }
            else
            {
                return NO;
            }
        };
        [self addSubview:gestureView];
        self.gestureView = gestureView;
    }
    
}


- (void)setShowPasscodeViewBool:(BOOL)showPasscodeViewBool
{
    _showPasscodeViewBool = showPasscodeViewBool;
    
    if (showPasscodeViewBool)
    {
        NSString * savePasscode = [[NSUserDefaults standardUserDefaults] objectForKey:PasscodeKey];
        __weak typeof(self) weakSelf = self;
        
        MYZPasscodeView * passcodeView = [[MYZPasscodeView alloc] init];
        passcodeView.PasscodeResult = ^(NSString * passcode){
            
            BOOL isRight = [passcode isEqualToString:savePasscode];
            if (isRight) { [weakSelf closse]; }
            return isRight; //savePasscode];
        };
        [self addSubview:passcodeView];
        self.passcodeView = passcodeView;
        
        //UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closse)];
        //[passcodeView addGestureRecognizer:tap];
    }
    
}






- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    //CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat lockViewW = 280;
    CGFloat lockViewH = 300;
    CGFloat lockViewY = CGRectGetMaxY(self.headImgView.frame) + 30;
    CGFloat lockViewX = ([UIScreen mainScreen].bounds.size.width - lockViewW) * 0.5;
    
    CGRect lockFrame = CGRectMake(lockViewX, lockViewY, lockViewW, lockViewH);
    
    if (self.showGestureViewBool)
    {
        self.gestureView.frame = lockFrame;
    }
    else if (self.showPasscodeViewBool)
    {
        self.passcodeView.frame = lockFrame;
    }
    
}




- (void)closse
{
    [UIView animateWithDuration:0.8 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}


@end

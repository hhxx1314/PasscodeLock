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

@property (nonatomic, weak) MYZGestureView * gestureView;

@property (nonatomic, weak) MYZPasscodeView * passcodeView;

@end

@implementation MYZLockView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor =[UIColor colorWithWhite:0.667 alpha:1.0];
        self.showsHorizontalScrollIndicator = NO;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closse)];
        [self addGestureRecognizer:tap];
    }
    return self;
}


- (void)setShowGestureViewBool:(BOOL)showGestureViewBool
{
    _showGestureViewBool = showGestureViewBool;
    
    if (showGestureViewBool)
    {
        MYZGestureView * gestureView = [[MYZGestureView alloc] init];
        [self addSubview:gestureView];
        self.gestureView = gestureView;
    }
    
}


- (void)setShowPasscodeViewBool:(BOOL)showPasscodeViewBool
{
    _showPasscodeViewBool = showPasscodeViewBool;
    
    if (showPasscodeViewBool)
    {
        MYZPasscodeView * passcodeView = [[MYZPasscodeView alloc] init];
        [self addSubview:passcodeView];
        self.passcodeView = passcodeView;
    }
    
}





- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat pages = (self.showGestureViewBool?1:0) + (self.showPasscodeViewBool?1:0);
    
    self.contentSize = CGSizeMake(screenW*pages, screenH);
    self.pagingEnabled = YES;
    
    
    if (self.showGestureViewBool)
    {
        self.gestureView.frame = CGRectMake(10, 10, 100, 100);
    }
    
    if (self.showPasscodeViewBool)
    {
        if (self.showGestureViewBool)
        {
            self.passcodeView.frame = CGRectMake(screenW+10, 10, 100, 100);
        }
        else
        {
            self.passcodeView.frame = CGRectMake(10, 10, 100, 100);
        }
    }
    
}




- (void)closse
{
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.8 animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
    
    
}


@end
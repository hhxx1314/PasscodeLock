//
//  MYZMinePasscodeSetController.m
//  PasscodeLockDemo
//
//  Created by 159CaiMini02 on 16/8/23.
//  Copyright © 2016年 myz. All rights reserved.
//

#import "MYZMinePasscodeSetController.h"
#import "MYZPasscodeView.h"

@interface MYZMinePasscodeSetController ()

@property (nonatomic, weak) UILabel * infoLabel;

@property (nonatomic, copy) NSString * firstPasscode;

@end

@implementation MYZMinePasscodeSetController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    if (!self.passcodeType)
    {
        self.passcodeType = PasscodeSetTypeChange;
    }
    
    
    NSString * infoLabelText = nil;
    if (self.passcodeType == PasscodeSetTypeInstal)
    {
        infoLabelText = @"输入新密码";
    }
    else if (self.passcodeType == PasscodeSetTypeDelete)
    {
        infoLabelText = @"输入密码";
    }
    else if (self.passcodeType == PasscodeSetTypeChange)
    {
        infoLabelText = @"输入当前密码";
    }
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat marginTop = 0.2 * ([UIScreen mainScreen].bounds.size.height);
    
    UILabel * infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, marginTop + 5, screenW, 20)];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.font = [UIFont systemFontOfSize:14];
    infoLabel.text = infoLabelText;
    [self.view addSubview:infoLabel];
    self.infoLabel = infoLabel;
    
    
    CGFloat passcodeViewW = (300/414.0)*screenW;
    CGFloat passcodeViewH = (430/736.0)*[UIScreen mainScreen].bounds.size.height;
    CGFloat passcodeViewX = (screenW - passcodeViewW) * 0.5;
    CGFloat passcodeViewY = CGRectGetMaxY(self.infoLabel.frame) + 30;
    __weak typeof(self) weakSelf = self;
    MYZPasscodeView * passcodeView = [[MYZPasscodeView alloc] initWithFrame:CGRectMake(passcodeViewX, passcodeViewY, passcodeViewW, passcodeViewH)];
    passcodeView.hideFingerprintBtn = ![[NSUserDefaults standardUserDefaults] boolForKey:TouchIDText];
    if (self.passcodeType == PasscodeSetTypeDelete)
    {
        passcodeView.hideFingerprintBtn = NO;
    }
    else
    {
        passcodeView.hideFingerprintBtn = YES;
    }
    passcodeView.PasscodeResult = ^(NSString * passcode){
        
        if (weakSelf.passcodeType == PasscodeSetTypeInstal)
        {
            return [weakSelf instalPasscodeWithPasscode:passcode];
            
        }
        else if (weakSelf.passcodeType == PasscodeSetTypeDelete)
        {
            NSString * savePasscode = [[NSUserDefaults standardUserDefaults] objectForKey:PasscodeKey];
            if([savePasscode isEqualToString:passcode] || [passcode isEqualToString:@"fingerprint"])
            {
                [weakSelf backWithLocked:NO];
                return YES;
            }
            else
            {
                return NO;
            }
        }
        else if (weakSelf.passcodeType == PasscodeSetTypeChange)
        {
            if (self.firstPasscode == nil)
            {
                NSString * savePasscode = [[NSUserDefaults standardUserDefaults] objectForKey:PasscodeKey];
                if([savePasscode isEqualToString:passcode])
                {
                    self.firstPasscode = passcode;
                    self.infoLabel.text = @"输入新密码";
                    return YES;
                }
            }
            else
            {
                if([self.firstPasscode isEqualToString:passcode])
                {
                    [[NSUserDefaults standardUserDefaults] setObject:passcode forKey:PasscodeKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [self backWithLocked:YES];
                    return YES;
                }
                else
                {
                    self.infoLabel.text = @"密码不匹配请重试";
                    self.firstPasscode = nil;
                    return NO;
                }
            }
            
            
            
        }
    
        return YES;
    };
    [self.view addSubview:passcodeView];
    
}


- (BOOL)instalPasscodeWithPasscode:(NSString *)passcode
{
    if (self.firstPasscode == nil)
    {
        self.firstPasscode = passcode;
        self.infoLabel.text = self.passcodeType == PasscodeSetTypeChange ? @"输入新密码" : @"再次输入新密码";
        return YES;
    }
    else
    {
        if([self.firstPasscode isEqualToString:passcode])
        {
            [[NSUserDefaults standardUserDefaults] setObject:passcode forKey:PasscodeKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self backWithLocked:YES];
            return YES;
        }
        else
        {
            self.infoLabel.text = @"密码不匹配请重试";
            self.firstPasscode = nil;
            return NO;
        }
        
    }
}


- (void)back
{
    BOOL locked = NO;
    if (self.passcodeType == PasscodeSetTypeInstal)
    {
        locked = NO;
    }
    else if (self.passcodeType == PasscodeSetTypeDelete)
    {
        locked = YES;
    }
    else if (self.passcodeType == PasscodeSetTypeChange)
    {
        locked = YES;
    }
    [self backWithLocked:locked];
}

- (void)backWithLocked:(BOOL)lock
{
    if (self.lockBlock)
    {
        self.lockBlock(lock);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end

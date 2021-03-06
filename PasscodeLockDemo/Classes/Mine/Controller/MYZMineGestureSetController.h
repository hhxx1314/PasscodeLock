//
//  MYZMineGestureSetController.h
//  PasscodeLockDemo
//
//  Created by 159CaiMini02 on 16/8/4.
//  Copyright © 2016年 myz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum: NSUInteger {
    GestureSetTypeInstall = 1,
    GestureSetTypeDelete,
    GestureSetTypeChange
    
}GestureSetType;

typedef void(^GestureSetLock)(BOOL locked);

FOUNDATION_EXPORT NSString * const GestureCodeKey;

@interface MYZMineGestureSetController : UIViewController

@property (nonatomic, assign) GestureSetType gestureSetType;

@property (nonatomic, copy)GestureSetLock lockBlock;

@end

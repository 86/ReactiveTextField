//
//  TRZBorderedButton.h
//  TestGCD
//
//  Created by daisuke yamanaka on 2015/02/22.
//  Copyright (c) 2015年 triaedz. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface TRZBorderedButton : UIButton

@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat cornerRadius;

@end

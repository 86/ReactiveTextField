//
//  TRZBorderedButton.m
//  TestGCD
//
//  Created by daisuke yamanaka on 2015/02/22.
//  Copyright (c) 2015年 triaedz. All rights reserved.
//

#import "TRZBorderedButton.h"

@implementation TRZBorderedButton

@dynamic borderWidth, borderColor, cornerRadius;

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

@end

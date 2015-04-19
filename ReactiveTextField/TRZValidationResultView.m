//
//  TRZValidationResultView.m
//  ReactiveTextField
//
//  Created by daisuke yamanaka on 2015/04/18.
//  Copyright (c) 2015年 triaedz. All rights reserved.
//

#import "TRZValidationResultView.h"

@implementation TRZValidationResultView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    NSString *className = NSStringFromClass([self class]);
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:0] objectAtIndex:0];
    view.frame = self.bounds;
    [self addSubview:view];
}

@end

//
//  JGToastView.h
//  kscore
//
//  Created by Jamin Guy on 11/17/11.
//  Copyright (c) 2011 Jamin Guy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGView.h"

@interface JGToastView : JGView

+ (void)toastInView:(UIView *)parentView withText:(NSString *)text textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor font:(UIFont *)font completion:(void (^)())completion;

@end

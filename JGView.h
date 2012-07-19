//
//  CustomView.h
//  drawtest
//
//  Created by Jamin Guy on 6/29/11.
//  Copyright 2011 Jamin Guy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGView : UIView

@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIColor *backgroundColor;

- (CGRect)fillRect;
- (UIBezierPath *)fillClipPath;

@end

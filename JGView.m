//
//  CustomView.m
//  drawtest
//
//  Created by Jamin Guy on 6/29/11.
//  Copyright 2011 Jamin Guy. All rights reserved.
//

#import "JGView.h"

#import <QuartzCore/QuartzCore.h>

@interface JGView ()

@end

@implementation JGView

@synthesize borderWidth;
@synthesize borderColor;
@synthesize cornerRadius;
@synthesize backgroundColor;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        super.backgroundColor = [UIColor clearColor];
        [self updateMask];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        super.backgroundColor = [UIColor clearColor];
        [self updateMask];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGRect outerRect = rect;
    UIBezierPath  *path;
    CGFloat radius = self.cornerRadius;
    if(self.borderWidth > 0) {
        if(radius > 0) {
            path = [UIBezierPath bezierPathWithRoundedRect:outerRect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
            [path addClip];
        }
        
        [self.borderColor setFill];    
        UIRectFill(outerRect);
        
        CGFloat offset = self.borderWidth;
        CGRect innerRect = [self fillRect];
        
        if(radius > 0) {
            path = [UIBezierPath bezierPathWithRoundedRect:innerRect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius - offset, radius - offset)];
            [path addClip];
        }
        
        [(self.backgroundColor ?: [UIColor whiteColor]) setFill];
        UIRectFill(innerRect);
    }
    else if(radius > 0) {
        path = [UIBezierPath bezierPathWithRoundedRect:outerRect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
        [path addClip];
        
        [(self.backgroundColor ?: [UIColor whiteColor]) setFill];
        UIRectFill(outerRect);
    }
    else {
        [(self.backgroundColor ?: [UIColor whiteColor]) setFill];
        UIRectFill(outerRect);
    }
    
    [self updateMask];
}

- (void)updateMask {
    if(self.maskToBounds) {
        CAShapeLayer *mask = [CAShapeLayer layer];
        mask.frame = self.bounds;
        CGFloat radius = self.cornerRadius;
        mask.path = [UIBezierPath bezierPathWithRoundedRect:mask.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)].CGPath;
        mask.fillColor = (self.backgroundColor ?: [UIColor whiteColor]).CGColor;
        self.layer.mask = mask;
    }
}

- (void)setBackgroundColor:(UIColor *)newColor {
    backgroundColor = newColor;
    [self updateMask];
    [self setNeedsDisplay];
}

- (void)setCornerRadius:(CGFloat)aCornerRadius {
    cornerRadius = aCornerRadius;
    [self updateMask];
    [self setNeedsDisplay];
}

- (void)setBorderWidth:(CGFloat)newBorderWidth {
    borderWidth = newBorderWidth;
    [self updateMask];
    [self setNeedsDisplay];
}

- (CGRect)fillRect {
    CGRect boundsRect = self.bounds;
    CGFloat borderOffset = self.borderWidth;
    return CGRectMake(boundsRect.origin.x + borderOffset, boundsRect.origin.y + borderOffset, boundsRect.size.width - (borderOffset * 2.0), boundsRect.size.height - (borderOffset * 2.0));
}

- (UIBezierPath *)fillClipPath {
    CGFloat radius = self.cornerRadius;
    CGFloat offset = self.borderWidth;
    UIBezierPath *clipPath = nil;
    if(self.cornerRadius > 0) {
        clipPath = [UIBezierPath bezierPathWithRoundedRect:[self fillRect] byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius - offset, radius - offset)];
    }
    return clipPath;
}

@end

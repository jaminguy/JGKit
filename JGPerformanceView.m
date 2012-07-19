//
//  CustomView.m
//  drawtest
//
//  Created by Jamin Guy on 6/29/11.
//  Copyright 2011 Jamin Guy. All rights reserved.
//

#import "JGPerformanceView.h"

#import <QuartzCore/QuartzCore.h>

@interface JGPerformanceView ()


@end

@implementation JGPerformanceView

@synthesize borderWidth;
@synthesize borderColor;
@synthesize cornerRadius;
@synthesize backgroundColor;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        super.backgroundColor = [UIColor clearColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {        
    CGRect outerRect = self.bounds;
    
    if(self.borderWidth > 0) {
        UIBezierPath  *path;
        CGFloat radius = self.cornerRadius;
        if(self.cornerRadius > 0) {
            path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
            [path addClip];
        }
        
        [self.borderColor setFill];    
        UIRectFill(outerRect);
        
        CGFloat offset = self.borderWidth;
        CGRect innerRect = CGRectMake(outerRect.origin.x + offset, outerRect.origin.y + offset, outerRect.size.width - (offset * 2.0), outerRect.size.height - (offset * 2.0));
        
        if(self.cornerRadius > 0) {
            path = [UIBezierPath bezierPathWithRoundedRect:innerRect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius - offset, radius - offset)];
            [path addClip];
        }
        
        [(self.backgroundColor ?: [UIColor whiteColor]) setFill];
        UIRectFill(innerRect);
    }
    else {
        [(self.backgroundColor ?: [UIColor whiteColor]) setFill];
        UIRectFill(self.bounds);
    }
    
//    CGContextRef currentGraphicsContext = UIGraphicsGetCurrentContext();
//    
//    CGGradientRef shadowGradient;
//	CGColorSpaceRef	shadowColorspace;
//	CGFloat locations[2] = { 0.0, 1.0 };
//	CGFloat components[8] = {
//        0.0, 0.0, 0.0, 0.5,
//        0.0, 0.0, 0.0, 0.00
//    };
    
//	CGRect shadowFrame, remainderFrame;
//	
//	shadowColorspace = CGColorSpaceCreateDeviceRGB();
//	shadowGradient = CGGradientCreateWithColorComponents(shadowColorspace, components, locations, 2);
//	
//	//CGRectDivide(self.bounds, &shadowFrame, &remainderFrame, 12.0, CGRectMaxYEdge);
//	CGContextDrawLinearGradient(currentGraphicsContext, shadowGradient,
//                                CGPointMake(CGRectGetMidX(shadowFrame), CGRectGetMaxY(shadowFrame)),
//                                CGPointMake(CGRectGetMidX(shadowFrame), CGRectGetMaxY(shadowFrame) - 10.0), 0);
//    
//	CGGradientRelease(shadowGradient);
//	CGColorSpaceRelease(shadowColorspace);
     
}

@end

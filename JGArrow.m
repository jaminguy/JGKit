//
//  JGArrow.m
//  kscore
//
//  Created by Jamin Guy on 11/16/11.
//  Copyright (c) 2011 Jamin Guy. All rights reserved.
//

#import "JGArrow.h"

@interface JGArrow ()

- (void)initSetup;

@end

@implementation JGArrow

@synthesize direction;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSetup];
    }
    return self;
}

- (void)awakeFromNib {
    [self initSetup];
}

- (void)initSetup {
    self.backgroundColor = [UIColor clearColor];
    self.direction = JGArrowDirectionUp;
}

- (void)setDirection:(JGArrowDirection)newDirection {
    direction = newDirection;
    self.transform = CGAffineTransformIdentity;
    if(direction == JGArrowDirectionDown) {
        self.transform = CGAffineTransformRotate(self.transform, M_PI);
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    CGFloat triangleCenterX = width / 2.0;
    CGFloat triangleLeftX = rect.origin.x;
    CGFloat triangleRightSideX = width;
    CGFloat triangleTopY = rect.origin.y;
    CGFloat triangleBottomY = height / 2.0;
    
    CGFloat baseLeftX = width / 4.0;
    CGFloat baseRightX = baseLeftX * 3.0;
    CGFloat baseTopY = triangleBottomY;
    CGFloat baseBottomY = height;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, triangleCenterX, triangleTopY);
    CGPathAddLineToPoint(path, NULL, triangleRightSideX, triangleBottomY);
    CGPathAddLineToPoint(path, NULL, baseRightX, baseTopY);
    CGPathAddLineToPoint(path, NULL, baseRightX, baseBottomY);
    CGPathAddLineToPoint(path, NULL, baseLeftX, baseBottomY);
    CGPathAddLineToPoint(path, NULL, baseLeftX, baseTopY);
    CGPathAddLineToPoint(path, NULL, triangleLeftX, triangleBottomY);
    CGPathCloseSubpath(path);
    
    CGContextSetFillColorWithColor(currentContext, [[UIColor whiteColor] CGColor]);
   
    CGContextAddPath(currentContext, path);
    CGContextDrawPath(currentContext, kCGPathFill);
    CFRelease(path);
}

@end

//
//  JGImageView.m
//  Klout
//
//  Created by Jamin Guy on 7/1/11.
//  Copyright 2011 Jamin Guy. All rights reserved.
//

#import "JGImageView.h"

#import <CoreImage/CoreImage.h>

@interface UIImage (JGKit)

- (UIImage *)crop:(CGRect)rect;
- (UIImage *)thumbnail;

@end

@implementation UIImage (JGKit)

- (UIImage *)crop:(CGRect)rect {    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}

- (UIImage *)thumbnail {
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    CGFloat thumbnailSideLength = MIN(width, height);
    CGFloat x = (width - thumbnailSideLength) / 2.0;
    CGFloat y = (height - thumbnailSideLength) / 2.0;
    CGRect thumbnailRect = CGRectMake(x, y, thumbnailSideLength, thumbnailSideLength);
    return [self crop:thumbnailRect];
}

@end

@implementation JGImageView

@synthesize image;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        super.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        super.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIBezierPath *clipPath = [self fillClipPath];
    if(clipPath) {
        [clipPath addClip];
    }
    [[self.image thumbnail] drawInRect:[self fillRect]];
}

- (void)setImage:(UIImage *)newImage {
    if(image != newImage) {
        image = newImage;
        [self setNeedsDisplay];
    }
}

@end

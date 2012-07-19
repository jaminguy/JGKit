//
//  JGLabel.m
//  Klout
//
//  Created by Jamin Guy on 11/7/11.
//  Copyright (c) 2011 Jamin Guy. All rights reserved.
//

#import "JGLabel.h"

@interface JGLabel ()

- (void)configurePath;
- (void)configureText;

@end

@implementation JGLabel

@synthesize font;
@synthesize text;
@synthesize textColor;
@synthesize textAlignment;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    self.font = [UIFont systemFontOfSize:17.0];
    self.textColor = [UIColor blackColor];
    self.backgroundColor = [UIColor whiteColor];
    self.text = @"";
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self configurePath];
    [self configureText];
}

- (void)configurePath {
    NSMutableArray *paths = [NSMutableArray array];
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGRect boundsRect = self.bounds;
    CGFloat lineHeight = [self.text sizeWithFont:self.font].height;
    CGFloat y = (boundsRect.size.height - lineHeight) / 2.0;
    CGRect rect = CGRectMake(boundsRect.origin.x, boundsRect.origin.y + y, boundsRect.size.width, lineHeight);
    CGPathAddRect(path, NULL, rect);
    [paths addObject:(__bridge_transfer id)path];
    
    [super setPaths:paths];
}

- (void)configureText {
    if(self.text.length) {
        CTTextAlignment kAlignment = kCTLeftTextAlignment;
        if(self.textAlignment == UITextAlignmentCenter) {
            kAlignment = kCTCenterTextAlignment;
        }
        else if(self.textAlignment == UITextAlignmentRight) {
            kAlignment = kCTRightTextAlignment;
        }
        CTParagraphStyleSetting paragraphSettings[] = {
            { kCTParagraphStyleSpecifierAlignment, sizeof(kAlignment), &kAlignment}
        };
        NSMutableDictionary *stringAttributes = [NSMutableDictionary dictionary];
        CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(paragraphSettings, sizeof(paragraphSettings));
        [stringAttributes setObject:(__bridge_transfer id)paragraphStyle forKey:(NSString *)kCTParagraphStyleAttributeName];
        
        CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)self.font.fontName, self.font.pointSize, NULL);
        [stringAttributes setObject:(__bridge_transfer id)ctFont forKey:(id)kCTFontAttributeName];
        
        CGColorRef textColorRef = CGColorCreateCopy([self.textColor CGColor]);
        [stringAttributes setObject:(__bridge_transfer id)textColorRef forKey:(id)kCTForegroundColorAttributeName];
        
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self.text attributes:stringAttributes];
        
        super.attributedString = attrString;
    }
}

- (void)setFont:(UIFont *)newFont {
    if(newFont != font) {
        font = newFont;
        [self setNeedsLayout];
        [self setNeedsDisplay];
    }
}

- (void)setText:(NSString *)newtext {
    if(newtext != text) {
        text = [newtext copy];
        [self setNeedsLayout];
        [self setNeedsDisplay];
    }
}

- (void)setTextColor:(UIColor *)newTextColor {
    if(newTextColor != textColor) {
        textColor = newTextColor;
        [self setNeedsLayout];
        [self setNeedsDisplay];
    }
}

@end

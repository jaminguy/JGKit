//
//  JGToastView.m
//  kscore
//
//  Created by Jamin Guy on 11/17/11.
//  Copyright (c) 2011 Jamin Guy. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "JGToastView.h"

#import "JGTextView.h"

static NSMutableArray *toasts;

@interface JGToastView ()

+ (void)showNextToastView;

@property (nonatomic, copy) void (^toastCompletionBlock)();

@property (nonatomic, strong) JGTextView *textLabel;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, weak) UIView *parentView;
@property (nonatomic, strong) NSTimer *fadeOutTimer;
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIFont *font;

@end


@implementation JGToastView

@synthesize toastCompletionBlock;

#define kToastDuration 6.0

#define kFontSize 16.0
#define kSideBuffer 4.0
#define kTextLabelWidth 220.0

+ (void)toastInView:(UIView *)parentView withText:(NSString *)text textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor font:(UIFont *)font completion:(void (^)())completion {
	JGToastView *toastView = [[JGToastView alloc] initWithText:text textColor:textColor backgroundColor:backgroundColor font:font];
    toastView.toastCompletionBlock = completion;
    toastView.parentView = parentView;
    
	CGFloat labelWidth = toastView.textLabel.frame.size.width;
	CGFloat labelHeight = toastView.textLabel.frame.size.height;
	CGFloat parentWidth = parentView.frame.size.width;
	CGFloat parentHeight = parentView.frame.size.height;
	
	toastView.frame = CGRectMake((parentWidth - labelWidth) / 2.0, (parentHeight - labelHeight) / 2.0, labelWidth + (kSideBuffer * 2.0), labelHeight + (kSideBuffer * 2.0));
    
	if (toasts == nil) {
		toasts = [[NSMutableArray alloc] initWithCapacity:1];
		[toasts addObject:toastView];
		[JGToastView showNextToastView];
	}
	else {
		[toasts addObject:toastView];
	}
}

+ (void)showNextToastView {
	if ([toasts count] > 0) {
        JGToastView *toastView = [toasts objectAtIndex:0];        
        if(toastView.parentView) {
            [toastView.parentView addSubview:toastView];
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction 
                             animations:^{
                                 toastView.alpha = 1.0;
                             } 
                             completion:^(BOOL finished) {
                                 [toastView startFadeOutTimer];
                             }];
            
            //Start timer for fade out
            //[toastView performSelector:@selector(fadeToastOut) withObject:nil afterDelay:kToastDuration];
        }
        else {
            [toasts removeObject:toastView];
            [JGToastView showNextToastView];
        }
    }
    else {
        toasts = nil;
    }
}


- (id)initWithText:(NSString *)text textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor font:(UIFont *)font {
	if ((self = [self initWithFrame:CGRectZero])) {
        
        self.alpha = 0.0;
        self.cornerRadius = 6.0;
        self.backgroundColor = backgroundColor ? [backgroundColor colorWithAlphaComponent:0.98] : [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.98];
        self.autoresizingMask = UIViewAutoresizingNone;
        self.autoresizesSubviews = NO;
        
        _font = font ?: [UIFont boldSystemFontOfSize:kFontSize];
        _textColor = textColor ?: [UIColor whiteColor];
        
        _text = [text copy];
        
        NSDictionary *textAttributes = @{NSFontAttributeName: self.font};
#ifdef __IPHONE_7_0
        CGRect textRect = [text boundingRectWithSize:CGSizeMake(kTextLabelWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttributes context:NULL];
        CGSize textSize = textRect.size;
#else
        CGSize textSize = [text sizeWithFont:_font constrainedToSize:CGSizeMake(kTextLabelWidth, CGFLOAT_MAX)];
#endif
		_textLabel = [[JGTextView alloc] init];
        CGRect textLabelFrame = CGRectMake(kSideBuffer, kSideBuffer * 2.0, textSize.width + kSideBuffer, textSize.height);
        _textLabel.frame = textLabelFrame;
		_textLabel.backgroundColor = [UIColor clearColor];
		
		[self addSubview:_textLabel];
	}
	
	return self;
}

- (void)layoutSubviews {
    [self configurePath];
    [self configureText];
}

- (void)configurePath {
    NSMutableArray *paths = [NSMutableArray array];
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat heightOffset = (kSideBuffer * 2.0);
    CGFloat height =  self.textLabel.frame.size.height + heightOffset;
    CGPathAddRect(path, NULL, CGRectMake(kSideBuffer, -heightOffset, kTextLabelWidth - kSideBuffer, height));
    [paths addObject:(__bridge_transfer id)path];
    [[self textLabel] setPaths:paths];
}

- (void)configureText {
    if(self.text) {
        CTTextAlignment kAlignment = kCTTextAlignmentLeft;
        CGFloat lineSpacing = 1.0;
        CTParagraphStyleSetting paragraphSettings[] = {
            { kCTParagraphStyleSpecifierAlignment, sizeof(kAlignment), &kAlignment},
            { kCTParagraphStyleSpecifierLineSpacing, sizeof(lineSpacing), &lineSpacing}
        };
        NSMutableDictionary *stringAttributes = [NSMutableDictionary dictionary];
        CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(paragraphSettings, sizeof(paragraphSettings));
        [stringAttributes setObject:(__bridge_transfer id)paragraphStyle forKey:(NSString *)kCTParagraphStyleAttributeName];
        
        UIFont *uiFont = self.font;
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)uiFont.fontName, kFontSize, NULL);
        [stringAttributes setObject:(__bridge_transfer id)font forKey:(id)kCTFontAttributeName];
        
        CGColorRef textColor = CGColorCreateCopy([self.textColor CGColor]);
        [stringAttributes setObject:(__bridge_transfer id)textColor forKey:(id)kCTForegroundColorAttributeName];
        
        self.textLabel.attributedString = [[NSAttributedString alloc] initWithString:self.text attributes:stringAttributes];
    }
}

- (void)startFadeOutTimer {
    self.fadeOutTimer = [NSTimer scheduledTimerWithTimeInterval:kToastDuration target:self selector:@selector(fadeOutTimerFire:) userInfo:nil repeats:NO];
}

- (void)fadeOutTimerFire:(NSTimer *)theTimer {
    [self fadeOut];
}

- (void)fadeOut {
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction 
                     animations:^{
                         self.alpha = 0.0;
                     } 
                     completion:^(BOOL finished){
                         if(self.toastCompletionBlock) {
                             self.toastCompletionBlock();
                         }
                         [self removeFromSuperview];                         
                         [toasts removeObject:self];
                         [JGToastView showNextToastView];
                     }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self.fadeOutTimer invalidate];
    [self fadeOut];
}

@end

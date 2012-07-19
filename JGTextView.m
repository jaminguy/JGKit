//
//  JGTextView.m
//
//
//  Created by Jamin Guy on 10/26/2011.
//  Copyright 2011 Jamin Guy. All rights reserved.
//

#import "JGTextView.h"

@interface JGTextView ()


@property (nonatomic, assign) CTFramesetterRef framesetter;
CGRect clipRectToPath(CGRect rect, CGPathRef path);

@end

@implementation JGTextView

@synthesize attributedString = _attributedString;
@synthesize framesetter = _framesetter;
@synthesize paths = _paths;

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
        _framesetter = NULL;
    }
    return self;
}

- (void)dealloc {
	_attributedString = nil;
	if (_framesetter != NULL) {
		CFRelease(_framesetter), _framesetter = NULL;
	}
	_paths = nil;	
}

CGRect clipRectToPath(CGRect rect, CGPathRef path) {
	// TODO: Optimize by allocating a single buffer large enough for our largest rectangle and reusing it.
	// TODO: Optimize by reusing the CGBitmapContext
	
	size_t width = floorf(rect.size.width);
	size_t height = floorf(rect.size.height);
	uint8_t *bits = calloc(width * height, sizeof(*bits));
	CGContextRef bitmapContext = CGBitmapContextCreate(bits, width, height, sizeof(*bits) * 8, width, NULL, kCGImageAlphaOnly);
	CGContextSetShouldAntialias(bitmapContext, NO);
	
	CGContextTranslateCTM(bitmapContext, -rect.origin.x, -rect.origin.y);
	CGContextAddPath(bitmapContext, path);
	CGContextFillPath(bitmapContext);
	
	BOOL foundStart = NO;
	NSRange range = NSMakeRange(0, 0);
	NSUInteger x = 0;
	for (; x < width; ++x) {
		BOOL isGoodColumn = YES;
		for (NSUInteger y = 0; y < height; ++y) {
			if (bits[y * width + x] < 128) {
				isGoodColumn = NO;
				break;
			}
		}
        
		if (isGoodColumn && ! foundStart) {
			foundStart = YES;
			range.location = x;
		}
		else if (!isGoodColumn && foundStart) {
			break;
		}
	}
    
	if (foundStart) {
		range.length = x - range.location - 1;	// X is 1 past the last full-height column
	}
	
	CGContextRelease(bitmapContext);
	free(bits);
	
	CGRect clipRect = CGRectMake(rect.origin.x + range.location, rect.origin.y, range.length, rect.size.height);
	return clipRect;
}

- (CFArrayRef)copyRectangularPathsForPath:(CGPathRef)path height:(CGFloat)height {
	CFMutableArrayRef paths = CFArrayCreateMutable(NULL, 0, &kCFTypeArrayCallBacks);
    
	// First, check if we're a rectangle. If so, we can skip the hard parts.
	CGRect rect;
	if (CGPathIsRect(path, &rect)) {
		CFArrayAppendValue(paths, path);
	}
	else {
		// Build up the boxes one line at a time. If two boxes have the same width and offset, then merge them.
		CGRect boundingBox = CGPathGetPathBoundingBox(path);
		CGRect frameRect = CGRectZero;
		for (CGFloat y = CGRectGetMaxY(boundingBox) - height; y > height; y -= height) {
			CGRect lineRect = CGRectMake(CGRectGetMinX(boundingBox), y, CGRectGetWidth(boundingBox), height);			
			CGContextAddRect(UIGraphicsGetCurrentContext(), lineRect);
			
			lineRect = CGRectIntegral(clipRectToPath(lineRect, path));		// Do the math with full precision so we don't drift, but do final render on pixel boundaries.
			CGContextAddRect(UIGraphicsGetCurrentContext(), lineRect);
            
			if (! CGRectIsEmpty(lineRect)) {
				if (CGRectIsEmpty(frameRect)) {
					frameRect = lineRect;
				}
				else if (frameRect.origin.x == lineRect.origin.x && frameRect.size.width == lineRect.size.width) {
					frameRect = CGRectMake(lineRect.origin.x, lineRect.origin.y, lineRect.size.width, CGRectGetMaxY(frameRect) - CGRectGetMinY(lineRect));
				}
				else {
					CGMutablePathRef framePath = CGPathCreateMutable();
					CGPathAddRect(framePath, NULL, frameRect);
					CFArrayAppendValue(paths, framePath);
                    
					CFRelease(framePath);
					frameRect = lineRect;
				}
			}
		}
		
		if (! CGRectIsEmpty(frameRect)) {
			CGMutablePathRef framePath = CGPathCreateMutable();
			CGPathAddRect(framePath, NULL, frameRect);
			CFArrayAppendValue(paths, framePath);
			CFRelease(framePath);
		}			
	}
    
	return paths;
}

- (NSUInteger)drawFromIndex:(CFIndex)index intoRectangularPath:(CGPathRef)path {
	CTFrameRef frame = CTFramesetterCreateFrame(self.framesetter, CFRangeMake(index, 0), path, NULL);	
	CTFrameDraw(frame, UIGraphicsGetCurrentContext());
	CFRange frameRange = CTFrameGetVisibleStringRange(frame);
    CFRelease(frame);
	return frameRange.length;
}	

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
	if (self.attributedString == nil) {
		return;
	}
	
	// Initialize the context (always initialize your text matrix)
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    CGAffineTransform flip = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, self.frame.size.height);
    CGContextConcatCTM(context, flip);
    
	CFIndex charIndex = 0;
	for (id path in [self paths]) {
		CGPathRef pathRef = (__bridge CGPathRef)path;
		CFArrayRef subpaths = [self copyRectangularPathsForPath:pathRef height:18.0];	// FIXME: Need algorithm w/o height. Probably means combining this routine with drawFromIndex:
		CFIndex subpathCount = CFArrayGetCount(subpaths);
		for (CFIndex subpathIndex = 0; subpathIndex < subpathCount; ++subpathIndex) {
			CGPathRef subpath = CFArrayGetValueAtIndex(subpaths, subpathIndex);
			charIndex += [self drawFromIndex:charIndex intoRectangularPath:subpath];
		}
		
		CFRelease(subpaths);
	}
}

- (void)setAttributedString:(NSAttributedString*)aString {
    if(_attributedString != aString) {
        _attributedString = [aString copy];
        if (_framesetter != NULL) {
            CFRelease(_framesetter), _framesetter = NULL;
        }
        [self setNeedsDisplay];
    }
}

- (void)setPaths:(NSArray*)aPaths {
	NSArray *newPaths = [aPaths copy];
	_paths = newPaths;
	[self setNeedsDisplay];
}

- (CTFramesetterRef)framesetter {
    if (_framesetter == NULL) {
        _framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)[self attributedString]);
    }
    return _framesetter;
}

@end
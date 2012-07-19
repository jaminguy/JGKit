//
//  JGTextView.h
//
//
//  Created by Jamin Guy on 10/26/2011.
//  Copyright 2011 Jamin Guy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

#import "JGView.h"

@interface JGTextView : JGView

@property (nonatomic, copy) NSAttributedString *attributedString;
@property (nonatomic, copy) NSArray *paths;

@end

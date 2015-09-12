//
//  JGLabel.h
//  Klout
//
//  Created by Jamin Guy on 11/7/11.
//  Copyright (c) 2011 Jamin Guy. All rights reserved.
//

#import "JGTextView.h"

@interface JGLabel : JGTextView

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic) NSTextAlignment textAlignment;

@end

//
//  JGArrow.h
//  kscore
//
//  Created by Jamin Guy on 11/16/11.
//  Copyright (c) 2011 Jamin Guy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    JGArrowDirectionUp,
    JGArrowDirectionDown
} JGArrowDirection;

@interface JGArrow : UIView

@property (nonatomic) JGArrowDirection direction;

@end

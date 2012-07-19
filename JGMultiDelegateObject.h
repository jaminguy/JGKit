//
//  JGMultiDelegateObject.h
//  kscore
//
//  Created by Jamin Guy on 11/17/11.
//  Copyright (c) 2011 Jamin Guy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGMultiDelegateObject : NSObject

- (void)addObserver:(id)observer;
- (void)removeObserver:(id)observer;
- (void)notifyObserversWithBlock:(void (^)(id observer))block;

@end

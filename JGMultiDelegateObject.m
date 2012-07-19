//
//  JGMultiDelegateObject.m
//  kscore
//
//  Created by Jamin Guy on 11/17/11.
//  Copyright (c) 2011 Jamin Guy. All rights reserved.
//

#import "JGMultiDelegateObject.h"

@interface JGMultiDelegateObject ()

@property (nonatomic, strong) NSMutableSet *observers;
@property (nonatomic) dispatch_queue_t notificationQueue;

@end

@implementation JGMultiDelegateObject

@synthesize observers;
@synthesize notificationQueue;

- (id)init {
    self = [super init];
    if (self) {
        //observer setup
        //creates a set that won't retain objects
        NSMutableSet *mutableSet = (__bridge_transfer NSMutableSet *)CFSetCreateMutable(NULL, 0, NULL);
        self.observers = mutableSet;
        self.notificationQueue = dispatch_queue_create("com.jaminguy.JGMultiDelegateObjectQueue", NULL); 
    }
    return self;
}

- (void)addObserver:(id)observer {
    //__block __typeof__(self) blockSelf = self;
    dispatch_sync(self.notificationQueue, ^{
        [self.observers addObject:observer];
    }); 
}

- (void)removeObserver:(id)observer {
    //__block __typeof__(self) blockSelf = self;
    dispatch_sync(self.notificationQueue, ^{
        [self.observers removeObject:observer];
    });
}

- (void)notifyObserversWithBlock:(void (^)(id observer))block {
    //__block __typeof__(self) blockSelf = self;
    dispatch_async(self.notificationQueue, ^{ 
        for (id observer in self.observers) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(observer);
            });
        }
    });
}

@end

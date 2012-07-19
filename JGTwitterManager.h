//
//  JGTwitterManager.h
//  Klout
//
//  Created by Jamin Guy on 10/17/11.
//  Copyright (c) 2011 Jamin Guy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGTwitterManager : NSObject

typedef void(^JGTwitterManagerUsernamesCompletionBlock)(NSArray *usernames);

@property (nonatomic, strong, readonly) NSArray *accountUsernames;

+ (JGTwitterManager *)sharedInstance;

- (void)loadUsernamesWithCompletionHandler:(JGTwitterManagerUsernamesCompletionBlock)completion;

@end
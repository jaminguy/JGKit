//
//  JGTwitterManager.m
//  Klout
//
//  Created by Jamin Guy on 10/17/11.
//  Copyright (c) 2011 Jamin Guy. All rights reserved.
//

#import "JGTwitterManager.h"

#import <Accounts/Accounts.h>

@interface JGTwitterManager ()

@property (nonatomic, strong) NSArray *accountUsernames;
@property (nonatomic, copy) JGTwitterManagerUsernamesCompletionBlock userNamesCompletionBlock;

@end

@implementation JGTwitterManager

@synthesize accountUsernames;
@synthesize userNamesCompletionBlock;

+ (JGTwitterManager *)sharedInstance {
    static JGTwitterManager *sharedID = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedID = [[JGTwitterManager alloc] init];
    });
    return sharedID;
}

- (void)loadUsernamesWithCompletionHandler:(JGTwitterManagerUsernamesCompletionBlock)completion {
    self.userNamesCompletionBlock = completion;
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
	ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    __weak JGTwitterManager *weakSelf = self;
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if(granted) {
            NSMutableArray *usernames = [NSMutableArray array];
			[[accountStore accountsWithAccountType:accountType] enumerateObjectsUsingBlock:^(ACAccount *account, NSUInteger idx, BOOL *stop) {
                [usernames addObject:account.username];
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.accountUsernames = usernames;
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.userNamesCompletionBlock(weakSelf.accountUsernames);
            weakSelf.userNamesCompletionBlock = nil;
        });
        
	}];
}

@end

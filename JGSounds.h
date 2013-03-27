//
//  JGSounds.h
//  Klout
//
//  Created by Jamin Guy on 7/15/11.
//  Copyright 2011 Jamin Guy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    JGSystemSound_BeginVideoRecording = 1117,
    JGSystemSound_EndVideoRecording = 1118
} JGSystemSoundID;

typedef void (^JGSoundsAudioCompletionBlock)(void);

@interface JGSounds : NSObject

+ (void)playSoundWithName:(NSString *)name;
+ (void)playSystemSound:(UInt32)soundID completion:(JGSoundsAudioCompletionBlock)completion;


@end

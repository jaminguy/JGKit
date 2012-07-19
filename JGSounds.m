//
//  JGSounds.m
//  Klout
//
//  Created by Jamin Guy on 7/15/11.
//  Copyright 2011 Jamin Guy. All rights reserved.
//

#import "JGSounds.h"

#import <AudioToolbox/AudioToolbox.h>

@implementation JGSounds

+ (void)playSoundWithName:(NSString *)name {
    //Get the filename of the sound file:
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:name];
    
	//declare a system sound id
	SystemSoundID soundID;
    
	//Get a URL for the sound file
	NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    
	//Use audio sevices to create the sound
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    
	//Use audio services to play the sound
	AudioServicesPlaySystemSound(soundID);
}

@end

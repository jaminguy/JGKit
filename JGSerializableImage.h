//
//  JGSerializableImage.h
//  
//
//  Created by Jamin Guy on 7/6/10.
//  Copyright 2011 Jamin Guy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JGSerializableImage : UIImage <NSCoding> {
}

+ (id)imageWithData:(NSData *)data;

@end

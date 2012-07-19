//
//  JGSerializableImage.m
//
//
//  Created by Jamin Guy on 7/6/10.
//  Copyright 2011 Jamin Guy. All rights reserved.
//

#import "JGSerializableImage.h"


@implementation JGSerializableImage

+ (id)imageWithData:(NSData *)data {
	return [[JGSerializableImage alloc] initWithData:data];
}

- (id)initWithCoder:(NSCoder *)decoder {
	if(self = [super init]) {
		self = [self initWithData:[decoder decodeObjectForKey:@"image"]];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:UIImagePNGRepresentation(self) forKey:@"image"];	
}

@end

//
//  MF_Base32Additions.h
//  DBS_OTP1
//
//  Created by Luis Velando on 1/7/15.
//  Copyright (c) 2015 Luis Velando. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NSBase32StringEncoding  0x4D467E32

@interface NSString (Base32Addition)
+(NSString *)base64String:(NSString *)str;
+(NSString *)stringFromBase32String:(NSString *)base32String;
-(NSString *)base32String;
- (NSData *) stringToHexData;

@end

@interface NSData (Base32Addition)
+ (NSData *)base64DataFromString: (NSString *)string;
+ (NSData *)dataWithBase32String:(NSString *)base32String;
-(NSString *)base32String;
@end

@interface MF_Base32Codec : NSObject
+(NSData *)dataFromBase32String:(NSString *)base32String;
+(NSString *)base32StringFromData:(NSData *)data;
@end
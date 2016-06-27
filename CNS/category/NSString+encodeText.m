
//
//  NSString+encodeText.m
//  CNS
//
//  Created by Mac on 16/6/24.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import "NSString+encodeText.h"

//引入IOS自带密码库
#import <CommonCrypto/CommonCryptor.h>

#import <CommonCrypto/CommonDigest.h>

#import <Security/Security.h>

NSString *Base64String(NSString *a){
    
    return [a encodeForBase64];
    
}

//空字符串
static NSString *const NULLSTRING = @"";

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZaacdefghijklmnopqrstuvwxyz0123456789+/";

@implementation NSString (encodeText)



-(NSString *)encodeForBase64{
    
    if (self.length) {
        NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
        
        return [NSString base64FromData:data];
    }
    return NULLSTRING;
}


-(NSString *)decodeFromBase64{
    if (self.length) {
        NSData *data = [self dataFromBase64];
        
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return NULLSTRING;
}


-(NSString *)encodeForMd5{
    
    const char* str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];//
    
    //    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
    //        [ret appendFormat:@"%02x",result[i]];
    //    }
    [ret appendFormat:@"%02x",result[0]];
    for ( int i = 1 ; i< 16 ; i++) {
        [ret appendFormat:@"%02x",result[i]^result[0]];
    }
    return ret;
    
}

/**
 *  以下是内部方法
 */

/**
 *  从一个 data 中返回 string
 *
 *  @param data
 *
 *  @return
 */
+(NSString *)base64FromData:(NSData *)data{
    
    if ([data length] == 0)
        return NULLSTRING;
    
    char *characters = malloc((([data length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [data length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [data length])
            buffer[bufferLength++] = ((char *)[data bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}

- (NSData *)dataFromBase64{
    
    NSAssert(self != nil, @"the string can not be nil");
    
    if ([self length] == 0){
        return [NSData data];
    }
    static char *decodingTable = NULL;
    if (decodingTable == NULL)
    {
        decodingTable = malloc(256);
        if (decodingTable == NULL)
            return nil;
        memset(decodingTable, CHAR_MAX, 256);
        NSUInteger i;
        for (i = 0; i < 64; i++)
            decodingTable[(short)encodingTable[i]] = i;
    }
    
    const char *characters = [self cStringUsingEncoding:NSASCIIStringEncoding];
    if (characters == NULL)     //  Not an ASCII string!
        return nil;
    char *bytes = malloc((([self length] + 3) / 4) * 3);
    if (bytes == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (YES)
    {
        char buffer[4];
        short bufferLength;
        for (bufferLength = 0; bufferLength < 4; i++)
        {
            if (characters[i] == '\0')
                break;
            if (isspace(characters[i]) || characters[i] == '=')
                continue;
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
            {
                free(bytes);
                return nil;
            }
        }
        
        if (bufferLength == 0)
            break;
        if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
        {
            free(bytes);
            return nil;
        }
        
        //  Decode the characters in the buffer to bytes.
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        if (bufferLength > 2)
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        if (bufferLength > 3)
            bytes[length++] = (buffer[2] << 6) | buffer[3];
    }
    
    bytes = realloc(bytes, length);
    return [NSData dataWithBytesNoCopy:bytes length:length];
}



@end

//
//  NSString+SWExtention.m
//  Category
//
//  Created by ZSW on 2020/3/30.
//  Copyright © 2020 ZSW. All rights reserved.
//

#import "NSString+SWExtention.h"
#include <CommonCrypto/CommonDigest.h>
#import "NSObject+swizzle.h"

#define FileHashDefaultChunkSizeForReadingData 1024*8

@implementation NSString (SWExtention)

- (NSArray<NSTextCheckingResult *> *)detectorTypeLinkCheck {
    if(self == nil || self.length < 1) return nil;
    
    // 链接匹配条件
    NSString *regulaStr = @"((https?|s?ftp|irc[6s]?|git|afp|telnet|smb)://)?((\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})|((www\\.|[a-zA-Z\\.\\-]+\\.)?[a-zA-Z0-9\\-]+\\.(top|com.cn|com|net|org|edu|gov|int|mil|cn|tel|biz|cc|tv|info|name|hk|mobi|asia|cd|travel|pro|museum|coop|aero|ad|ae|af|ag|ai|al|am|an|ao|aq|ar|as|at|au|aw|az|ba|bb|bd|be|bf|bg|bh|bi|bj|bm|bn|bo|br|bs|bt|bv|bw|by|bz|ca|cc|cf|cg|ch|ci|ck|cl|cm|cn|co|cq|cr|cu|cv|cx|cy|cz|de|dj|dk|dm|do|dz|ec|ee|eg|eh|es|et|ev|fi|fj|fk|fm|fo|fr|ga|gb|gd|ge|gf|gh|gi|gl|gm|gn|gp|gr|gt|gu|gw|gy|hk|hm|hn|hr|ht|hu|id|ie|il|in|io|iq|ir|is|it|jm|jo|jp|ke|kg|kh|ki|km|kn|kp|kr|kw|ky|kz|la|lb|lc|li|lk|lr|ls|lt|lu|lv|ly|ma|mc|md|mg|mh|ml|mm|mn|mo|mp|mq|mr|ms|mt|mv|mw|mx|my|mz|na|nc|ne|nf|ng|ni|nl|no|np|nr|nt|nu|nz|om|qa|pa|pe|pf|pg|ph|pk|pl|pm|pn|pr|pt|pw|py|re|ro|ru|rw|sa|sb|sc|sd|se|sg|sh|si|sj|sk|sl|sm|sn|so|sr|st|su|sy|sz|tc|td|tf|tg|th|tj|tk|tm|tn|to|tp|tr|tt|tv|tw|tz|ua|ug|uk|us|uy|va|vc|ve|vg|vn|vu|wf|ws|ye|yu|za|zm|zr|zw)(:[0-9]{1,5})?))((/[a-zA-Z0-9\\./,;\\?'\\+&%\\$#=~_\\-]*)|([^\\u4e00-\\u9fa5\\s0-9a-zA-Z\\./,;\\?'\\+&%\\$#=~_\\-]*))";
    NSError *error = nil;
    // 根据匹配条件，创建了一个正则表达式
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    return [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
}

- (BOOL)stringContainsEmoji {
    if (self == nil || [self length] < 1)  return NO;
    
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    return returnValue;
}

- (NSString *)stringDisableEmoji {
    if (self == nil || [self length] < 1)  return @"";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:self
                                                               options:0
                                                                 range:NSMakeRange(0, [self length])
                                                          withTemplate:@""];
    return modifiedString;
}

- (BOOL)stringIsNumber {
    if (self == nil || [self length] < 1)  return NO;
    
    NSString *phoneNumber = @"^\\d+$";//纯数字
    NSPredicate *lowPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneNumber];
    return [lowPred evaluateWithObject:self];
}

- (BOOL)stringIsPhoneNumber:(BOOL)bSimple {
    if (self == nil || [self length] < 1 || ![self stringIsNumber])  return NO;
    
    if(!bSimple){
        NSString *num = @"^(13[0-9]|14[579]|15[0-3,5-9]|16[67]|17[0135678]|18[0-9]|19[689]\\d{8}$)";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", num];
        return [pred evaluateWithObject:num];
    }else{
       return (self.length == 11);
    }
}

- (BOOL)stringIsEmail {
    if (self == nil || [self length] < 1)  return NO;
    
    NSString *emailStr = @"^([a-zA-Z0-9_.-])+@(([a-zA-Z0-9])+.)+([a-zA-Z0-9]{2,4})+$";
    NSPredicate *emailPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailStr];
    return [emailPre evaluateWithObject:self];
}

- (NSString *)base64encode {
    if (self == nil || [self length] < 1)  return @"";
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *base64Data = [data base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return [[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
}

- (NSString *)base64decode {
    if (self == nil || [self length] < 1)  return @"";
    
    NSData *data = [[NSData alloc]initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString *)encodeStringUTF8 {
    if (self == nil || [self length] < 1)  return @"";
    
    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *encodedString = [self stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return encodedString;
}

- (NSString *)decodeStringUTF8 {
    if (self == nil || [self length] < 1)  return @"";
    
    return [self stringByRemovingPercentEncoding];
}

- (NSString *)decodeStringMD5 {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

- (NSArray *)stringToArray {
    id data = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    if ([data isKindOfClass:[NSArray class]]) {
        return data;
    }
    return nil;
}

- (NSDictionary *)stringToDictionary {
    id data = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    if ([data isKindOfClass:[NSDictionary class]]) {
        return data;
    }
    return nil;
}

+ (NSString *)stringRandomNumber {
    NSInteger timeInterval = [NSDate date].timeIntervalSince1970 * 1000000;
    NSString *randomNumber = [NSString stringWithFormat:@"%ld%u", (long)timeInterval, arc4random() % 100000];
    return randomNumber;
}

+ (NSString *)fileMd5HashCreateWithPath:(NSString *)filePath {
    if (filePath == nil || [filePath length] < 1) return @"";
        
        // Declare needed variables
        CFStringRef result = nil;
        CFReadStreamRef readStream = nil;
        // Get the file URL
        CFURLRef fileURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                                         (CFStringRef)filePath,
                                                         kCFURLPOSIXPathStyle,
                                                         (Boolean)false);
        if (!fileURL) goto done;
        // Create and open the read stream
        readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                                (CFURLRef)fileURL);
        if (!readStream) goto done;
        bool didSucceed = (bool)CFReadStreamOpen(readStream);
        if (!didSucceed) goto done;
        // Initialize the hash object
        CC_MD5_CTX hashObject;
        CC_MD5_Init(&hashObject);
        // Make sure chunkSizeForReadingData is valid
        size_t chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
        // Feed the data to the hash object
        bool hasMoreData = true;
        while (hasMoreData) {
            uint8_t buffer[chunkSizeForReadingData];
            CFIndex readBytesCount = CFReadStreamRead(readStream,(UInt8 *)buffer,(CFIndex)sizeof(buffer));
            if (readBytesCount == -1) break;
            if (readBytesCount == 0) {
                hasMoreData = false;
                continue;
            }
            CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)readBytesCount);
        }
        // Check if the read operation succeeded
        didSucceed = !hasMoreData;
        // Compute the hash digest
        unsigned char digest[CC_MD5_DIGEST_LENGTH];
        CC_MD5_Final(digest, &hashObject);
        // Abort if the read operation failed
        if (!didSucceed) goto done;
        // Compute the string result
        char hash[2 * sizeof(digest) + 1];
        for (size_t i = 0; i < sizeof(digest); ++i) {
            snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
        }
        result = CFStringCreateWithCString(kCFAllocatorDefault,(const char *)hash,kCFStringEncodingUTF8);
        
    done:
        if (readStream) {
            CFReadStreamClose(readStream);
            CFRelease(readStream);
        }
        
        if (fileURL) {
            CFRelease(fileURL);
        }
        
        return (__bridge_transfer NSString *)result;
}

+ (CGSize)stringSizeWith:(NSString *)string width:(CGFloat)width font:(UIFont *)font {
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading;
    return [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:options attributes:@{NSFontAttributeName:font} context:nil].size;
}

@end

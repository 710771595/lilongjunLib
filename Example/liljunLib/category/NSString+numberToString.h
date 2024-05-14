//
//  NSString+numberToString.h
//  LiveFoundation
//
//  Created by liuning on 2020/9/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (numberToString)
+ (NSString *)converNumberToString:(NSInteger)num;
+ (NSString *)palyerTimeToString:(NSInteger)time;
- (BOOL)isNumber;
+ (NSString*) createUUIDWithRandomNumber;
+(NSDictionary *)dictionaryWithUrlString:(NSString *)urlStr;

@end

NS_ASSUME_NONNULL_END

//
//  NSString+numberToString.m
//  LiveFoundation
//
//  Created by liuning on 2020/9/23.
//

#import "NSString+numberToString.h"

@implementation NSString (numberToString)
+ (NSString *)converNumberToString:(NSInteger)num {
    if (num < 10000) {
        return [NSString stringWithFormat:@"%ld",num];
    } else {
        return [NSString stringWithFormat:@"%@万+", @([[NSString stringWithFormat:@"%.1f",(float)num / 10000] floatValue])];
    }
}

+ (NSString *)palyerTimeToString:(NSInteger)time {
    if (time < 0) {
        time = 0;
    }
    NSInteger h = time / 3600;
    NSInteger m = (time % 3600) / 60;
    NSInteger s = time % 60;
    NSString *desc = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)h, (long)m, (long)s];
    return desc;
}

- (BOOL)isNumber {
    NSString *number = @"^[0-9]*$";
    return [self isConformRegular:number];
}

- (BOOL)isConformRegular:(NSString *)regular {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
    return [predicate evaluateWithObject:self];
}


+(NSString*) createUUIDWithRandomNumber
{
    char data[10];
    
    for (int x=0;x<10;data[x++] = (char)('A' + (arc4random_uniform(26))));
    
    NSDate *  datenow=[NSDate date];
    
    NSString *ns_sendCount = [[NSUserDefaults standardUserDefaults] objectForKey:@"sendMessageCount"];
    int sendCount = [ns_sendCount intValue];
    NSDate *preSendTime = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"preSendTime"];
    
    if (preSendTime == nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:datenow forKey:@"preSendTime"];
    }
    else
    {
        NSCalendar *chineseClendar = [ [ NSCalendar alloc ] initWithCalendarIdentifier:NSGregorianCalendar];
        
        NSUInteger unitFlags =  NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit | NSDayCalendarUnit| NSMonthCalendarUnit | NSYearCalendarUnit;
        
        NSDateComponents *DateComponent = [chineseClendar components:unitFlags fromDate:preSendTime toDate:datenow options:0];
        
        if ([DateComponent day] > 0)
        {
            [[NSUserDefaults standardUserDefaults] setObject:datenow forKey:@"preSendTime"];
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"sendMessageCount"];
            sendCount = 0;
        }
        else
        {
            sendCount ++;
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",sendCount] forKey:@"sendMessageCount"];
        }
        
    }
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    NSString * n_str = [NSString stringWithFormat:@"%@%@%@%@%@",
                        [[NSString alloc] initWithBytes:data length:10 encoding:NSUTF8StringEncoding]
                        ,@"-"
                        ,timeSp
                        ,@"-"
                        ,[NSString stringWithFormat:@"%d",sendCount]];
    
    return n_str;
}

+(NSDictionary *)dictionaryWithUrlString:(NSString *)urlStr

{
    if (urlStr && urlStr.length && [urlStr rangeOfString:@"?"].length == 1) {
        
        NSArray *array = [urlStr componentsSeparatedByString:@"?"];
        if (array && array.count >=2 ) {
           __block NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx  >= 1) {
                    //只处理参数部分
                    NSString *paramsStr = array[idx];
                    if (paramsStr.length) {
                        NSArray *paramArray = [paramsStr componentsSeparatedByString:@"&"];
                        for (NSString *param in paramArray) {
                            if (param && param.length) {
                                NSArray *parArr = [param componentsSeparatedByString:@"="];
                                if (parArr.count >= 2) {
                                    [paramsDict setObject:parArr[1] forKey:parArr[0]];
                                }
                            }
                        }
                    }
                }
            }];
            return paramsDict;
//            NSString *paramsStr = array[1];
//            if (paramsStr.length) {
//                NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
//                NSArray *paramArray = [paramsStr componentsSeparatedByString:@"&"];
//                for (NSString *param in paramArray) {
//                    if (param && param.length) {
//                        NSArray *parArr = [param componentsSeparatedByString:@"="];
//                        if (parArr.count >= 2) {
//                            [paramsDict setObject:parArr[1] forKey:parArr[0]];
//                        }
//                    }
//                }
//                return paramsDict;
//            }else{
//                return nil;
//            }
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}
@end
